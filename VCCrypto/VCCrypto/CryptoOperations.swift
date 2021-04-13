/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public protocol CryptoOperating {
    func generateKey() throws -> VCCryptoSecret
    func retrieveKeyFromStorage(withId id: UUID) throws -> VCCryptoSecret
}

public struct CryptoOperations: CryptoOperating {

    private let secretStore: SecretStoring
    
    public init() {
        self.init(secretStore: KeychainSecretStore())
    }
    
    public init(secretStore: SecretStoring) {
        self.secretStore = secretStore
    }
    
    public func generateKey() throws -> VCCryptoSecret {
        
        let key = try Random32BytesSecret(withStore: secretStore)
        
        return key
    }
    
    public func retrieveKeyFromStorage(withId id: UUID) throws -> VCCryptoSecret {
        return Random32BytesSecret(withStore: secretStore, andId: id)
    }
}
