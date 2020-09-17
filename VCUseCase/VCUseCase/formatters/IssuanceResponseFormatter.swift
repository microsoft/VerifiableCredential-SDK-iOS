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
    
    func format(response: MockIssuanceResponse, usingIdentifier identifier: MockIdentifier) throws -> JwsToken<IssuanceResponseClaims> {
        let header = self.formatHeaders()
        let content = try self.formatClaims(response: response, usingIdentifier: identifier)
        var token = JwsToken(headers: header, content: content)
        print("here")
        print(token.content)
        print(header)
        // try token.sign(using: self.signer, withSecret: identifier.keyId)
        return token
    }
    
    private func formatHeaders() -> Header {
        return Header(keyId: "keyId")
    }
    
    private func formatClaims(response: MockIssuanceResponse, usingIdentifier identifier: MockIdentifier) throws -> IssuanceResponseClaims {
        
        let publicKey = try signer.algorithm.createPublicKey(forSecret: identifier.keyId)
        let formattedPublicKey = ECPublicJwk(withPublicKey: publicKey, withKeyId: identifier.keyId.id.uuidString)
        let (iat, exp) = self.createIatAndExp(expiryInSeconds: response.expiryInSeconds)
        
        guard let audience = response.contract.input?.credentialIssuer else {
            throw IssuanceUseCaseError.test
        }
        
        return IssuanceResponseClaims(publicKeyThumbprint: try formattedPublicKey.getThumbprint(),
                                      audience: audience,
                                      did: identifier.id,
                                      publicJwk: formattedPublicKey,
                                      contract: response.contractUri,
                                      jti: UUID().uuidString,
                                      attestations: self.formatAttestations(response: response),
                                      iat: iat,
                                      exp: exp)
    }
    
    private func formatAttestations(response: MockIssuanceResponse) -> AttestationResponseDescriptor? {
        return nil
    }
    
    private func createIatAndExp(expiryInSeconds: Int) -> (Double, Double) {
        let iat = Date().timeIntervalSince1970
        let exp = iat + Double(expiryInSeconds)
        return (iat, exp)
    }
    
}
