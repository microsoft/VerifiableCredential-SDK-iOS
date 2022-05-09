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
    
    private let sdkConfiguration: VCSDKConfigurable
    
    public init(sdkConfiguration: VCSDKConfigurable) {
        self.init(secretStore: KeychainSecretStore(), sdkConfiguration: sdkConfiguration)
    }
    
    public init(secretStore: SecretStoring, sdkConfiguration: VCSDKConfigurable) {
        self.secretStore = secretStore
        self.sdkConfiguration = sdkConfiguration
    }
    
    public func generateKey() throws -> VCCryptoSecret {
        let accessGroup = sdkConfiguration.accessGroupIdentifier
        let key = try Random32BytesSecret(withStore: secretStore, inAccessGroup: accessGroup)
        return key
    }
    
    public func retrieveKeyFromStorage(withId id: UUID) -> VCCryptoSecret {
        let accessGroup = sdkConfiguration.accessGroupIdentifier
        return Random32BytesSecret(withStore: secretStore, andId: id, inAccessGroup: accessGroup)
    }
}
