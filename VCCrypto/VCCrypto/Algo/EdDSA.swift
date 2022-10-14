/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import CryptoKit

enum ED25519Error: Error {
    case notImplemented
}

struct EdDSA: Signing {
    
    func sign(message: Data, withSecret secret: VCCryptoSecret) throws -> Data {
        throw ED25519Error.notImplemented
    }
    
    func isValidSignature(signature: Data, forMessage message: Data, usingPublicKey publicKey: PublicKey) throws -> Bool {
        let pubKey = try Curve25519.Signing.PublicKey(rawRepresentation: publicKey.uncompressedValue)
        return pubKey.isValidSignature(signature, for: message)
    }
    
    func createPublicKey(forSecret secret: VCCryptoSecret) throws -> PublicKey {
        throw ED25519Error.notImplemented
    }

}
