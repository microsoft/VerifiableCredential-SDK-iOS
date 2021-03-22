/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCToken

let PURPOSE = "verify"
let CONTEXT = "https://www.w3.org/2018/credentials/v1"
let TYPE = "VerifiablePresentation"

class VerifiablePresentationFormatter {
    
    let signer: TokenSigning
    let headerFormatter = JwsHeaderFormatter()
    
    public init(signer: TokenSigning = Secp256k1Signer()) {
        self.signer = signer
    }
    
    func format(toWrap vc: VerifiableCredential,
                       withAudience audience: String,
                       withExpiryInSeconds exp: Int,
                       usingIdentifier identifier: Identifier,
                       andSignWith key: KeyContainer) throws -> VerifiablePresentation {
        
        let headers = headerFormatter.formatHeaders(usingIdentifier: identifier, andSigningKey: identifier.didDocumentKeys.first!)
        let timeConstraints = TokenTimeConstraints(expiryInSeconds: exp)
        let verifiablePresentationDescriptor = try self.createVerifiablePresentationDescriptor(toWrap: vc)
        
        let vpClaims = VerifiablePresentationClaims(vpId: UUID().uuidString,
                                                    purpose: PURPOSE,
                                                    verifiablePresentation: verifiablePresentationDescriptor,
                                                    issuerOfVp: identifier.longFormDid,
                                                    audience: audience,
                                                    iat: timeConstraints.issuedAt,
                                                    exp: timeConstraints.expiration)
        
        guard var token = JwsToken<VerifiablePresentationClaims>(headers: headers, content: vpClaims) else {
            throw FormatterError.unableToFormToken
        }
        
        try token.sign(using: self.signer, withSecret: key.keyReference)
        return token
    }
    
    private func createVerifiablePresentationDescriptor(toWrap vc: VerifiableCredential) throws -> VerifiablePresentationDescriptor {
        
        guard let rawVC = vc.rawValue else {
            throw FormatterError.unableToGetRawValueOfVerifiableCredential
        }
        
        return VerifiablePresentationDescriptor(context: [CONTEXT],
                                                type: [TYPE],
                                                verifiableCredential: [rawVC])
    }
}
