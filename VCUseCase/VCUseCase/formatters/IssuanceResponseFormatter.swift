/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/


import PromiseKit
import VCRepository
import VcNetworking
import VcJwt

class IssuanceResponseFormatter {
    
    func format() -> JwsToken<IssuanceResponseClaims>? {
        let claims = IssuanceResponseClaims()
        return nil
    }

}
