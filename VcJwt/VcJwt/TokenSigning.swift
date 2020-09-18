/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcCrypto

public protocol TokenSigning {
     
    func sign<T>(token: JwsToken<T>, withSecret secret: VcCryptoSecret) throws -> Signature
    
    func getPublicJwk(from secret: VcCryptoSecret, withKeyId keyId: String) throws -> ECPublicJwk
}
