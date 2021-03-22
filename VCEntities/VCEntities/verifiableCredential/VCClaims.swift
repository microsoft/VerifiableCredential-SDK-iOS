/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCToken

public struct VCClaims: Claims {
    public let jti: String
    public let iss: String
    public let sub: String
    public let iat: Double
    public let exp: Double
    public let vc: VerifiableCredentialDescriptor
}

public typealias VerifiableCredential = JwsToken<VCClaims>
