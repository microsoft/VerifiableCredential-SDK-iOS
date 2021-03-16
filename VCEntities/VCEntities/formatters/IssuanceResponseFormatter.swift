/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCJwt

public protocol IssuanceResponseFormatting {
    func format(response: IssuanceResponseContainer, usingIdentifier identifier: Identifier) throws -> IssuanceResponse
}

public class IssuanceResponseFormatter: IssuanceResponseFormatting {
    
    private let signer: TokenSigning
    private let sdkLog: VCSDKLog
    private let headerFormatter = JwsHeaderFormatter()
    private let vpFormatter: VerifiablePresentationFormatter
    
    public init(signer: TokenSigning = Secp256k1Signer(),
                sdkLog: VCSDKLog = VCSDKLog.sharedInstance) {
        self.signer = signer
        self.vpFormatter = VerifiablePresentationFormatter(signer: signer)
        self.sdkLog = sdkLog
    }
    
    public func format(response: IssuanceResponseContainer, usingIdentifier identifier: Identifier) throws -> IssuanceResponse {
        
        guard let signingKey = identifier.didDocumentKeys.first else {
            throw FormatterError.noSigningKeyFound
        }
        
        return try createToken(response: response, usingIdentifier: identifier, andSignWith: signingKey)
    }
    
    private func createToken(response: IssuanceResponseContainer, usingIdentifier identifier: Identifier, andSignWith key: KeyContainer) throws -> IssuanceResponse {
        
        let headers = headerFormatter.formatHeaders(usingIdentifier: identifier, andSigningKey: key)
        let content = try self.formatClaims(response: response, usingIdentifier: identifier, andSigningKey: key)
        
        guard var token = JwsToken(headers: headers, content: content) else {
            throw FormatterError.unableToFormToken
        }
        
        try token.sign(using: self.signer, withSecret: key.keyReference)
        return token
    }
    
    private func formatClaims(response: IssuanceResponseContainer, usingIdentifier identifier: Identifier, andSigningKey key: KeyContainer) throws -> IssuanceResponseClaims {
        
        let publicKey = try signer.getPublicJwk(from: key.keyReference, withKeyId: key.keyId)
        let timeConstraints = TokenTimeConstraints(expiryInSeconds: response.expiryInSeconds)
        let attestations = try self.formatAttestations(response: response, usingIdentifier: identifier, andSignWith: key)
        
        return IssuanceResponseClaims(publicKeyThumbprint: try publicKey.getThumbprint(),
                                      audience: response.audienceUrl,
                                      did: identifier.longFormDid,
                                      publicJwk: publicKey,
                                      contract: response.contractUri,
                                      jti: UUID().uuidString,
                                      attestations: attestations,
                                      pin: nil,
                                      iat: timeConstraints.issuedAt,
                                      exp: timeConstraints.expiration)
    }
    
    private func formatAttestations(response: IssuanceResponseContainer, usingIdentifier identifier: Identifier, andSignWith key: KeyContainer) throws -> AttestationResponseDescriptor? {
        
        var idTokenMap: RequestedIdTokenMap? = nil
        if !response.requestedIdTokenMap.isEmpty {
            idTokenMap = response.requestedIdTokenMap
        }
        
        var selfIssuedMap: RequestedSelfAttestedClaimMap? = nil
        if !response.requestedSelfAttestedClaimMap.isEmpty {
            selfIssuedMap = response.requestedSelfAttestedClaimMap
        }
        
        if response.issuancePin != nil {
            if selfIssuedMap == nil {
                selfIssuedMap = [:]
            }
            selfIssuedMap?[VCEntitiesConstants.PIN] = response.issuancePin
            
            if idTokenMap == nil {
                idTokenMap = [:]
            }
            idTokenMap?[VCEntitiesConstants.SELF_ISSUED] = response.issuanceIdToken
        }
        
        var presentationsMap: [String: String]? = nil
        if !response.requestVCMap.isEmpty {
            presentationsMap = try self.createPresentations(from: response, usingIdentifier: identifier, andSignWith: key)
        }
        
        sdkLog.logVerbose(message: """
            Creating Issuance Response with:
            id_tokens: \(idTokenMap?.count ?? 0)
            self_issued claims: \(selfIssuedMap?.count ?? 0)
            verifiable credentials: \(presentationsMap?.count ?? 0)
            """)
        
        return AttestationResponseDescriptor(idTokens: idTokenMap, presentations: presentationsMap, selfIssued: selfIssuedMap)
    }
    
    private func createPresentations(from response: IssuanceResponseContainer, usingIdentifier identifier: Identifier, andSignWith key: KeyContainer) throws -> [String: String] {
        return try response.requestVCMap.mapValues { verifiableCredential in
            
            let vp = try self.vpFormatter.format(toWrap: verifiableCredential,
                                                 withAudience: response.contract.input.issuer,
                                                 withExpiryInSeconds: response.expiryInSeconds,
                                                 usingIdentifier: identifier,
                                                 andSignWith: key)
            
            return try vp.serialize()
        }
    }
}
