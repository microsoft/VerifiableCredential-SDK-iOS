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
        let signingKey = try self.cryptoOperations.generateKey()
        let updateKey = try self.cryptoOperations.generateKey()
        let recoveryKey = try self.cryptoOperations.generateKey()
        
        let longformDid = try self.createLongformDid(signingKey: signingKey, updateKey: updateKey, recoveryKey: recoveryKey)
        return Identifier(longformId: longformDid, didDocumentKeys: [signingKey], updateKey: updateKey, recoveryKey: recoveryKey)
        
    }
    
    private func createLongformDid(signingKey: VCCryptoSecret, updateKey: VCCryptoSecret, recoveryKey: VCCryptoSecret) throws -> String {
        let signingJwk = try self.generatePublicJwk(keyRef: signingKey, keyId: "sign")
        let updateJwk = try self.generatePublicJwk(keyRef: updateKey, keyId: "update")
        let recoveryJwk = try self.generatePublicJwk(keyRef: recoveryKey, keyId: "recover")
        return try self.identifierFormatter.createIonLongForm(recoveryKey: recoveryJwk, updateKey: updateJwk, didDocumentKeys: [signingJwk], serviceEndpoints: [])
    }
    
    private func generatePublicJwk(keyRef: VCCryptoSecret, keyId: String) throws -> ECPublicJwk {
        let publicKey = try alg.createPublicKey(forSecret: keyRef)
        return ECPublicJwk(withPublicKey: publicKey, withKeyId: keyId)
    }
}
