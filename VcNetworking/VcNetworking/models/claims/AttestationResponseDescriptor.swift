/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcJwt

struct AttestationResponseDescriptor: Codable {
    let idTokens: [String: String]? = nil
    let presentations: [String: String]? = nil
}
