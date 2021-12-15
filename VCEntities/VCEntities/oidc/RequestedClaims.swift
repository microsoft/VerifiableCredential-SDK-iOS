/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

/// Claims that a being requested in an OpenID Connect Request.
public struct RequestedClaims: Codable, Equatable {
    
    public let vpToken: PresentationDefinition?

    enum CodingKeys: String, CodingKey {
        case vpToken = "vp_token"
    }
}
