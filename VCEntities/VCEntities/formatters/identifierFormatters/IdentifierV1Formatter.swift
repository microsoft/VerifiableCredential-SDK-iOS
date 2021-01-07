/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCJwt

struct IdentifierV1Formatter: IdentifierFormatting {
    
    private let multihash: Multihash = Multihash()
    private let encoder: JSONEncoder = JSONEncoder()
    
    private static let ionPrefix = "did:ion:"
    private static let ionQueryValue = ":"
    private static let replaceAction = "replace"
    
    init() {
        encoder.outputFormatting = .sortedKeys
    }
    
    func createIonLongFormDid(recoveryKey: ECPublicJwk,
                           updateKey: ECPublicJwk,
                           didDocumentKeys: [ECPublicJwk],
                           serviceEndpoints: [IdentifierDocumentServiceEndpoint]) throws -> String {
        
        let document = IdentifierDocumentV1(fromJwks: didDocumentKeys, andServiceEndpoints: serviceEndpoints)
        let patches = [IdentifierDocumentPatchV1(action: IdentifierV1Formatter.replaceAction, document: document)]
        
        let commitmentHash = try self.createCommitmentHash(usingJwk: updateKey)
        let delta = IdentifierDocumentDeltaDescriptorV1(updateCommitment: commitmentHash, patches: patches)
        
        let suffixData = try self.createSuffixData(usingDelta: delta, recoveryKey: recoveryKey)
        
        let initialState = IdentifierDocumentInitialState(suffixData: suffixData, delta:  delta)

        return try self.createLongFormIdentifier(usingInitialState: initialState)
    }
    
    private func createLongFormIdentifier(usingInitialState state: IdentifierDocumentInitialState) throws -> String {
        
        let encodedPayload = try encoder.encode(state).base64URLEncodedString()
        let shortForm = try self.createShortFormIdentifier(usingSuffixData: state.suffixData)

        return shortForm + IdentifierV1Formatter.ionQueryValue + encodedPayload
    }
    
    private func createShortFormIdentifier(usingSuffixData data: SuffixDescriptor) throws -> String {
        
        let encodedData = try encoder.encode(data)
        let hashedSuffixData = multihash.compute(from: encodedData).base64URLEncodedString()
        
        return IdentifierV1Formatter.ionPrefix + hashedSuffixData
    }
    
    private func createSuffixData(usingDelta delta: IdentifierDocumentDeltaDescriptorV1, recoveryKey: ECPublicJwk) throws -> SuffixDescriptor {
        
        let encodedDelta = try encoder.encode(delta)
        let patchDescriptorHash = multihash.compute(from: encodedDelta).base64URLEncodedString()
        let recoveryCommitmentHash = try self.createCommitmentHash(usingJwk: recoveryKey)
        
        return SuffixDescriptor(deltaHash: patchDescriptorHash, recoveryCommitment: recoveryCommitmentHash)
    }
    
    // double hashed commitment hash
    private func createCommitmentHash(usingJwk jwk: ECPublicJwk) throws -> String {
        
        let canonicalizedPublicKey = try encoder.encode(jwk)
        let hashedPublicKey = multihash.compute(from: canonicalizedPublicKey)
        
        return multihash.compute(from: hashedPublicKey).base64URLEncodedString()
    }
}
