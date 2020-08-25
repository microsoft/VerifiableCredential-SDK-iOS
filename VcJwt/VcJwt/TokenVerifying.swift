/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcCrypto

protocol TokenVerifying {
    func verify<T>(token: JwsToken<T>, publicKeys: [Secp256k1PublicKey]) throws -> Bool
}


