/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct IssuanceRequest {
    public let contract: Contract
    public let linkedDomainResult: LinkedDomainResult
    
    public init(contract: Contract, linkedDomainResult: LinkedDomainResult) {
        self.contract = contract
        self.linkedDomainResult = linkedDomainResult
    }
}
