/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCJwt
import VCCrypto

public class IssuanceResponseFormatter: ResponseFormatting {
    
    let signer: TokenSigning
    
    public init(signer: TokenSigning = Secp256k1Signer()) {
        self.signer = signer
    }
    
    public func format(response: IssuanceResponseContainer, usingIdentifier identifier: MockIdentifier) throws -> IssuanceResponse {
        return try self.createToken(response: response, usingIdentifier: identifier)
    }
    
    private func createToken(response: IssuanceResponseContainer, usingIdentifier identifier: MockIdentifier) throws -> IssuanceResponse {
        let headers = self.formatHeaders(usingIdentifier: identifier)
        let content = try self.formatClaims(response: response, usingIdentifier: identifier)
        var token = JwsToken(headers: headers, content: content)
        try token.sign(using: self.signer, withSecret: identifier.keyId)
        return token
    }
    
    private func formatHeaders(usingIdentifier identifier: MockIdentifier) -> Header {
        let keyId = identifier.id + identifier.keyReference
        return Header(type: "JWT", algorithm: identifier.algorithm, keyId: keyId)
    }
    
    private func formatClaims(response: IssuanceResponseContainer, usingIdentifier identifier: MockIdentifier) throws -> IssuanceResponseClaims {
        
        let publicKey = try signer.getPublicJwk(from: identifier.keyId, withKeyId: identifier.keyReference)
        let (iat, exp) = self.createIatAndExp(expiryInSeconds: response.expiryInSeconds)
        
        return IssuanceResponseClaims(publicKeyThumbprint: try publicKey.getThumbprint(),
                                      audience: response.audience,
                                      did: identifier.id,
                                      publicJwk: publicKey,
                                      contract: response.contractUri,
                                      jti: UUID().uuidString,
                                      attestations: self.formatAttestations(response: response),
                                      iat: iat,
                                      exp: exp)
    }
    
    private func formatAttestations(response: IssuanceResponseContainer) -> AttestationResponseDescriptor? {
        return AttestationResponseDescriptor(idTokens: response.requestedIdTokenMap, selfIssued: response.requestedSelfAttestedClaimMap)
    }
    
    private func createIatAndExp(expiryInSeconds: Int) -> (Double, Double) {
        let iat = (Date().timeIntervalSince1970).rounded(.down)
        let exp = iat + Double(expiryInSeconds)
        return (iat, exp)
    }
    
}
