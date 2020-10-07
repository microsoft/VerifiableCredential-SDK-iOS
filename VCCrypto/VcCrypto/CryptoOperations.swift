/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

enum CryptoOperationsError: Error {
    case unableToCreateKey
}

public struct CryptoOperations {
    
    private let secretStore: SecretStoring
    
    public init() {
        self.secretStore = KeychainSecretStore()
    }
    
    public init(secretStore: SecretStoring) {
        self.secretStore = secretStore
    }
    
    public func generateKey() throws -> VCCryptoSecret {
        
        guard let key = Random32BytesSecret(withStore: secretStore) else {
            throw CryptoOperationsError.unableToCreateKey
        }
        
        return key
    }
}
