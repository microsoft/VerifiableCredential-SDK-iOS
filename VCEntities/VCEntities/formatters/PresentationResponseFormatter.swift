/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCJwt

let CREDENTIAL_PATH = "$.attestations.presentations."
let CREDENTIAL_ENCODING = "base64Url"

public protocol PresentationResponseFormatting {
    func format(response: PresentationResponseContainer, usingIdentifier identifier: MockIdentifier) throws -> PresentationResponse
}

public class PresentationResponseFormatter: PresentationResponseFormatting {
    
    let signer: TokenSigning
    let vpFormatter: VerifiablePresentationFormatter
    
    public init(signer: TokenSigning = Secp256k1Signer()) {
        self.signer = signer
        self.vpFormatter = VerifiablePresentationFormatter(signer: signer)
    }
    
    public func format(response: PresentationResponseContainer, usingIdentifier identifier: MockIdentifier) throws -> PresentationResponse {
        return try self.createToken(response: response, usingIdentifier: identifier)
    }
    
    private func createToken(response: PresentationResponseContainer, usingIdentifier identifier: MockIdentifier) throws -> PresentationResponse {
        let headers = formatHeaders(usingIdentifier: identifier)
        let content = try self.formatClaims(response: response, usingIdentifier: identifier)
        var token = JwsToken(headers: headers, content: content)
        try token.sign(using: self.signer, withSecret: identifier.keyId)
        return token
    }
    
    private func formatClaims(response: PresentationResponseContainer, usingIdentifier identifier: MockIdentifier) throws -> PresentationResponseClaims {
        
        let publicKey = try signer.getPublicJwk(from: identifier.keyId, withKeyId: identifier.keyReference)
        let timeConstraints = createTokenTimeConstraints(expiryInSeconds: response.expiryInSeconds)
        
        var presentationSubmission: PresentationSubmission? = nil
        var attestations: AttestationResponseDescriptor? = nil
        if (!response.requestVCMap.isEmpty) {
            presentationSubmission = self.formatPresentationSubmission(response: response, keyType: identifier.keyType)
            attestations = try self.formatAttestations(response: response, usingIdentifier: identifier)
        }
        
        return PresentationResponseClaims(publicKeyThumbprint: try publicKey.getThumbprint(),
                                          audience: response.request.content.redirectURI,
                                          did: identifier.id,
                                          publicJwk: publicKey,
                                          jti: UUID().uuidString,
                                          presentationSubmission: presentationSubmission,
                                          attestations: attestations,
                                          state: response.request.content.state,
                                          nonce: response.request.content.nonce,
                                          iat: timeConstraints.issuedAt,
                                          exp: timeConstraints.expiration)
    }
    
    private func formatPresentationSubmission(response: PresentationResponseContainer, keyType: String) -> PresentationSubmission {
        let submissionDescriptor = response.requestVCMap.map { type, _ in
            SubmissionDescriptor(id: type, path: CREDENTIAL_PATH + type, format: keyType, encoding: CREDENTIAL_ENCODING)
        }
        return PresentationSubmission(submissionDescriptors: submissionDescriptor)
    }
    
    private func formatAttestations(response: PresentationResponseContainer, usingIdentifier identifier: MockIdentifier) throws -> AttestationResponseDescriptor {
        return AttestationResponseDescriptor(presentations: try self.createPresentations(response: response, usingIdentifier: identifier))
    }
    
    private func createPresentations(response: PresentationResponseContainer, usingIdentifier identifier: MockIdentifier) throws -> [String: String] {
        return try response.requestVCMap.mapValues { verifiableCredential in
            let vp = try self.vpFormatter.format(toWrap: verifiableCredential, withAudience: response.request.content.issuer, withExpiryInSeconds: response.expiryInSeconds, usingIdentifier: identifier)
            return try vp.serialize()
        }
    }
}
