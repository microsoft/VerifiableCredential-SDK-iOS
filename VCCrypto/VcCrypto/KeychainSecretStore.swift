/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

enum KeychainStoreError: Error {
    case saveToStoreError(status: Int32)
    case itemNotFound
    case readFromStoreError(status: Int32)
    case invalidItemInStore
    case itemAlreadyInStore
    case invalidType
}

struct KeychainSecretStore : SecretStoring {
    
    private let vcService = "com.microsoft.vcCrypto"
    
    /// Gets the secret with the id passed in parameter
    /// - Parameters:
    ///   - id: The Id of the secret
    ///   - itemTypeCode: the item type code for the secret
    /// - Returns: The secret
    func getSecret(id: UUID, itemTypeCode: String) throws -> Data {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: id.uuidString,
                     kSecAttrService: vcService,
                     kSecAttrType: itemTypeCode,
                     kSecReturnData: true] as [String: Any]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainStoreError.itemNotFound }
        guard status == errSecSuccess else { throw KeychainStoreError.readFromStoreError(status: status) }
        guard var value = item as? Data else { throw KeychainStoreError.invalidItemInStore }
        defer {
            let secretSize = value.count
            value.withUnsafeMutableBytes { (secretPtr) in
                memset_s(secretPtr.baseAddress, secretSize, 0, secretSize)
                return
            }
        }
        
        return value
    }
    
    /// Save the secret to keychain
    /// Note: the value passed in will be zeroed out after the secret is saved
    /// - Parameters:
    ///   - id: The Id of the secret
    ///   - itemTypeCode: The secret type code (4 chars)
    ///   - value: The value of the secret
    func saveSecret(id: UUID, itemTypeCode: String, value: inout Data) throws  {
        defer {
            let secretSize = value.count
            value.withUnsafeMutableBytes { (secretPtr) in
                memset_s(secretPtr.baseAddress, secretSize, 0, secretSize)
                return
            }
        }
        
        guard itemTypeCode.count == 4 else { throw KeychainStoreError.invalidType }
        
        // kSecAttrAccount is used to store the secret Id so that we can look it up later
        // kSecAttrService is always set to vcService to enable us to lookup all our secrets later if needed
        // kSecAttrType is used to store the secret type to allow us to cast it to the right Type on search
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: id.uuidString,
                     kSecAttrService: vcService,
                     kSecAttrType: itemTypeCode,
                     kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                     kSecValueData: value] as [String: Any]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainStoreError.saveToStoreError(status: status)}
    }
}
