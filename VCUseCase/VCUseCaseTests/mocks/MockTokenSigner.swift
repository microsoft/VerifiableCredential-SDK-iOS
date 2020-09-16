/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import PromiseKit
import VcJwt
import VcCrypto

@testable import VCUseCase

struct MockTokenSigner: TokenSigning {
    var algorithm: Signing = Secp256k1()
    
    func sign<T>(token: JwsToken<T>, withSecret secret: VcCryptoSecret) throws -> Signature where T : Claims {
        return Data(count: 64)
    }
}
