/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct CardDisplayDescriptor: Codable, Equatable {
    let title, issuedBy, backgroundColor, textColor: String
    let logo: LogoDisplayDescriptor
    let cardDescription: String

    enum CodingKeys: String, CodingKey {
        case title, issuedBy, backgroundColor, textColor, logo
        case cardDescription = "description"
    }
}
