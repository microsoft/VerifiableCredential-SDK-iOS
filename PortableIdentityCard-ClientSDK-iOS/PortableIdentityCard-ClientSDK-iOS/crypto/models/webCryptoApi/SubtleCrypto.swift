//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

/*
 * @see https://www.w3.org/TR/WebCryptoAPI/#subtlecrypto-interface
 */
protocol SubtleCrypto {
    
    func encrypt(algorithm: Algorithm, key: CryptoKey, data: [UInt8]) throws -> [UInt8]
    
    func decrypt(algorithm: Algorithm, key: CryptoKey, data: [UInt8]) throws -> [UInt8]
    
    func sign(algorithm: Algorithm, key: CryptoKey, data: [UInt8]) throws -> [UInt8]
    
    func verify(algorithm: Algorithm, key: CryptoKey, signature: [UInt8], data: [UInt8]) throws -> Bool
    
    func digest(algorithm: Algorithm, data: [UInt8]) throws -> [UInt8]
    
    func generateKey(algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKey
    
    func generateKeyPair(algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKeyPair
    
    func deriveKey(algorithm: Algorithm, baseKey: CryptoKey, derivedKeyType: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>, length: UInt64) throws -> CryptoKey
    
    func deriveBits(algorithm: Algorithm, baseKey: CryptoKey, length: UInt64) throws -> [UInt8]
    
    func importKey(format: KeyFormat, keyData: [UInt8], algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKey
    
    func importKey(format: KeyFormat, keyData: JsonWebKey, algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKey
    
    func exportKey(format: KeyFormat, key: CryptoKey) throws -> [UInt8]
    
    func exportKeyJwk(key: CryptoKey) throws -> JsonWebKey
    
    func wrapKey(format: KeyFormat, key: CryptoKey, wrappingKey: CryptoKey, wrapAlgorithm: Algorithm) throws -> [UInt8]
    
    func unwrapKey(format: KeyFormat, wrappedKey: [UInt8], unwrappingKey: CryptoKey, unwrapAlgorithm: Algorithm, unwrappedKeyAlgorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKey

}
