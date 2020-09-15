/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcJwt

public struct AttestationResponseDescriptor: Codable {
    public let idTokens: [String: String]? = nil
    public let presentations: [String: String]? = nil
}
