/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct RegistrationClaims: Codable, Equatable {
    public let clientName: String?
    public let clientPurpose: String?
    public let tosURI: String?
    public let logoURI: String?

    enum CodingKeys: String, CodingKey {
        case clientName = "client_name"
        case clientPurpose = "client_purpose"
        case tosURI = "tos_uri"
        case logoURI = "logo_uri"
    }
}
