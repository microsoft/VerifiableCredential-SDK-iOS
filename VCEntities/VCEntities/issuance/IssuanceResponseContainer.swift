/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

enum IssuanceResponseError: Error {
    case noAudienceSpecifiedInContract
}

public struct IssuanceResponseContainer {
    public let contract: Contract
    public let contractUri: String
    let expiryInSeconds: Int
    public let audience: String
    public var requestedIdTokenMap: RequestedIdTokenMap = [:]
    public var requestedSelfAttestedClaimMap: RequestedSelfAttestedClaimMap = [:]
    
    public init(from contract: Contract, contractUri: String, expiryInSeconds exp: Int = 3000) throws {
        self.contract = contract
        self.contractUri = contractUri
        self.expiryInSeconds = exp
        
        guard let aud = contract.input?.credentialIssuer else {
            throw IssuanceResponseError.noAudienceSpecifiedInContract
        }
        
        self.audience = aud
    }
}
