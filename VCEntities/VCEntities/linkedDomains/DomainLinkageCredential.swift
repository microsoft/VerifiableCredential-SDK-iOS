/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct DomainLinkageCredential: Codable {
    let subject: String
    let issuer: String
    let notValidBefore: Double
    let verifiableCredential: DomainLinkageCredentialContent
    
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case issuer = "iss"
        case notValidBefore = "nbf"
        case verifiableCredential = "vc"
    }
}
