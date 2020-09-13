/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct PresentationDescriptor: Codable, Equatable {
    
    let encrypted: Bool = false
    let claims: [ClaimDescriptor] = []
    let presentationRequired: Bool = false
    let credentialType: String = ""
    let issuers: [IssuerDescriptor] = []
    let contracts: [String] = []

    enum CodingKeys: String, CodingKey {
        case encrypted, claims
        case presentationRequired = "required"
        case credentialType, issuers, contracts
    }
}
