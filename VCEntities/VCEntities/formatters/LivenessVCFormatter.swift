/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCToken

enum LivenessVCFormatterError: Error {
    case unableToGetIdentifierKey
    case unableToCreateVCToken
}

public class LivenessVCFormatter {
    
    let signer = Secp256k1Signer()
    
    public init() {}
    
    public func format(content: Data, metadata: String, identifier: Identifier) throws -> VerifiableCredential
    {
        guard let key = identifier.didDocumentKeys.first else
        {
            throw LivenessVCFormatterError.unableToGetIdentifierKey
        }
        
        let base64EncodedContent = content.base64URLEncodedString()
        
        let timeConstraints = TokenTimeConstraints(expiryInSeconds: 94608000)
        let subject = ["content": base64EncodedContent, "metadata": metadata]
        let vcDesc = VerifiableCredentialDescriptor(context: ["https://www.w3.org/2018/credentials/v1"],
                                                    type: ["VerifiableCredential", "LivenessCheck2022"],
                                                    credentialSubject: subject)
        
        let header = Header(type: "JWT",
                            algorithm: "ES256K",
                            keyId: identifier.longFormDid + "#" + key.keyId)
        
        let contents = VCClaims(jti: "123456",
                                iss: identifier.longFormDid,
                                sub: identifier.longFormDid,
                                iat: timeConstraints.issuedAt,
                                exp: timeConstraints.expiration,
                                vc: vcDesc)
        
        guard var vc = VerifiableCredential(headers: header, content: contents) else
        {
            throw LivenessVCFormatterError.unableToCreateVCToken
        }
        
        try vc.sign(using: signer, withSecret: key.keyReference)
        vc.rawValue = try vc.serialize()
        return vc
    }
}
