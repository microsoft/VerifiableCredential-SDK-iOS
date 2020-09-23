/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking

enum IssuanceResponseError: Error {
    case noAudienceSpecifiedInContract
}

public struct IssuanceResponse {
    let contract: Contract
    let contractUri: String
    let expiryInSeconds: Int
    let audience: String
    public let requestedIdTokenMap: RequestedIdTokenMap = [:]
    public let requestedSelfAttestedClaimMap: RequestedSelfAttestedClaimMap = [:]
    
    public init(from contract: Contract, contractUri: String, expiryInSeconds exp: Int = 3000) throws {
        self.contract = contract
        self.contractUri = contractUri
        self.expiryInSeconds = exp
        guard let aud = contract.input?.credentialIssuer else {
            throw IssuanceResponseError.noAudienceSpecifiedInContract
        }
        
        self.audience = aud
        print(self.audience)
    }
}

public typealias RequestedIdTokenMap = [String:String]
public typealias RequestedSelfAttestedClaimMap = [String: String]
