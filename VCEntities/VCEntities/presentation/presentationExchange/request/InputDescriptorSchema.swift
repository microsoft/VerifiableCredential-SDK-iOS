/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

/// Describes the credentail type of the vc requested.
public struct InputDescriptorSchema: Codable, Equatable {

    /// List of uris that describe the credential requested.
    public let uri: String?
    
    enum CodingKeys: String, CodingKey {
        case uri
    }
    
    public init(uri: String? = nil) {
        self.uri = uri
    }
}
