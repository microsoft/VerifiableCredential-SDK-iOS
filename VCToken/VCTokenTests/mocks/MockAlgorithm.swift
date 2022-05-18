/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

@testable import VCToken
import VCCrypto

enum MockError: Error {
    case unimplemented
}

struct MockVCCryptoSecret: VCCryptoSecret {
    
    let accessGroup: String? = nil
    
    func isValidKey() -> Bool {
        true
    }
    
    func migrateKey(fromAccessGroup oldAccessGroup: String?) throws {}
    
    let id: UUID

    func withUnsafeBytes(_ body: (UnsafeRawBufferPointer) throws -> Void) throws { }
}

struct MockAlgorithm: Signing {
    
    let x: Data
    let y: Data
    
    init() {
        self.x = Data(count: 32)
        self.y = Data(count: 32)
    }
    
    init(x: Data, y: Data) {
        self.x = x
        self.y = y
    }
    
    func createPublicKey(forSecret secret: VCCryptoSecret) throws -> Secp256k1PublicKey {
        return Secp256k1PublicKey(x: self.x, y: self.y)!
    }
    
    func sign(messageHash: Data, withSecret secret: VCCryptoSecret) throws -> Data {
        return messageHash
    }
    
    func isValidSignature(signature: Data, forMessageHash messageHash: Data, usingPublicKey publicKey: Secp256k1PublicKey) throws -> Bool {
        true
    }
}
