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
        let publicKey = try signer.algorithm.createPublicKey(forSecret: identifier.keyId)
        let formattedPublicKey = ECPublicJwk(withPublicKey: publicKey, withKeyId: identifier.keyId.id.uuidString)!
        let jti = UUID().uuidString
        let (iat, exp) = self.createIatAndExp(expiryInSeconds: 4)
        let claims = IssuanceResponseClaims(publicKeyThumbprint: try formattedPublicKey.getThumbprint(),
                                            audience: response.contract.input.credentialIssuer,
                                            did: identifier.id,
                                            publicJwk: formattedPublicKey,
                                            contract: response.contractUri,
                                            jti: jti,
                                            attestations: self.formatAttestations(response: response),
                                            iat: iat,
                                            exp: exp)
        let header = Header()
        var token = JwsToken(headers: header, content: claims)
        try token.sign(using: self.signer, withSecret: identifier.keyId)
        return token
    }
    
    func formatAttestations(response: MockIssuanceResponse) -> AttestationResponseDescriptor? {
        return nil
    }
    
    func createIatAndExp(expiryInSeconds: Int) -> (Double?, Double?) {
        return (nil, nil)
    }

}
