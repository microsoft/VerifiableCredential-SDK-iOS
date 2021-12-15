/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct SupportedVerifiablePresentationFormats: Codable, Equatable {
    public let jwtVP: AllowedAlgorithms?

    enum CodingKeys: String, CodingKey {
        case jwtVP = "jwt_vp"
    }
}
