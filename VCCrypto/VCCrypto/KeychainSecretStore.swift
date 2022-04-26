/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

public enum KeychainStoreError: Error {
    case deleteFromStoreError(status: OSStatus)
    case saveToStoreError(status: Int32)
    case readFromStoreError(status: OSStatus)
}

struct KeychainSecretStore : SecretStoring {
    
    private let vcService = "com.microsoft.vcCrypto"
    
    /// Gets the secret with the id passed in parameter
    /// - Parameters:
    ///   - id: The Id of the secret
    ///   - itemTypeCode: the item type code for the secret
    ///   - accessGroup: the access group for the secret
    /// - Returns: The secret
    func getSecret(id: UUID, itemTypeCode: String, accessGroup: String?) throws -> Data {
        
        var query: [String: Any]
        if let accessGroup = accessGroup
        {
            query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: id.uuidString,
                     kSecAttrService: vcService,
                     kSecAttrType: itemTypeCode,
                     kSecAttrAccessGroup: accessGroup,
                     kSecReturnData: true] as [String: Any]
        }
        else
        {
            query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: id.uuidString,
                     kSecAttrService: vcService,
                     kSecAttrType: itemTypeCode,
                     kSecReturnData: true] as [String: Any]
        }
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw SecretStoringError.itemNotFound }
        guard status == errSecSuccess else { throw KeychainStoreError.readFromStoreError(status: status as OSStatus) }
        guard var value = item as? Data else { throw SecretStoringError.invalidItemInStore }
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
    ///   - accessGroup: The access group to use to save secret.
    ///   - value: The value of the secret
    func saveSecret(id: UUID, itemTypeCode: String, accessGroup: String? = nil, value: inout Data) throws {
        defer {
            let secretSize = value.count
            value.withUnsafeMutableBytes { (secretPtr) in
                memset_s(secretPtr.baseAddress, secretSize, 0, secretSize)
                return
            }
        }
        
        guard itemTypeCode.count == 4 else { throw SecretStoringError.invalidType }
        
        // kSecAttrAccount is used to store the secret Id so that we can look it up later
        // kSecAttrService is always set to vcService to enable us to lookup all our secrets later if needed
        // kSecAttrType is used to store the secret type to allow us to cast it to the right Type on search
        var query: [String: Any]
        if let accessGroup = accessGroup {
            query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: id.uuidString,
                     kSecAttrService: vcService,
                     kSecAttrType: itemTypeCode,
                     kSecAttrAccessGroup: accessGroup,
                     kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                     kSecValueData: value] as [String: Any]
        }
        else {
            query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: id.uuidString,
                     kSecAttrService: vcService,
                     kSecAttrType: itemTypeCode,
                     kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                     kSecValueData: value] as [String: Any]
        }
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainStoreError.saveToStoreError(status: status)
        }
    }
    
    /// Delete the secret from keychain
    /// Note: the value passed in will be zeroed out after the secret is deleted
    /// - Parameters:
    ///   - id: The Id of the secret
    ///   - itemTypeCode: The secret type code (4 chars)
    ///   - accessGroup: The access group of the secret.
    func deleteSecret(id: UUID, itemTypeCode: String, accessGroup: String? = nil) throws {
        
        guard itemTypeCode.count == 4 else { throw SecretStoringError.invalidType }
        
        // kSecAttrAccount is used to store the secret Id so that we can look it up later
        // kSecAttrService is always set to vcService to enable us to lookup all our secrets later if needed
        // kSecAttrType is used to store the secret type to allow us to cast it to the right Type on search
        var query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: id.uuidString,
                     kSecAttrService: vcService,
                     kSecAttrType: itemTypeCode,
                     kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly] as [String: Any]
        
        if let accessGroup = accessGroup,
               accessGroup != "" {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainStoreError.deleteFromStoreError(status: status)
        }
    }
    
    /// Save the secret to keychain
    /// - Parameters:
    ///   - secret: the secret container
    func save(secret: VCCryptoSecret) throws {
        
        let (ephemeral, itemTypeCode) = try Self.secretDataAndItemTypeCodeFor(secret: secret)
        var data = Data()
        data.append(ephemeral.value)
        try self.saveSecret(id: secret.id,
                            itemTypeCode: itemTypeCode,
                            accessGroup: secret.accessGroup,
                            value: &data)
    }

    /// Remove a secret from the keychain
    /// - Parameters:
    ///   - secret: the secret reference
    func delete(secret: VCCryptoSecret) throws {
        
        let (_, itemTypeCode) = try Self.secretDataAndItemTypeCodeFor(secret: secret)
        try self.deleteSecret(id: secret.id,
                              itemTypeCode: itemTypeCode,
                              accessGroup: secret.accessGroup)
    }

    private static func secretDataAndItemTypeCodeFor(secret: VCCryptoSecret) throws -> (EphemeralSecret, String) {

        // Get out the secret data
        let ephemeral = try EphemeralSecret(with: secret)

        // Figure out the item type code
        var itemTypeCode: String = ""
        if let internalSecret = secret as? Secret {
            itemTypeCode = type(of: internalSecret).self.itemTypeCode
        }
        if itemTypeCode == "" {
            // Fallback
            itemTypeCode = String(format: "r%02dB", ephemeral.value.count)
        }

        // Wrap up and return
        return (ephemeral, itemTypeCode)
    }
}
