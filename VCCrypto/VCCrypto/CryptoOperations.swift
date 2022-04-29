/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public protocol CryptoOperating {
    func generateKey() throws -> VCCryptoSecret
    func retrieveKeyFromStorage(withId id: UUID) -> VCCryptoSecret
    func retrieveKeyIfStored(uuid: UUID) throws -> VCCryptoSecret?
    func delete(key: VCCryptoSecret) throws
    func save(key: VCCryptoSecret) throws
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

    /// Tests if a key corresponding to the given id is stored and, if it is, returns a reference to it; returns nil otherwise
    public func retrieveKeyIfStored(uuid: UUID) throws -> VCCryptoSecret? {
        
        let accessGroup = sdkConfiguration.accessGroupIdentifier
        var keyRef: VCCryptoSecret? = nil
        do {
            let _ = try secretStore.getSecret(id: uuid,
                                              itemTypeCode: Random32BytesSecret.itemTypeCode,
                                              accessGroup: accessGroup)
            keyRef = Random32BytesSecret(withStore: secretStore, andId: uuid)
        }
        catch SecretStoringError.itemNotFound {
            keyRef = nil
        }
        return keyRef
    }
    
    public func delete(key: VCCryptoSecret) throws {
        try secretStore.delete(secret: key)
    }
    
    public func save(key: VCCryptoSecret) throws {
        try secretStore.save(secret: key)
    }
}
