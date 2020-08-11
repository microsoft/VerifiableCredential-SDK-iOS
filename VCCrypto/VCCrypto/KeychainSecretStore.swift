/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

enum KeychainStoreError: Error {
    case SaveToStoreError(status: Int32)
    case ItemNotFound
    case ReadFromStoreError(status: Int32)
    case InvalidItemInStore
    case ItemAlreadyInStore
    case InvalidSecretType
    case InvalidType
}

struct KeychainSecretStore : SecretStoring {
    
    private let vcService = "com.microsoft.vcCrypto"
    
    func getSecret(id: UUID, type: String) throws -> Data {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: id.uuidString,
                     kSecAttrService: vcService,
                     kSecAttrType: type,
                     kSecReturnData: true] as [String: Any]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainStoreError.ItemNotFound }
        guard status == errSecSuccess else { throw KeychainStoreError.ReadFromStoreError(status: status) }
        guard var value = item as? Data else { throw KeychainStoreError.InvalidItemInStore }
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
    ///   - type: The secret type (4 chars)
    ///   - value: The value of the secret
    func saveSecret(id: UUID, type: String, value: inout Data) throws  {
        defer {
            let secretSize = value.count
            value.withUnsafeMutableBytes { (secretPtr) in
                memset_s(secretPtr.baseAddress, secretSize, 0, secretSize)
                return
            }
        }
        
        guard type.count == 4 else { throw KeychainStoreError.InvalidType }
        
        // kSecAttrAccount is used to store the secret Id so that we can look it up later
        // kSecAttrService is always set to vcService to enable us to lookup all our secrets later if needed
        // kSecAttrType is used to store the secret type to allow us to cast it to the right Type on search
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: id.uuidString,
                     kSecAttrService: vcService,
                     kSecAttrType: type,
                     kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                     kSecValueData: value] as [String: Any]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainStoreError.SaveToStoreError(status: status)}
    }
}
