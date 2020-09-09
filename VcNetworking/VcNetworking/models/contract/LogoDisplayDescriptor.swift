/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct LogoDisplayDescriptor: Codable {
    let uri: String
    let logoDescription: String

    enum CodingKeys: String, CodingKey {
        case uri
        case logoDescription = "description"
    }
}
