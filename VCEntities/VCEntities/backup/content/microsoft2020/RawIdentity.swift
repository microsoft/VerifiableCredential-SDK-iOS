/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VCToken
import VCCrypto

enum RawIdentityError: Error {
    case signingKeyNotFound
    case recoveryKeyNotFound
    case updateKeyNotFound
    case privateKeyNotFound
    case keyIdNotFound
}

struct RawIdentity: Codable {
    var id: String
    var name: String
    var keys: [Jwk]?
    var recoveryKey: String
    var updateKey: String

    init(identifier: Identifier) throws {
        
        var keys = try identifier.didDocumentKeys.map(RawIdentity.jwkFromKeyContainer)
        try keys.append(RawIdentity.jwkFromKeyContainer(identifier.recoveryKey))
        try keys.append(RawIdentity.jwkFromKeyContainer(identifier.updateKey))
        self.id = identifier.did
        self.name = identifier.alias
        self.recoveryKey = identifier.recoveryKey.keyId
        self.updateKey = identifier.updateKey.keyId
        self.keys = keys
    }

    var identifier: Identifier {
        get throws {
            // Get out the keys
            guard let keys = self.keys else {
                throw RawIdentityError.signingKeyNotFound
            }
            guard let recoveryJwk = keys.first(where: {$0.keyId == self.recoveryKey}) else {
                throw RawIdentityError.recoveryKeyNotFound
            }
            guard let updateJwk = keys.first(where: {$0.keyId == self.updateKey}) else {
                throw RawIdentityError.updateKeyNotFound
            }
            let set = Set([self.recoveryKey, self.updateKey])
            guard let signingJwk = keys.first(where: {!set.contains($0.keyId!)}) else {
                throw RawIdentityError.signingKeyNotFound
            }

            // Convert
            let recoveryKeyContainer = try RawIdentity.keyContainerFromJwk(recoveryJwk)
            let updateKeyContainer = try RawIdentity.keyContainerFromJwk(updateJwk)
            let signingKeyContainer = try RawIdentity.keyContainerFromJwk(signingJwk)
            
            // Wrap up and return
            return Identifier(longFormDid: self.id,
                              didDocumentKeys: [signingKeyContainer],
                              updateKey: updateKeyContainer,
                              recoveryKey: recoveryKeyContainer,
                              alias: self.name)
        }
    }
    
    private static func jwkFromKeyContainer(_ keyContainer: KeyContainer) throws -> Jwk {
        
        // Get out the public and private components of the key (pair)
        let secret = keyContainer.keyReference
        let publicKey = try Secp256k1().createPublicKey(forSecret: secret)
        let privateKey = try EphemeralSecret(with: secret)
        
        // Wrap them up in a JSON Web Key
        return Jwk(keyType: "EC",
                   keyId: keyContainer.keyId,
                   curve: "secp256k1",
                   use: "sig",
                   x: publicKey.x,
                   y: publicKey.y,
                   d: privateKey.value)
    }
    
    private static func keyContainerFromJwk(_ jwk: Jwk) throws -> KeyContainer {

        guard let privateKeyData = jwk.d else {
            throw RawIdentityError.privateKeyNotFound
        }
        let privateKey = EphemeralSecret(with: privateKeyData,
                                         accessGroup: VCSDKConfiguration.sharedInstance.accessGroupIdentifier)

        guard let keyId = jwk.keyId else {
            throw RawIdentityError.keyIdNotFound
        }
        
        // Wrap it all up
        return KeyContainer(keyReference: privateKey, keyId: keyId)
    }
}
