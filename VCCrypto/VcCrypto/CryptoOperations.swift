/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

enum CryptoOperationsError: Error {
    case unableToCreateKey
}

public protocol CryptoOperating {
    func generateKey() throws -> VCCryptoSecret
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
        
        guard let key = Random32BytesSecret(withStore: secretStore) else {
            throw CryptoOperationsError.unableToCreateKey
        }
        
        return key
    }
}
