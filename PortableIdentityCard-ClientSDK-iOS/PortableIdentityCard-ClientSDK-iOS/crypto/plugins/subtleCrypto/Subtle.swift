//
//  Subtle.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/30/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

class Subtle: SubtleCrypto {

    let providers: [String: Provider]
    
    init(providers: Set<Provider>) {
        let transformedProviders = providers.map { ($0.name, $0) }
        self.providers = Dictionary<String, Provider>(uniqueKeysWithValues: transformedProviders)
    }
    
    private func getProvider(_ algorithmName: String) throws -> Provider {
        if let provider = self.providers[algorithmName.lowercased()] {
            return provider
        } else {
            throw ProviderError.AlgorithmNameNotRecognized(algorithmName: algorithmName)
        }
    }
    
    func encrypt(algorithm: Algorithm, key: CryptoKey, data: [UInt8]) throws -> [UInt8] {
        let provider = try getProvider(algorithm.name)
        return try provider.encrypt(algorithm: algorithm, key: key, data: data)
    }
    
    func decrypt(algorithm: Algorithm, key: CryptoKey, data: [UInt8]) throws -> [UInt8] {
        let provider = try getProvider(algorithm.name)
        return try provider.decrypt(algorithm: algorithm, key: key, data: data)
    }
    
    func sign(algorithm: Algorithm, key: CryptoKey, data: [UInt8]) throws -> [UInt8] {
        let provider = try getProvider(algorithm.name)
        return try provider.sign(algorithm: algorithm, key: key, data: data)
    }
    
    func verify(algorithm: Algorithm, key: CryptoKey, signature: [UInt8], data: [UInt8]) throws -> Bool {
        let provider = try getProvider(algorithm.name)
        return try provider.verify(algorithm: algorithm, key: key, signature: signature, data: data)
    }
    
    func digest(algorithm: Algorithm, data: [UInt8]) throws -> [UInt8] {
        let provider = try getProvider(algorithm.name)
        return try provider.digest(algorithm: algorithm, data: data)
    }
    
    func generateKey(algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKey {
        let provider = try getProvider(algorithm.name)
        return try provider.generateKey(algorithm: algorithm, extractable: extractable, keyUsages: keyUsages)
    }
    
    func generateKeyPair(algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKeyPair {
        let provider = try getProvider(algorithm.name)
        return try provider.generateKeyPair(algorithm: algorithm, extractable: extractable, keyUsages: keyUsages)
    }
    
    func deriveKey(algorithm: Algorithm, baseKey: CryptoKey, derivedKeyType: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>, length: UInt64) throws -> CryptoKey {
        // check derivedKeyType
        let importProvider = try getProvider(derivedKeyType.name)
        try importProvider.checkDerivedKeyParams(algorithm: derivedKeyType)
        
        // derive bits
        let provider = try getProvider(algorithm.name)
        try provider.checkCryptoKey(baseKey, KeyUsage.DeriveKey)
        let derivedBits = try provider.deriveBits(algorithm: algorithm, baseKey: baseKey, length: length)
        
        // import derived key
        return try importKey(format: KeyFormat.Raw, keyData: derivedBits, algorithm: derivedKeyType, extractable: extractable, keyUsages: keyUsages)
    }
    
    func deriveBits(algorithm: Algorithm, baseKey: CryptoKey, length: UInt64) throws -> [UInt8] {
        let provider = try getProvider(algorithm.name)
        return try provider.deriveBits(algorithm: algorithm, baseKey: baseKey, length: length)
    }
    
    func importKey(format: KeyFormat, keyData: [UInt8], algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKey {
        let provider = try getProvider(algorithm.name)
        return try provider.importKey(format: format, keyData: keyData, algorithm: algorithm, extractable: extractable, keyUsages: keyUsages)
    }
    
    func importKey(format: KeyFormat, keyData: JsonWebKey, algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKey {
        let provider = try getProvider(algorithm.name)
        return try provider.importKey(format: format, keyData: keyData, algorithm: algorithm, extractable: extractable, keyUsages: keyUsages)
    }
    
    func exportKey(format: KeyFormat, key: CryptoKey) throws -> [UInt8] {
        let provider = try getProvider(key.algorithm.name)
        return try provider.exportKey(format: format, key: key)
    }
    
    func exportKeyJwk(key: CryptoKey) throws -> JsonWebKey {
        let provider = try getProvider(key.algorithm.name)
        return try provider.exportKeyJwk(key: key)
    }
    
    func wrapKey(format: KeyFormat, key: CryptoKey, wrappingKey: CryptoKey, wrapAlgorithm: Algorithm) throws -> [UInt8] {
        let encoder = JSONEncoder()
        var keyData: [UInt8]
        if (format == KeyFormat.Jwk) {
            let keyJwk = try exportKeyJwk(key: key)
            let stringifiedJwk = String(data: (try encoder.encode(keyJwk)), encoding: .utf8)!
            keyData = Array(stringifiedJwk.utf8)
        } else {
            keyData = try exportKey(format: format, key: key)
        }
        
        let provider = try getProvider(wrapAlgorithm.name)
        return try provider.encrypt(algorithm: wrapAlgorithm, key: key, data: keyData)
    }
    
    func unwrapKey(format: KeyFormat, wrappedKey: [UInt8], unwrappingKey: CryptoKey, unwrapAlgorithm: Algorithm, unwrappedKeyAlgorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKey {
        
        let provider = try getProvider(unwrapAlgorithm.name)
        let keyData = try provider.decrypt(algorithm: unwrapAlgorithm, key: unwrappingKey, data: wrappedKey)
        if (format == KeyFormat.Jwk) {
            do {
                let stringifiedJwk = String(bytes: keyData, encoding: .utf8)!
                let jwk = JsonWebKey(kty: stringifiedJwk)
                return try importKey(format: format, keyData: jwk, algorithm: unwrappedKeyAlgorithm, extractable: extractable, keyUsages: keyUsages)
            } catch {
                throw SubtleCryptoError.WrappedKeyNotJSONWebKey
            }
        }
        return try importKey(format: format, keyData: keyData, algorithm: unwrappedKeyAlgorithm, extractable: extractable, keyUsages: keyUsages)
    }
}
