/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

let jwtType = "JWT"

func createTokenTimeConstraints(expiryInSeconds: Int) -> TokenTimeConstraints {
    let iat = (Date().timeIntervalSince1970).rounded(.down)
    let exp = iat + Double(expiryInSeconds)
    return TokenTimeConstraints(issuedAt: iat, expiration: exp)
}

func formatHeaders(usingIdentifier identifier: Identifier, andSigningKey key: KeyContainer) -> Header {
    let keyId = identifier.longFormDid + "#" + key.keyId
    return Header(type: jwtType, algorithm: key.algorithm, keyId: keyId)
}
