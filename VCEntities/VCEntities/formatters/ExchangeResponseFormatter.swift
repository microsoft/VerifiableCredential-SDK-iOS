/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCJwt

public protocol ExchangeResponseFormatting {
    func format(usingIdentifier identifier: Identifier, andExchangeableVc vc: VerifiableCredential) throws -> ExchangeResponse
}

public class ExchangeResponseFormatter: ExchangeResponseFormatting {
    
    let signer: TokenSigning
    let headerFormatter = JwsHeaderFormatter()
    
    public init(signer: TokenSigning = Secp256k1Signer()) {
        self.signer = signer
    }
    
    public func format(usingIdentifier identifier: Identifier, andExchangeableVc vc: VerifiableCredential) throws -> ExchangeResponse {
        
        guard let signingKey = identifier.didDocumentKeys.first else {
            throw FormatterError.noSigningKeyFound
        }
        
        return try createToken(usingIdentifier: identifier, andExchangeableVc: vc, andSignWith: signingKey)
    }
    
    private func createToken(usingIdentifier identifier: Identifier, andExchangeableVc vc: VerifiableCredential, andSignWith signingKey: KeyContainer) throws -> ExchangeResponse {
        
        let headers = headerFormatter.formatHeaders(usingIdentifier: identifier, andSigningKey: signingKey)
        let tokenContents = try formatClaims(usingIdentifier: identifier, andExchangeableVc: vc, andSigningKey: signingKey)
        
        guard var token = JwsToken(headers: headers, content: tokenContents) else {
            throw FormatterError.unableToFormToken
        }
        
        try token.sign(using: self.signer, withSecret: signingKey.keyReference)
        return token
    }
    
    private func formatClaims(usingIdentifier identifier: Identifier, andExchangeableVc vc: VerifiableCredential, andSigningKey key: KeyContainer) throws -> ExchangeResponseClaims {
        
        guard let audience = vc.token.content.vc.exchangeService?.id else {
            throw FormatterError.noAudienceFoundInRequest
        }
        
        let publicKey = try signer.getPublicJwk(from: key.keyReference, withKeyId: key.keyId)
        let timeConstraints = TokenTimeConstraints(expiryInSeconds: 5)
        
        return ExchangeResponseClaims(publicKeyThumbprint: try publicKey.getThumbprint(),
                                      audience: audience,
                                      did: vc.token.content.sub,
                                      publicJwk: publicKey,
                                      jti: UUID().uuidString,
                                      iat: timeConstraints.issuedAt,
                                      exp: timeConstraints.expiration,
                                      exchangeableVc: vc.raw,
                                      recipientDid: identifier.longFormDid)
    }
}
