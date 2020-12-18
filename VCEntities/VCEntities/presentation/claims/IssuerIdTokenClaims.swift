/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

public struct IssuerIdTokenClaims: Claims {
    public let attestations: IssuerIdTokenAttestations
}

public struct IssuerIdTokenAttestations: Codable {
    public let selfIssued: IssuerIdTokenSelfIssued
}

public struct IssuerIdTokenSelfIssued: Codable {
    public let pin: PinDescriptor
}

public struct PinDescriptor: Codable {
    
    public let type: String?
    
    public let length: Int
    
    public let hash: String
}
