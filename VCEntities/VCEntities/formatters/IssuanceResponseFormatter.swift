/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCJwt

public protocol IssuanceResponseFormatting {
    func format(response: IssuanceResponseContainer, usingIdentifier identifier: Identifier) throws -> IssuanceResponse
}

public class IssuanceResponseFormatter: IssuanceResponseFormatting {
    
    private let signer: TokenSigning
    private let headerFormatter = JwsHeaderFormatter()
    
    public init(signer: TokenSigning = Secp256k1Signer()) {
        self.signer = signer
    }
    
    public func format(response: IssuanceResponseContainer, usingIdentifier identifier: Identifier) throws -> IssuanceResponse {
        let signingKey = identifier.didDocumentKeys.first!
        return try createToken(response: response, usingIdentifier: identifier, andSignWith: signingKey)
    }
    
    private func createToken(response: IssuanceResponseContainer, usingIdentifier identifier: Identifier, andSignWith key: KeyContainer) throws -> IssuanceResponse {
        let headers = headerFormatter.formatHeaders(usingIdentifier: identifier, andSigningKey: identifier.didDocumentKeys.first!)
        let content = try self.formatClaims(response: response, usingIdentifier: identifier)
        var token = JwsToken(headers: headers, content: content)
        try token.sign(using: self.signer, withSecret: key.keyReference)
        return token
    }
    
    private func formatClaims(response: IssuanceResponseContainer, usingIdentifier identifier: Identifier) throws -> IssuanceResponseClaims {
        
        let publicKey = try signer.getPublicJwk(from: identifier.didDocumentKeys.first!.keyReference, withKeyId: identifier.didDocumentKeys.first!.keyId)
        let timeConstraints = TokenTimeConstraints(expiryInSeconds: response.expiryInSeconds)
        
        return IssuanceResponseClaims(publicKeyThumbprint: try publicKey.getThumbprint(),
                                      audience: response.audience,
                                      did: identifier.longFormDid,
                                      publicJwk: publicKey,
                                      contract: response.contractUri,
                                      jti: UUID().uuidString,
                                      attestations: self.formatAttestations(response: response),
                                      iat: timeConstraints.issuedAt,
                                      exp: timeConstraints.expiration)
    }
    
    private func formatAttestations(response: IssuanceResponseContainer) -> AttestationResponseDescriptor? {
        return AttestationResponseDescriptor(idTokens: response.requestedIdTokenMap, selfIssued: response.requestedSelfAttestedClaimMap)
    }
}
