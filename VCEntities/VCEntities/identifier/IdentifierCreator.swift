/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto
import VCJwt

enum IdentifierCreatorError: Error {
    case unableToParseString
}

public struct IdentifierCreator {
    
    private let cryptoOperations: CryptoOperations
    private let multihash: Multihash = Multihash()
    
    public init(cryptoOperations: CryptoOperations) {
        self.cryptoOperations = cryptoOperations
    }
    
    public func create() throws -> MockIdentifier {
        let signingKey = try self.cryptoOperations.generateKey()
        // let updateKey = try self.cryptoOperations.generateKey()
        // let recoveryKey = try self.cryptoOperations.generateKey()
        let alg = Secp256k1()
        let publicKey = try alg.createPublicKey(forSecret: signingKey)
        let jwk = ECPublicJwk(withPublicKey: publicKey, withKeyId: "test")
        let registrationPayload = try self.createRegistrationPayload(usingSigningKey: jwk, andUpdateKey: jwk, andRecoveryKey: jwk)
        let longform = try self.createLongFormIdentifier(usingRegistrationPayload: registrationPayload)
        print(longform)
        
        return MockIdentifier()
    }
    
    func createShortFormIdentifier(usingSuffixData data: Data) -> String {
        let hashedSuffixData = multihash.compute(from: data).base64URLEncodedString()
        return "did:ion:" + hashedSuffixData
    }
    
    func createLongFormIdentifier(usingRegistrationPayload payload: RegistrationPayload) throws -> String {
        let encodedPayload = payload.suffixData + "." + payload.patchData
        
        guard let suffixData = Data(base64URLEncoded: payload.suffixData) else {
            throw IdentifierCreatorError.unableToParseString
        }
        
        let shortForm = self.createShortFormIdentifier(usingSuffixData: suffixData)
        
        return shortForm + "?-ion-initial-state=" + encodedPayload
    }
    
    func createRegistrationPayload(usingSigningKey signingKey: ECPublicJwk, andUpdateKey updateKey: ECPublicJwk, andRecoveryKey recoveryKey: ECPublicJwk) throws -> RegistrationPayload {
        let identifierDocumentPatch = self.createIdentifierDocumentPatches(keys: [signingKey])
        let patchDescriptor = try self.createIdentifierDocumentPatchDescriptor(from: [identifierDocumentPatch], usingUpdateKey: updateKey)
        let encodedPatchDescriptor = try JSONEncoder().encode(patchDescriptor).base64URLEncodedString()
        
        let suffixDescriptor = try self.createSuffixDescriptor(patchDescriptor: patchDescriptor, recoveryKey: recoveryKey)
        let encodedSuffixDescriptor = try JSONEncoder().encode(suffixDescriptor).base64URLEncodedString()
        return RegistrationPayload(suffixData: encodedSuffixDescriptor, patchData: encodedPatchDescriptor)
    }
    
    func createSuffixDescriptor(patchDescriptor: IdentifierDocumentPatchDescriptor, recoveryKey: ECPublicJwk) throws -> SuffixDescriptor {
        let encodedPatchDescriptor = try JSONEncoder().encode(patchDescriptor)
        let patchDescriptorHash = multihash.compute(from: encodedPatchDescriptor).base64URLEncodedString()
        let recoveryCommitmentHash = try self.createCommitmentHash(key: recoveryKey)
        return SuffixDescriptor(patchDescriptorHash: patchDescriptorHash, recoveryCommitmentHash: recoveryCommitmentHash)
    }
    
    func createIdentifierDocument(keys: [ECPublicJwk]) -> IdentifierDocument {
        var publicKeys: [IdentifierDocumentPublicKey] = []
        for key in keys {
            publicKeys.append(self.createIdentifierDocumentPublicKey(key: key))
        }
        return IdentifierDocument(publicKeys: publicKeys, serviceEndpoints: nil)
    }
    
    func createIdentifierDocumentPublicKey(key: ECPublicJwk) -> IdentifierDocumentPublicKey {
        return IdentifierDocumentPublicKey(id: key.keyId, type: "EcdsaSecp256k1VerificationKey2019", controller: nil, jwk: key, purpose: ["auth", "general"])
    }
    
    func createIdentifierDocumentPatches(keys: [ECPublicJwk]) -> IdentifierDocumentPatch {
        return IdentifierDocumentPatch(action: "replace", document: self.createIdentifierDocument(keys: keys))
    }
    
    func createIdentifierDocumentPatchDescriptor(from patches: [IdentifierDocumentPatch], usingUpdateKey updateKey: ECPublicJwk) throws -> IdentifierDocumentPatchDescriptor {
        let commitmentHash = try self.createCommitmentHash(key: updateKey)
        return IdentifierDocumentPatchDescriptor(nextUpdateCommitmentHash: commitmentHash, patches: patches)
    }
    
    func createCommitmentHash(key: ECPublicJwk) throws  -> String {
        let canonicalizedPublicKey = try self.canonicalizePublicKey(key: key)
        return multihash.compute(from: canonicalizedPublicKey).base64URLEncodedString()
    }
    
    /// when we have canonicalization put here
    func canonicalizePublicKey(key: ECPublicJwk) throws -> Data {
        return try JSONEncoder().encode(key)
    }
}
