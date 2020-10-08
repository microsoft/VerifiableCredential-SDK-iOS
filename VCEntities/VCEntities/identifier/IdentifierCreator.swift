/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto
import VCJwt

public struct IdentifierCreator {
    
    let cryptoOperations: CryptoOperating
    let identifierFormatter: IdentifierFormatting
    let alg = Secp256k1()
    
    public init(cryptoOperations: CryptoOperating) {
        self.init(cryptoOperations: cryptoOperations, identifierFormatter: IdentifierFormatter())
    }
    
    init(cryptoOperations: CryptoOperating, identifierFormatter: IdentifierFormatting) {
        self.cryptoOperations = cryptoOperations
        self.identifierFormatter = identifierFormatter
    }
    
    public func create() throws -> Identifier {
        let signingKeyMapping = KeyContainer(keyReference: try self.cryptoOperations.generateKey(), keyId: "sign")
        let updateKeyMapping = KeyContainer(keyReference: try self.cryptoOperations.generateKey(), keyId: "update")
        let recoveryKeyMapping = KeyContainer(keyReference: try self.cryptoOperations.generateKey(), keyId: "recover")
        
        let longformDid = try self.createLongformDid(signingKeyMapping: signingKeyMapping, updateKeyMapping: updateKeyMapping, recoveryKeyMapping: recoveryKeyMapping)
        return Identifier(longformId: longformDid, didDocumentKeys: [signingKeyMapping], updateKey: updateKeyMapping, recoveryKey: recoveryKeyMapping)
        
    }
    
    private func createLongformDid(signingKeyMapping: KeyContainer, updateKeyMapping: KeyContainer, recoveryKeyMapping: KeyContainer) throws -> String {
        let signingJwk = try self.generatePublicJwk(for: signingKeyMapping)
        let updateJwk = try self.generatePublicJwk(for: updateKeyMapping)
        let recoveryJwk = try self.generatePublicJwk(for: recoveryKeyMapping)
        return try self.identifierFormatter.createIonLongForm(recoveryKey: recoveryJwk, updateKey: updateJwk, didDocumentKeys: [signingJwk], serviceEndpoints: [])
    }
    
    private func generatePublicJwk(for keyMapping: KeyContainer) throws -> ECPublicJwk {
        let publicKey = try alg.createPublicKey(forSecret: keyMapping.keyReference)
        return ECPublicJwk(withPublicKey: publicKey, withKeyId: keyMapping.keyId)
    }
}