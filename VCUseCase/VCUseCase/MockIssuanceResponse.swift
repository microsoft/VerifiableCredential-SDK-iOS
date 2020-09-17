/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking

struct MockIssuanceResponse {
    let contract: Contract
    let contractUri: String
    let expiryInSeconds: Int
    let audience: String
    let requestedIdTokenMap: RequestedIdTokenMap = [:]
    
    init(from contract: Contract, contractUri: String, expiryInSeconds exp: Int = 300) throws {
        self.contract = contract
        self.contractUri = contractUri
        self.expiryInSeconds = exp
        guard let aud = contract.input?.credentialIssuer else {
            throw IssuanceUseCaseError.test
        }
        
        self.audience = aud
        print(self.audience)
    }
}

public typealias RequestedIdTokenMap = [String:String]
