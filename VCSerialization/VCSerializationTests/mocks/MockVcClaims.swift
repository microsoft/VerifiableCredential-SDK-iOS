/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

@testable import VCSerialization

private let mockVcDescriptor = VerifiableCredentialDescriptor(context: ["context"], type: ["type"], credentialSubject: ["key": "value"], credentialStatus: nil, exchangeService: nil, revokeService: nil)
let mockVcClaims = VcClaims(jti: "id", iss: "issuer did", sub: "sub", vc: mockVcDescriptor)
