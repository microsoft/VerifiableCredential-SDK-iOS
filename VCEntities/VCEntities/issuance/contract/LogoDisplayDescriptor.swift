/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct LogoDisplayDescriptor: Codable, Equatable {
    
    public let uri: String?
    public let logoDescription: String?

    // Image can be already included in the logo display descriptor as a base64 encoded png
    public let image: String?

    enum CodingKeys: String, CodingKey {
        case uri
        case logoDescription = "description"
        case image
    }
}
