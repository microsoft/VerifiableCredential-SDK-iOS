/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

enum IssuanceResponseError: Error {
    case noAudienceSpecifiedInContract
}

public struct IssuanceResponseContainer: ResponseContaining {
    public let contract: Contract
    public let contractUri: String
    let expiryInSeconds: Int
    public let audienceUrl: String
    public let audienceDid: String
    public var issuancePin: String? = nil
    public var issuanceIdToken: String? = nil
    public var requestedIdTokenMap: RequestedIdTokenMap = [:]
    public var requestedSelfAttestedClaimMap: RequestedSelfAttestedClaimMap = [:]
    public var requestVCMap: RequestedVerifiableCredentialMap = [:]
    
    public init(from contract: Contract,
                contractUri: String,
                expiryInSeconds exp: Int = 3000,
                rawIssuerIdToken: String? = nil,
                issuancePin: String? = nil) throws {
        self.contract = contract
        self.contractUri = contractUri
        self.expiryInSeconds = exp
        
        guard let aud = contract.input?.credentialIssuer,
              let did = contract.input?.issuer else {
            throw IssuanceResponseError.noAudienceSpecifiedInContract
        }
        
        self.audienceUrl = aud
        self.audienceDid = did
        
        self.issuancePin = issuancePin
        self.issuanceIdToken = rawIssuerIdToken
    }
}

public typealias IssuanceResponse = JwsToken<IssuanceResponseClaims>
