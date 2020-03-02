//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Security
import Foundation

class KeyChainKeyStore: NSObject, KeyStore {
    
    /// Name of the service we pass to keychain queries as kSecAttrService
    private let keychainWrapperServiceName: String
    
    /// Keychain Wrapper to handle read, write, and delete queries from KeyChain.
    private let keyChainWrapper: KeychainWrapper
    
    /**
        Initialize a KeychainKeyStore Object.
     
        - Parameters:
            - serviceName: Name of the service we pass to keychain queries as kSecAttrService
     */
    public init(serviceName: String) {
        self.keychainWrapperServiceName = serviceName
        self.keyChainWrapper = KeychainWrapper(serviceName: serviceName)
    }
    
    func getSecretKeyContainer(keyReference: String) throws -> SecretKeyContainer {
        let keyContainer = try getKeyFromKeyStore(keyReference)
        if let secretKeyContainer = keyContainer as? SecretKeyContainer {
            return secretKeyContainer
        } else {
            throw KeyStoreError.KeysInContainerNotSecretKeys
        }
    }
    
    func getPrivateKeyContainer(keyReference: String) throws -> PrivateKeyContainer {
        let keyContainer = try getKeyFromKeyStore(keyReference)
        if let privateKeyContainer = keyContainer as? PrivateKeyContainer {
            return privateKeyContainer
        } else {
            throw KeyStoreError.KeysInContainerNotPrivateKeys
        }
    }
    
    // TODO figure out if I need this.
//    func getPublicKeyContainer(keyReference: String) throws -> PublicKeyContainer {
//        let keyContainer = try getKeyFromKeyStore(keyReference)
//        if let privateKeyContainer = keyContainer as? PrivateKeyContainer {
//            return privateKeyContainer
//        } else {
//            throw KeyStoreError.KeysInContainerNotPrivateKeys
//        }
//    }
    
    private func getKeyFromKeyStore(_ keyReference: String) throws -> KeyContainer {
        let keyResults = keyChainWrapper.read(withCaseSensitiveKey: keyReference)
        guard keyResults.0 == .Success else {
            throw CryptoError.NoKeyFoundFor(keyName: keyReference)
        }
        
        if let keyData = keyResults.1 {
            let decoder = JSONDecoder()
            return try decoder.decode(KeyContainer.self, from: keyData)
        }
    }
    
    func save(withCaseSensitiveKeyReference keyReference: String, key: KeyStoreItem) throws {
        let encoder = JSONEncoder()
        var encodedKey: Data
        switch key.kty {
        case .EllipticCurve:
            encodedKey = try encoder.encode(key as! EllipticCurvePrivateKey)
        case .Octets:
            encodedKey = try encoder.encode(key as! SecretKey)
        case .RSA:
            encodedKey = try encoder.encode(key as! RsaPrivateKey)
        }
        let result = self.keyChainWrapper.write(withCaseSensitiveKey: keyReference, value: encodedKey)
        if result != .Success {
            throw KeyStoreError.KeyNotSavedProperly(reason: result)
        }
    }
    
    func list() throws -> [String : KeyStoreListItem] {
        throw CryptoError.NotImplemented
    }
    
    /**
    Creates a dictionary filled with attributes (metadata) used in keychain queries.
     
    - Parameter keyOptional: kSecAttrAccount attribute. Pass in nil if not used.
     
    - Returns: Mutable dictionary for use in keychain queries.
     */
    private func keychainQuery(_ keyOptional:String?) -> [String : AnyObject]
    {
        var query = [String:AnyObject]()
        query[String(_cocoaString: kSecClass)] = kSecClassGenericPassword
        query[String(_cocoaString: kSecAttrService)] = (keychainWrapperServiceName as AnyObject)
        if let key = keyOptional
        {
            query[String(_cocoaString: kSecAttrAccount)] = (key as AnyObject)
        }
        return query
    }
}
