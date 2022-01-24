/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCToken

let CREDENTIAL_PATH = "$.attestations.presentations."
let CREDENTIAL_ENCODING = "base64Url"

public protocol PresentationResponseFormatting {
    func format(response: PresentationResponseContainer, usingIdentifier identifier: Identifier) throws -> PresentationResponse
}

public class PresentationResponseFormatter: PresentationResponseFormatting {
    
    let signer: TokenSigning
    let sdkLog: VCSDKLog
    let headerFormatter = JwsHeaderFormatter()
    
    public init(signer: TokenSigning = Secp256k1Signer(),
                sdkLog: VCSDKLog = VCSDKLog.sharedInstance) {
        self.signer = signer
        self.sdkLog = sdkLog
    }
    
    public func format(response: PresentationResponseContainer, usingIdentifier identifier: Identifier) throws -> PresentationResponse {
        
        guard let signingKey = identifier.didDocumentKeys.first else {
            throw FormatterError.noSigningKeyFound
        }

        return try self.createToken(from: response, usingIdentifier: identifier, andSignWith: signingKey)
    }
    
    private func createToken(from response: PresentationResponseContainer, usingIdentifier identifier: Identifier, andSignWith key: KeyContainer) throws -> PresentationResponse {
        
        let headers = headerFormatter.formatHeaders(usingIdentifier: identifier, andSigningKey: key)
        let content = try self.formatClaims(from: response, usingIdentifier: identifier, andSignWith: key)
        
        guard var token = JwsToken(headers: headers, content: content) else {
            throw FormatterError.unableToFormToken
        }
        
        try token.sign(using: self.signer, withSecret: key.keyReference)
        
        return token
    }
    
    private func formatClaims(from response: PresentationResponseContainer, usingIdentifier identifier: Identifier, andSignWith key: KeyContainer) throws -> PresentationResponseClaims {
        
        let publicKey = try signer.getPublicJwk(from: key.keyReference, withKeyId: key.keyId)
        let timeConstraints = TokenTimeConstraints(expiryInSeconds: response.expiryInSeconds)
        
        let presentationSubmission = self.formatPresentationSubmission(from: response, keyType: "JWT")
        
        return PresentationResponseClaims(publicKeyThumbprint: try publicKey.getThumbprint(),
                                          audience: response.audienceUrl,
                                          did: identifier.longFormDid,
                                          publicJwk: publicKey,
                                          jti: UUID().uuidString,
                                          presentationSubmission: presentationSubmission,
                                          state: response.request.content.state,
                                          nonce: response.request.content.nonce,
                                          iat: timeConstraints.issuedAt,
                                          nbf: timeConstraints.issuedAt,
                                          exp: timeConstraints.expiration)
    }
    
    private func formatPresentationSubmission(from response: PresentationResponseContainer, keyType: String) -> PresentationSubmission? {
        
        guard !response.requestVCMap.isEmpty else {
            return nil
        }
        
        let inputDescriptorMap: [InputDescriptorMapping] = response.requestVCMap.enumerated().map { (index, vcMapping) in
            createInputDescriptorMapping(type: vcMapping.type, index: index)
        }
        
        sdkLog.logVerbose(message: """
            Creating Presentation Response with:
            verifiable credentials: \(response.requestVCMap.count)
            """)
        
        let submission = PresentationSubmission(id: "test",
                                                definitionId: "test",
                                                inputDescriptorMap: inputDescriptorMap)
        
        return submission
    }
    
    private func createInputDescriptorMapping(type: String, index: Int) -> InputDescriptorMapping {
        let nestedInputDescriptorMapping = NestedInputDescriptorMapping(id: type,
                                                                        format: "jwt_vc",
                                                                        path: "$.verifiableCredential[\(index)]")
        
        return InputDescriptorMapping(id: type,
                                      format: "jwt_vp",
                                      path: "$",
                                      pathNested: nestedInputDescriptorMapping)
    }
}
