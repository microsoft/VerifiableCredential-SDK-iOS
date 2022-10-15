/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

@testable import VCToken
import VCCrypto

class MockCryptoOperations: CryptoOperating {
    
    var verifyResult: Bool = true
    var signingResult: Data?
    var publicKey: PublicKey?
    
    init(verifyResult: Bool = true) {
        self.verifyResult = verifyResult
    }
    
    init(signingResult: Data) {
        self.signingResult = signingResult
    }
    
    init(publicKey: PublicKey) {
        self.publicKey = publicKey
    }
    
    func verify(signature: Data, forMessage message: Data, usingPublicKey publicKey: PublicKey) throws -> Bool {
        return verifyResult
    }
    
    func sign(message: Data, usingSecret secret: VCCryptoSecret, algorithm: String = "mock") throws -> Data {
        return signingResult ?? Data()
    }
    
    func getPublicKey(fromSecret secret: VCCryptoSecret, algorithm: String = "mock") throws -> PublicKey {
        return publicKey ?? Secp256k1PublicKey(x: Data(count: 32), y: Data(count: 32))!
    }
}
