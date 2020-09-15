/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct PresentationDescriptor: Codable, Equatable {
    
    public let encrypted: Bool = false
    public let claims: [ClaimDescriptor] = []
    public let presentationRequired: Bool = false
    public let credentialType: String = ""
    public let issuers: [IssuerDescriptor] = []
    public let contracts: [String] = []

    enum CodingKeys: String, CodingKey {
        case encrypted, claims
        case presentationRequired = "required"
        case credentialType, issuers, contracts
    }
}
