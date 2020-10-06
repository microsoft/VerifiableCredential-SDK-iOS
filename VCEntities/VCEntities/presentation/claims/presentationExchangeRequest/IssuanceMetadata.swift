/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct IssuanceMetadata: Codable, Equatable {
    
    public let contract: String?
    
    public let issuerDid: String?

    enum CodingKeys: String, CodingKey {
        case contract = "manifest"
        case issuerDid = "did"
    }
}
