/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct SelfIssuedClaimsDescriptor: Codable, Equatable {
    
    public let encrypted: Bool = false
    public let claims: [ClaimDescriptor] = []
    public let selfIssuedRequired: Bool = false

    enum CodingKeys: String, CodingKey {
        case encrypted, claims
        case selfIssuedRequired = "required"
    }
}
