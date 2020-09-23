/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import PromiseKit
import VCRepository
import VCNetworking
import VCJwt
import VCCrypto

enum IssuanceResponseFormatterError: Error {
    case noAudienceSpecifiedInContract
}

public class IssuanceResponseFormatter {
    
    let signer: TokenSigning
    
    public init(signer: TokenSigning = Secp256k1Signer()) {
        self.signer = signer
    }
    
    func format(response: IssuanceResponse, usingIdentifier identifier: MockIdentifier) -> Promise<JwsToken<IssuanceResponseClaims>> {
        return Promise<JwsToken<IssuanceResponseClaims>> { seal in
            do {
                seal.fulfill(try self.createToken(response: response, usingIdentifier: identifier))
            } catch {
                seal.reject(error)
            }
        }
    }
    
    func createToken(response: IssuanceResponse, usingIdentifier identifier: MockIdentifier) throws -> JwsToken<IssuanceResponseClaims> {
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
    
    private func formatClaims(response: IssuanceResponse, usingIdentifier identifier: MockIdentifier) throws -> IssuanceResponseClaims {
        
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
    
    private func formatAttestations(response: IssuanceResponse) -> AttestationResponseDescriptor? {
        return AttestationResponseDescriptor(idTokens: response.requestedIdTokenMap, selfIssued: response.requestedSelfAttestedClaimMap)
    }
    
    private func createIatAndExp(expiryInSeconds: Int) -> (Double, Double) {
        let iat = (Date().timeIntervalSince1970).rounded(.down)
        let exp = iat + Double(expiryInSeconds)
        return (iat, exp)
    }
    
}
