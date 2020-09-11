/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct RegistrationClaims: Codable {
    let clientName: String = ""
    let clientPurpose: String = ""
    let clientUri: String = ""
    let tosURI: String = ""
    let logoURI: String = ""

    enum CodingKeys: String, CodingKey {
        case clientName = "client_name"
        case clientPurpose = "client_purpose"
        case clientUri = "client_uri"
        case tosURI = "tos_uri"
        case logoURI = "logo_uri"
    }
}
