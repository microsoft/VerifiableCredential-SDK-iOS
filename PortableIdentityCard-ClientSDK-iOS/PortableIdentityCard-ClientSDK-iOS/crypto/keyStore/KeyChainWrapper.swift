//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Security
import Foundation

/// Enum for KeychainWrapper operation results.
public enum KeychainResult
{
    case Success
    case NotFound
    case ParsingError
    case KeychainError
}

/**
    A Wrapper class for keychain operations (read/write/delete)
 
    - Important:
        - These operations are not atomic.
        - The caller is responsible for handling race condition between
            read/write/delete operation with the same serviceName.
 */
public class KeychainWrapper
{
    /// Key of the entry storing a dummy value to determine if a device has a passcode set.
    private static let checkDevicePasscodeDummyKey = "checkDevicePasscodeKey"
    
    /// The dummy value to store used to determine if a device has a passcode set.
    private static let checkDevicePasscodeDummyValue = "checkDevicePasscodeValue".data(using: .utf8)
    
    /// Name of the service we pass to keychain queries as kSecAttrService
    private let KeychainWrapperServiceName: String
    
    /// Logger initialized with the consumer's domain.
    private let logger: Logger
    
    /**
        Initialize a KeychainWrapper object.
     
        - Parameters:
            - logDomain: Log domain of the consumer of this object.
            - serviceName: Name of the service we pass to keychain queries as kSecAttrService
                           (i.e. "com.microsoft.AADNGCAuthentication").
     */
    public init(serviceName: String)
    {
        self.KeychainWrapperServiceName = serviceName
        
        self.logger = Logger()
    }
    
    /**
         Read data from keychain.
     
         - Important:
             - These operations are not atomic.
             - The caller is responsible for handling race condition between
             read/write/delete operation with the same serviceName.
     
         - Parameter key: the key for reading the value in the keychain. Case-sensitive.
     
         - Returns: a tuple of data read from the keychain and a KeychainResult object.
     */
    public func read(withCaseSensitiveKey key:String) -> (KeychainResult, Data?)
    {
        var query = keychainQuery(key)
        query[kSecReturnData as String] = (true as AnyObject)
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &queryResult)
        
        guard status != errSecItemNotFound else
        {
            logger.logTrace(.error, "Failed to read data for key:\(key) from keychain. Item not found.")
            return (KeychainResult.NotFound, nil)
        }
        
        guard status == noErr else
        {
            logger.logTrace(.error, "Failed to read data for key:\(key) from keychain. OSStatus:\(status)")
            return (KeychainResult.KeychainError, nil)
        }
        
        guard let data = queryResult as? Data else
        {
            logger.logTrace(.error, "Failed to parse the data for key:\(key) from keychain.")
            return (KeychainResult.ParsingError, nil)
        }
        
