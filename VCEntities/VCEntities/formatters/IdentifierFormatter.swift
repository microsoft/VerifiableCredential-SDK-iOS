/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCCrypto
import VCJwt

enum IdentifierCreatorError: Error {
    case unableToParseString
}

public struct IdentifierFormatter {
    
    private let multihash: Multihash = Multihash()
    private let encoder: JSONEncoder = JSONEncoder()
    
    private let ionPrefix = "did:ion:"
    private let ionQueryValue = "?-ion-initial-state="
    private let replaceAction = "replace"
    
    func createIonLongForm(recoveryKey: ECPublicJwk,
                           updateKey: ECPublicJwk,
                           didDocumentKeys: [ECPublicJwk],
                           serviceEndpoints: [IdentifierDocumentServiceEndpoint]) throws -> Identifier {
        
        let document = IdentifierDocument(fromJwks: didDocumentKeys, andServiceEndpoints: serviceEndpoints)
        
        let patches = [IdentifierDocumentPatch(action: replaceAction, document: document)]
        
        let commitmentHash = try self.createCommitmentHash(key: updateKey)
        let delta = IdentifierDocumentDeltaDescriptor(updateCommitment: commitmentHash, patches: patches)
        
        let suffixData = try self.createSuffixData(usingDelta: delta, recoveryKey: recoveryKey)

        let longform = try self.createLongFormIdentifier(usingDelta: delta, andSuffixData: suffixData)
        
        return Identifier(longformId: longform)
    }
    
    func createLongFormIdentifier(usingDelta delta: IdentifierDocumentDeltaDescriptor, andSuffixData suffixData: SuffixDescriptor) throws -> String {
        
        let encodedDelta = try encoder.encode(delta).base64URLEncodedString()
        let encodedSuffixData = try encoder.encode(suffixData).base64URLEncodedString()
        let encodedPayload = encodedSuffixData + "." + encodedDelta
        
        let shortForm = try self.createShortFormIdentifier(usingSuffixData: suffixData)
        
        return shortForm + ionQueryValue + encodedPayload
    }
    
    func createShortFormIdentifier(usingSuffixData data: SuffixDescriptor) throws -> String {
        
        let encodedData = try encoder.encode(data)
        let hashedSuffixData = multihash.compute(from: encodedData).base64URLEncodedString()
        
        return ionPrefix + hashedSuffixData
    }
    
    func createSuffixData(usingDelta delta: IdentifierDocumentDeltaDescriptor, recoveryKey: ECPublicJwk) throws -> SuffixDescriptor {
        let encodedDelta = try encoder.encode(delta)
        let patchDescriptorHash = multihash.compute(from: encodedDelta).base64URLEncodedString()
        let recoveryCommitmentHash = try self.createCommitmentHash(key: recoveryKey)
        return SuffixDescriptor(patchDescriptorHash: patchDescriptorHash, recoveryCommitmentHash: recoveryCommitmentHash)
    }
    
    func createCommitmentHash(key: ECPublicJwk) throws  -> String {
        let canonicalizedPublicKey = try encoder.encode(key)
        return multihash.compute(from: canonicalizedPublicKey).base64URLEncodedString()
    }
}
