/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import CryptoKit

enum ED25519Error: Error {
    case notImplemented
    case invalidKey
}

struct ED25519: Signing {
    
    private let publicKey: ED25519PublicKey
    
    init(publicKey: PublicKey) throws {
        guard let edKey = publicKey as? ED25519PublicKey else {
            throw ED25519Error.invalidKey
        }
        self.publicKey = edKey
    }

    func sign(messageHash: Data) throws -> Data {
        throw ED25519Error.notImplemented
    }

    func isValidSignature(signature: Data, forMessage message: Data) throws -> Bool {
        let pubKey = try Curve25519.Signing.PublicKey(rawRepresentation: publicKey.uncompressedValue)
        return pubKey.isValidSignature(signature, for: message)
    }

    func getPublicKey() throws -> PublicKey {
        throw ED25519Error.notImplemented
    }
    
    
}
