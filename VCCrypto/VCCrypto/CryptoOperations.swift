/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public protocol CryptoOperating {
    func generateKey() throws -> VCCryptoSecret
    func retrieveKeyFromStorage(withId id: UUID) -> VCCryptoSecret
}

public struct CryptoOperations: CryptoOperating {

    private let secretStore: SecretStoring
    
    private let accessGroup: String?
    
    public init(accessGroup: String?) {
        self.init(secretStore: KeychainSecretStore(), accessGroup: accessGroup)
    }
    
    public init(secretStore: SecretStoring, accessGroup: String?) {
        self.secretStore = secretStore
        self.accessGroup = accessGroup
    }
    
    public func generateKey() throws -> VCCryptoSecret {
        
        let key = try Random32BytesSecret(withStore: secretStore, inAccessGroup: accessGroup)
        
        return key
    }
    
    public func retrieveKeyFromStorage(withId id: UUID) -> VCCryptoSecret {
        return Random32BytesSecret(withStore: secretStore, andId: id, inAccessGroup: accessGroup)
    }
}
