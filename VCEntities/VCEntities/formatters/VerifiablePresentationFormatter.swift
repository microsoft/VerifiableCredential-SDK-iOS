/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCJwt

let PURPOSE = "verify"
let CONTEXT = "https://www.w3.org/2018/credentials/v1"
let TYPE = "VerifiablePresentation"

class VerifiablePresentationFormatter {
    
    let signer: TokenSigning
    
    public init(signer: TokenSigning = Secp256k1Signer()) {
        self.signer = signer
    }
    
    func format(toWrap vc: VerifiableCredential,
                       withAudience audience: String,
                       withExpiryInSeconds exp: Int,
                       usingIdentifier identifier: MockIdentifier) throws -> VerifiablePresentation {
        
        let headers = formatHeaders(usingIdentifier: identifier)
        let timeConstraints = createTokenTimeConstraints(expiryInSeconds: exp)
        let verifiablePresentationDescriptor = try self.createVerifiablePresentationDescriptor(toWrap: vc)
        
        let vpClaims = VerifiablePresentationClaims(vpId: UUID().uuidString,
                                                    purpose: PURPOSE,
                                                    verifiablePresentation: verifiablePresentationDescriptor,
                                                    issuerOfVp: identifier.id,
                                                    audience: audience,
                                                    iat: timeConstraints.issuedAt,
                                                    exp: timeConstraints.expiration)
        
        var token = JwsToken<VerifiablePresentationClaims>(headers: headers, content: vpClaims)
        try token.sign(using: self.signer, withSecret: identifier.keyId)
        return token
    }
    
    private func createVerifiablePresentationDescriptor(toWrap vc: VerifiableCredential) throws -> VerifiablePresentationDescriptor {
        return VerifiablePresentationDescriptor(context: [CONTEXT],
                                                type: [TYPE],
                                                verifiableCredential: [try vc.serialize()])
    }
}
