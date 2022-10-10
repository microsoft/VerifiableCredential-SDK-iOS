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
    
    func generateKey() throws -> VCCryptoSecret {
        return MockVCCryptoSecret(id: UUID())
    }
    
    func retrieveKeyFromStorage(withId id: UUID) -> VCCryptoSecret {
        return MockVCCryptoSecret(id: UUID())
    }
    
    func save(key: Data, withId id: UUID) throws {}
    
    func deleteKey(withId id: UUID) throws {}
    
    func getKey(withId id: UUID) throws -> Data {
        return Data()
    }
    
    func verify(signature: Data, forMessageHash messageHash: Data, usingPublicKey publicKey: VCCrypto.PublicKey) throws -> Bool {
        return verifyResult
    }
    
    func sign(messageHash: Data, usingSecret secret: VCCryptoSecret) throws -> Data {
        return signingResult ?? Data()
    }
    
    func getPublicKey(fromSecret secret: VCCryptoSecret) throws -> PublicKey {
        return publicKey ?? Secp256k1PublicKey(x: Data(count: 32), y: Data(count: 32))!
    }
}
