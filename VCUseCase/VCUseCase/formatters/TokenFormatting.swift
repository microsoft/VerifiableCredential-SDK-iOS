/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/


import PromiseKit
import VCRepository
import VcNetworking
import VcJwt

protocol TokenFormatting {
    associatedtype TokenClaims: Claims
    
    func format(response: MockIssuanceResponse, usingIdentifier identifier: MockIdentifier) -> Promise<JwsToken<TokenClaims>>
}