        logger.logTrace(.verbose, "Successfully read data for key:\(key) from keychain.")
        return (KeychainResult.Success, data)
    }
    
    /**
        Reads all the keys and associated values from keychain.
     
        - Important:
            - These operations are not atomic.
            - The caller is responsible for handling race condition between
                read/write/delete operation with the same serviceName.
            - This function only returns the items in the serviceName provided in the init.
     
        - Returns: a tuple of data read from the keychain and a KeychainResult object.
     */
    public func readAllItems() -> (KeychainResult, [String:Data]?)
    {
        var query = keychainQuery(nil)
        query[kSecReturnData as String] = (kCFBooleanTrue as AnyObject)
        query[kSecReturnAttributes as String] = (kCFBooleanTrue as AnyObject)
        query[kSecReturnRef as String] = (kCFBooleanTrue as AnyObject)
        query[kSecMatchLimit as String] = (kSecMatchLimitAll as AnyObject)
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &queryResult)
        
        var items = [String:Data]()
        
        guard status != errSecItemNotFound else
        {
            logger.logTrace(.verbose, "No items found in keychain.")
            return (KeychainResult.Success, items)
        }
        
        guard status == noErr else
        {
            logger.logTrace(.error, "Failed to read from keychain. OSStatus:\(status)")
            return (KeychainResult.KeychainError, nil)
        }
        
        guard let data = queryResult as? Array<Dictionary<String, Any>> else
        {
            logger.logTrace(.error, "Failed to parse the data read from keychain.")
            return (KeychainResult.ParsingError, nil)
        }
        
        logger.logTrace(.verbose, "Successfully read \(data.count) items from keychain.")
        for item in data
        {
            if let key = item[kSecAttrAccount as String] as? String,
                let value = item[kSecValueData as String] as? Data
            {
                items[key] = value
            }
        }
        
        return (KeychainResult.Success, items)
    }
    
    /**
        Write data to keychain.
     
        - Important:
            - This operation is not atomic.
            - The caller is responsible for handling race condition between read/write/delete operation with the same serviceName.
     
        - Parameters:
            - key: the key for storing the value in the keychain. Case-sensitive.
            - value:  a value to be written to keychain.
            - accessPolicy: access attribute on the entry.
     
        - Returns: a KeychainResult object.
     */
    public func write(withCaseSensitiveKey key:String, value:Data, accessPolicy:CFString? = nil) -> KeychainResult
    {
        let readStatus = read(withCaseSensitiveKey: key).0
        
        let writeResult:OSStatus
        switch (readStatus)
        {
            case .Success:
                logger.logTrace(.verbose, "Overwriting an existing entry for key:\(key).")
                writeResult = updateEntry(key, value, accessPolicy)
            case .NotFound:
                logger.logTrace(.verbose, "Key:\(key) doesn't exist in keychain. Creating a new entry.")
                writeResult = createEntry(key, value, accessPolicy)
            default:
                logger.logTrace(.error, "Failed to write data for key:\(key) to keychain due to a read error.")
                return readStatus
        }
        
        guard writeResult == noErr
            else
        {
            logger.logTrace(.error, "Failed to write to key:\(key) to keychain. OSStatus:\(writeResult)")
            return KeychainResult.KeychainError
        }
        
        logger.logTrace(.verbose, "Successfully write data for key:\(key) to keychain.")
        return KeychainResult.Success
    }
    
    /**
        Delete data from keychain.
     
        - Important:
            - This operation is not atomic.
            - The caller is responsible for handling race condition between read/write/delete operation with the same serviceName.
     
        - Parameter key: the key for storing the value in the keychain. Case-sensitive.
     
        - Returns: a KeychainResult object.
     */
    public func delete(withCaseSensitiveKey key:String) -> KeychainResult
    {
        let readStatus = read(withCaseSensitiveKey: key).0
        
        guard readStatus != KeychainResult.NotFound else
        {
            logger.logTrace(.verbose, "The entry for key:\(key) doesn't exist in the keychain.")
            return KeychainResult.Success
        }
        
        guard readStatus == KeychainResult.Success else
        {
            logger.logTrace(.error, "Failed to delete data for key:\(key) from keychain due to a read error.")
            return readStatus
        }
        
        let deleteStatus = deleteEntry(key)
        guard deleteStatus == noErr else
        {
            logger.logTrace(.error, "Failed to delete data for key:\(key) from keychain. OSStatus:\(deleteStatus)")
            return KeychainResult.KeychainError
        }
        
        logger.logTrace(.verbose, "Successfully delete data for key:\(key) from keychain.")
        return KeychainResult.Success
    }
    
    /**
     Delete all items from the keychain under KeychainWrapperServiceName.
     
     - Returns: KeychainResult object.
     */
    public func deleteAllItems() -> KeychainResult
    {
        let query = keychainQuery(nil)
        
        let deleteAllStatus = SecItemDelete(query as CFDictionary)
        
        guard deleteAllStatus == noErr else
        {
            // Keychain for this service name is already empty.
            if deleteAllStatus == errSecItemNotFound
            {
                logger.logTrace(.info,
                                "Keychain for serviceName:\(self.KeychainWrapperServiceName) is already empty.")
                
                return KeychainResult.Success
            }
            
            logger.logTrace(.error, "Failed to delete data for serviceName:\(self.KeychainWrapperServiceName) from keychain. OSStatus:\(deleteAllStatus)")
            
            return KeychainResult.KeychainError
        }
        
        logger.logTrace(.verbose, "Successfully deleted all data for serviceName:\(self.KeychainWrapperServiceName) from keychain.")
        
        return KeychainResult.Success
    }
    
    /**
        Delete an existing entry in keychain.
     
        - Parameter key: the key of an entry in the keychain.
     
        - Returns: the operation's status.
     */
    private func deleteEntry(_ key:String) -> OSStatus
    {
        let query = keychainQuery(key)
        return SecItemDelete(query as CFDictionary)
    }
    
    /**
        Overwrite the data in an existing entry in keychain.
     
        - Parameters:
            - key: the key of an entry in the keychain.
            - value: a value to be written to keychain.
            - accessPolicy: access attribute on the entry.
     
        - Returns: the operation's status.
     */
    private func updateEntry(_ key:String, _ value:Data, _ accessPolicy:CFString?) -> OSStatus
    {
        var attributesToUpdate = [String : AnyObject]()
        attributesToUpdate[kSecValueData as String] = (value as AnyObject)
        if let accessPolicy = accessPolicy
        {
            attributesToUpdate[kSecAttrAccessible as String] = accessPolicy
        }
        let query = keychainQuery(key)
        return SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
    }
    
    /**
        Create a new data entry in keychain, and save the data.
     
        - Parameters:
            - key: the key of an entry in the keychain.
            - value: a value to be written to keychain.
            - accessPolicy: access attribute on the entry.
     
        - Returns: the operation's status.
     */
    private func createEntry(_ key:String, _ value:Data, _ accessPolicy:CFString?) -> OSStatus
    {
        var attributesToUpdate = keychainQuery(key)
        attributesToUpdate[kSecValueData as String] = (value as AnyObject)
        if let accessPolicy = accessPolicy
        {
            attributesToUpdate[kSecAttrAccessible as String] = accessPolicy
        }
        
        return SecItemAdd(attributesToUpdate as CFDictionary, nil)
    }
    
    /**
        Checks if device has passcode set by reading/writing a dummy value.
        Note that we will use this to check for presence of passcode on Apple Watch, since there is no direct API to use in WatchKit (as opposed to iOS).
     
        - Returns: True if the device has a passcode set; false otherwise.
     */
    public func checkIfDeviceHasPasscode() -> Bool
    {
        // Attempt to read dummy value that's accessible only when passcode is set.
        var query = keychainQuery(KeychainWrapper.checkDevicePasscodeDummyKey)
        query[kSecReturnData as String] = (true as AnyObject)

        let readStatus = SecItemCopyMatching(query as CFDictionary, nil)
        
        guard readStatus != errSecItemNotFound else
        {
            // If value not found, then attempt to write it.
            var attributesToUpdate = keychainQuery(KeychainWrapper.checkDevicePasscodeDummyKey)
            attributesToUpdate[kSecValueData as String] = (KeychainWrapper.checkDevicePasscodeDummyValue as AnyObject)
            attributesToUpdate[kSecAttrAccessible as String] = (kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as AnyObject)
            
            let writeStatus = SecItemAdd(attributesToUpdate as CFDictionary, nil)
            
            // A successful write means a passcode is set.
            return writeStatus == noErr
        }
        
        // A successful read means a passcode is set.
        return readStatus == noErr
    }
    
    /**
        Creates a dictionary filled with attributes (metadata) used in keychain queries.
     
        - Parameter keyOptional: kSecAttrAccount attribute. Pass in nil if not used.
     
        - Returns: Mutable dictionary for use in keychain queries.
     */
    private func keychainQuery(_ keyOptional:String?) -> [String : AnyObject]
    {
        var query = [String:AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = (KeychainWrapperServiceName as AnyObject)
        if let key = keyOptional
        {
            query[kSecAttrAccount as String] = (key as AnyObject)
        }
        
        return query
    }
}

