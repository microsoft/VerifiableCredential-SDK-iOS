/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/


import PromiseKit
import VCRepository
import VcNetworking
import VcJwt
import VcCrypto

class IssuanceResponseFormatter {
    
    let signer: TokenSigning
    
    init(signer: TokenSigning = Secp256k1Signer()) {
        self.signer = signer
    }
    
    func format(response: MockIssuanceResponse, usingIdentifier identifier: MockIdentifier) -> Promise<JwsToken<IssuanceResponseClaims>> {
        return Promise<JwsToken<IssuanceResponseClaims>> { seal in
            do {
                seal.fulfill(try self.createToken(response: response, usingIdentifier: identifier))
            } catch {
                seal.reject(error)
            }
        }
    }
    
    func createToken(response: MockIssuanceResponse, usingIdentifier identifier: MockIdentifier) throws -> JwsToken<IssuanceResponseClaims> {
        let headers = self.formatHeaders(usingIdentifier: identifier)
        let content = try self.formatClaims(response: response, usingIdentifier: identifier)
        print(content)
        var token = JwsToken(headers: headers, content: content)
        try token.sign(using: self.signer, withSecret: identifier.keyId)
        return token
    }
    
    private func formatHeaders(usingIdentifier identifier: MockIdentifier) -> Header {
        return Header(type: "JWT", algorithm: identifier.algorithm, keyId: identifier.id)
    }
    
    private func formatClaims(response: MockIssuanceResponse, usingIdentifier identifier: MockIdentifier) throws -> IssuanceResponseClaims {
        
        let publicKey = try signer.getPublicJwk(from: identifier.keyId, withKeyId: "AwM_sign_ion_1")
        let (iat, exp) = self.createIatAndExp(expiryInSeconds: response.expiryInSeconds)
        
        guard let audience = response.contract.input?.credentialIssuer else {
            throw IssuanceUseCaseError.test
        }
        
        return IssuanceResponseClaims(publicKeyThumbprint: try publicKey.getThumbprint(),
                                      audience: audience,
                                      did: identifier.id,
                                      publicJwk: publicKey,
                                      contract: response.contractUri,
                                      jti: UUID().uuidString,
                                      attestations: self.formatAttestations(response: response),
                                      iat: iat,
                                      exp: exp)
    }
    
    private func formatAttestations(response: MockIssuanceResponse) -> AttestationResponseDescriptor? {
        return AttestationResponseDescriptor(selfIssued: ["Name": "syd"])
    }
    
    private func createIatAndExp(expiryInSeconds: Int) -> (Double, Double) {
        let iat = (Date().timeIntervalSince1970).rounded(.down)
        let exp = iat + Double(expiryInSeconds)
        return (iat, exp)
    }
    
}
