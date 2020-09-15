/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

@testable import VcJwt
import VcCrypto

enum MockError: Error {
    case unimplemented
}

struct MockVcCryptoSecret: VcCryptoSecret {
    let id: UUID
}

struct MockAlgorithm: Signing {
    func createPublicKey(forSecret secret: VcCryptoSecret) throws -> Secp256k1PublicKey {
        throw MockError.unimplemented
    }
    
    
    func sign(messageHash: Data, withSecret secret: VcCryptoSecret) throws -> Data {
        return messageHash
    }
    
    func isValidSignature(signature: Data, forMessageHash messageHash: Data, usingPublicKey publicKey: Secp256k1PublicKey) throws -> Bool {
        true
    }
}
