/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

@testable import VcJwt
import VcCrypto

class MockSigner: TokenSigning {
    
    func sign<T>(token: JwsToken<T>, withSecret secret: VcCryptoSecret) throws -> Signature where T : Claims {
        return "fakeSignature".data(using: .utf8)!
    }
    
}
