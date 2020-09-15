/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking

struct MockIssuanceResponse {
    let contract: Contract
    let contractUri: String
    let expiryInSeconds: Int
    let requestedIdTokenMap: RequestedIdTokenMap = [:]
    
    init(from contract: Contract, contractUri: String, expiryInSeconds exp: Int = 300) {
        self.contract = contract
        self.contractUri = contractUri
        self.expiryInSeconds = exp
    }
}

public typealias RequestedIdTokenMap = [String:String]
