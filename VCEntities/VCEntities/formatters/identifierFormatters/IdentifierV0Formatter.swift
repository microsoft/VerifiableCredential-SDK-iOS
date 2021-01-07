/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCJwt

struct IdentifierV0Formatter: IdentifierFormatting {
    
    private let multihash: Multihash = Multihash()
    private let encoder: JSONEncoder = JSONEncoder()
    
    private static let ionPrefix = "did:ion:"
    private static let ionQueryValue = "?-ion-initial-state="
    private static let replaceAction = "replace"
    
    init() {
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    func createIonLongFormDid(recoveryKey: ECPublicJwk,
                           updateKey: ECPublicJwk,
                           didDocumentKeys: [ECPublicJwk],
                           serviceEndpoints: [IdentifierDocumentServiceEndpoint]) throws -> String {
        
        let document = IdentifierDocumentV0(fromJwks: didDocumentKeys, andServiceEndpoints: serviceEndpoints)
        let patches = [IdentifierDocumentPatchV0(action: IdentifierV0Formatter.replaceAction, document: document)]
        
        let commitmentHash = try self.createCommitmentHash(usingJwk: updateKey)
        let delta = IdentifierDocumentDeltaDescriptorV0(updateCommitment: commitmentHash, patches: patches)
        
        let suffixData = try self.createSuffixData(usingDelta: delta, recoveryKey: recoveryKey)

        return try self.createLongFormIdentifier(usingDelta: delta, andSuffixData: suffixData)
    }
    
    private func createLongFormIdentifier(usingDelta delta: IdentifierDocumentDeltaDescriptorV0, andSuffixData suffixData: SuffixDescriptor) throws -> String {
        
        let encodedDelta = try encoder.encode(delta).base64URLEncodedString()
        let encodedSuffixData = try encoder.encode(suffixData).base64URLEncodedString()
        let encodedPayload = encodedSuffixData + "." + encodedDelta
        let shortForm = try self.createShortFormIdentifier(usingSuffixData: suffixData)
        
        return shortForm + IdentifierV0Formatter.ionQueryValue + encodedPayload
    }
    
    private func createShortFormIdentifier(usingSuffixData data: SuffixDescriptor) throws -> String {
        
        let encodedData = try encoder.encode(data)
        let hashedSuffixData = multihash.compute(from: encodedData).base64URLEncodedString()
        
        return IdentifierV0Formatter.ionPrefix + hashedSuffixData
    }
    
    private func createSuffixData(usingDelta delta: IdentifierDocumentDeltaDescriptorV0, recoveryKey: ECPublicJwk) throws -> SuffixDescriptor {
        
        let encodedDelta = try encoder.encode(delta)
        let patchDescriptorHash = multihash.compute(from: encodedDelta).base64URLEncodedString()
        let recoveryCommitmentHash = try self.createCommitmentHash(usingJwk: recoveryKey)
        
        return SuffixDescriptor(deltaHash: patchDescriptorHash, recoveryCommitment: recoveryCommitmentHash)
    }
    
    private func createCommitmentHash(usingJwk jwk: ECPublicJwk) throws  -> String {
        
        let canonicalizedPublicKey = try encoder.encode(jwk)
        
        return multihash.compute(from: canonicalizedPublicKey).base64URLEncodedString()
    }
}
