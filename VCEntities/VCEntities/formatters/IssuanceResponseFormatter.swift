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
    private let vpFormatter: VerifiablePresentationFormatter
    
    public init(signer: TokenSigning = Secp256k1Signer()) {
        self.signer = signer
        self.vpFormatter = VerifiablePresentationFormatter(signer: signer)
    }
    
    public func format(response: IssuanceResponseContainer, usingIdentifier identifier: Identifier) throws -> IssuanceResponse {
        
        guard let signingKey = identifier.didDocumentKeys.first else {
            throw FormatterError.noSigningKeyFound
        }
        
        return try createToken(response: response, usingIdentifier: identifier, andSignWith: signingKey)
    }
    
    private func createToken(response: IssuanceResponseContainer, usingIdentifier identifier: Identifier, andSignWith key: KeyContainer) throws -> IssuanceResponse {
        
        let headers = headerFormatter.formatHeaders(usingIdentifier: identifier, andSigningKey: key)
        let content = try self.formatClaims(response: response, usingIdentifier: identifier, andSigningKey: key)
        
        var token = JwsToken(headers: headers, content: content)
        try token.sign(using: self.signer, withSecret: key.keyReference)
        
        return token
    }
    
    private func formatClaims(response: IssuanceResponseContainer, usingIdentifier identifier: Identifier, andSigningKey key: KeyContainer) throws -> IssuanceResponseClaims {
        
        let publicKey = try signer.getPublicJwk(from: key.keyReference, withKeyId: key.keyId)
        let timeConstraints = TokenTimeConstraints(expiryInSeconds: response.expiryInSeconds)
        let attestations = try self.formatAttestations(response: response, usingIdentifier: identifier, andSignWith: key)
        
        return IssuanceResponseClaims(publicKeyThumbprint: try publicKey.getThumbprint(),
                                      audience: response.audience,
                                      did: identifier.longFormDid,
                                      publicJwk: publicKey,
                                      contract: response.contractUri,
                                      jti: UUID().uuidString,
                                      attestations: attestations,
                                      iat: timeConstraints.issuedAt,
                                      exp: timeConstraints.expiration)
    }
    
    private func formatAttestations(response: IssuanceResponseContainer, usingIdentifier identifier: Identifier, andSignWith key: KeyContainer) throws -> AttestationResponseDescriptor? {
        
        var idTokenMap: RequestedIdTokenMap? = nil
        if !response.requestedIdTokenMap.isEmpty {
            idTokenMap = response.requestedIdTokenMap
        }
        
        var selfIssuedMap: RequestedSelfAttestedClaimMap? = nil
        if !response.requestedSelfAttestedClaimMap.isEmpty {
            selfIssuedMap = response.requestedSelfAttestedClaimMap
        }
        
        var presentationsMap: [String: String]? = nil
        if !response.requestVCMap.isEmpty {
            presentationsMap = try self.createPresentations(from: response, usingIdentifier: identifier, andSignWith: key)
        }
        
        return AttestationResponseDescriptor(idTokens: idTokenMap, presentations: presentationsMap, selfIssued: selfIssuedMap)
    }
    
    private func createPresentations(from response: IssuanceResponseContainer, usingIdentifier identifier: Identifier, andSignWith key: KeyContainer) throws -> [String: String] {
        return try response.requestVCMap.mapValues { verifiableCredential in
            let vp = try self.vpFormatter.format(toWrap: verifiableCredential, withAudience: response.contract.input!.credentialIssuer!, withExpiryInSeconds: response.expiryInSeconds, usingIdentifier: identifier, andSignWith: key)
            return try vp.serialize()
        }
    }
}
