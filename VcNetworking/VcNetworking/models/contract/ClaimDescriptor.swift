/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct ClaimDescriptor: Codable, Equatable {
    public let claim: String = ""
    public let claimRequired: Bool = false
    public let indexed: Bool = false

    enum CodingKeys: String, CodingKey {
        case claim
        case claimRequired = "required"
        case indexed
    }
}
