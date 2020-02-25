//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

enum ProviderError: Error {
    case DigestNotSupported
    case GenerateKeyNotSupported
    case GenerateKeyPairNotSupported
    case SignNotSupported
    case VerifyNotSupported
    case EncryptNotSupported
    case DecryptNotSupported
    case DeriveBitsNotSupported
    case ExportKeyNotSupported
    case ExportKeyJwkNotSupported
    case ImportKeyNotSupported
    case AlgorithmNameNotRecognized(algorithmName: String)
    case KeyUsageForbidden(forbiddenUsages: Set<KeyUsage>)
    case KeyUsageNeeded
    case DeriveBitsMalformed
    case KeyUnExtractable
    case UnmatchedKeyFormatforImportedKey
}

class Provider: NSObject, Codable {
    var name: String
    var privateKeyUsage: Set<KeyUsage>?
    var publicKeyUsage: Set<KeyUsage>?
    var symmetricKeyUsage: Set<KeyUsage>?
    
    init(name: String, privateKeyUsage: Set<KeyUsage>?, publicKeyUsage: Set<KeyUsage>?, symmetricKeyUsage: Set<KeyUsage>?) {
        self.name = name
        self.privateKeyUsage = privateKeyUsage
        self.publicKeyUsage = publicKeyUsage
        self.symmetricKeyUsage = symmetricKeyUsage
    }

    internal func onDigest(algorithm: Algorithm, data: [UInt8]) throws -> [UInt8] {
        throw ProviderError.DigestNotSupported
    }
    
    internal func onGenerateKey(algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKey {
        throw ProviderError.GenerateKeyNotSupported
    }
    
    internal func onGenerateKeyPair(algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKeyPair {
        throw ProviderError.GenerateKeyPairNotSupported
    }
    
    internal func onSign(algorithm: Algorithm, key: CryptoKey, data: [UInt8]) throws -> [UInt8] {
        throw ProviderError.SignNotSupported
    }
    
    internal func onVerify(algorithm: Algorithm, key: CryptoKey, signature: [UInt8], data: [UInt8]) throws -> Bool {
        throw ProviderError.VerifyNotSupported
    }
    
    internal func onEncrypt(algorithm: Algorithm, key: CryptoKey, data: [UInt8]) throws -> [UInt8] {
        throw ProviderError.EncryptNotSupported
    }
    
    internal func onDecrypt(algorithm: Algorithm, key: CryptoKey, data: [UInt8]) throws -> [UInt8] {
        throw ProviderError.DecryptNotSupported
    }
    
    internal func onDeriveBits(algorithm: Algorithm, baseKey: CryptoKey, length: UInt64) throws -> [UInt8] {
        throw ProviderError.DeriveBitsNotSupported
    }
    
    internal func onExportKey(format: KeyFormat, key: CryptoKey) throws -> [UInt8] {
        throw ProviderError.ExportKeyNotSupported
    }
    
    internal func onExportKeyJwk(key: CryptoKey) throws -> JsonWebKey {
        throw ProviderError.ExportKeyJwkNotSupported
    }
    
    internal func onImportKey(format: KeyFormat, keyData: [UInt8], algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKey {
        throw ProviderError.ImportKeyNotSupported
    }
    
    internal func onImportKey(format: KeyFormat, keyData: JsonWebKey, algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKey {
        throw ProviderError.ImportKeyNotSupported
    }
    
    internal func checkGenerateKeyParams(algorithm: Algorithm) throws {
        throw ProviderError.GenerateKeyNotSupported
    }
    
    internal func checkDerivedKeyParams(algorithm: Algorithm) throws {
        throw ProviderError.DeriveBitsNotSupported
    }
    
    public func digest(algorithm: Algorithm, data: [UInt8]) throws -> [UInt8] {
        try checkDigest(algorithm)
        return try self.onDigest(algorithm: algorithm, data: data)
    }
    
    public func generateKey(algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKey {
        try checkGenerateKey(algorithm, extractable, keyUsages)
        return try onGenerateKey(algorithm: algorithm, extractable: extractable, keyUsages: keyUsages)
    }
    
    public func generateKeyPair(algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKeyPair {
        try checkGenerateKeyParams(algorithm: algorithm)
        return try onGenerateKeyPair(algorithm: algorithm, extractable: extractable, keyUsages: keyUsages)
    }
    
    public func sign(algorithm: Algorithm, key: CryptoKey, data: [UInt8]) throws -> [UInt8] {
        try checkSign(algorithm, key)
        return try onSign(algorithm: algorithm, key: key, data: data)
    }
    
    public func verify(algorithm: Algorithm, key: CryptoKey, signature: [UInt8], data: [UInt8]) throws -> Bool {
        try checkVerify(algorithm, key)
        return try onVerify(algorithm: algorithm, key: key, signature: signature, data: data)
    }
    
    public func encrypt(algorithm: Algorithm, key: CryptoKey, data: [UInt8]) throws -> [UInt8] {
        try checkEncrypt(algorithm, key)
        return try onEncrypt(algorithm: algorithm, key: key, data: data)
    }
    
    public func decrypt(algorithm: Algorithm, key: CryptoKey, data: [UInt8]) throws -> [UInt8] {
        try checkDecrypt(algorithm, key)
        return try onDecrypt(algorithm: algorithm, key: key, data: data)
    }
    
    public func deriveBits(algorithm: Algorithm, baseKey: CryptoKey, length: UInt64) throws -> [UInt8] {
        try checkDeriveBits(algorithm, baseKey, length)
        return try onDeriveBits(algorithm: algorithm, baseKey: baseKey, length: length)
    }
    
    public func exportKey(format: KeyFormat, key: CryptoKey) throws -> [UInt8] {
        try checkExportKey(format, key)
        return try onExportKey(format: format, key: key)
    }
    
    public func exportKeyJwk(key: CryptoKey) throws -> JsonWebKey {
        try checkExportKey(KeyFormat.Jwk, key)
        return try onExportKeyJwk(key: key)
    }
    
    public func importKey(format: KeyFormat, keyData: [UInt8], algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKey {
        if (format == KeyFormat.Jwk) {
            throw ProviderError.UnmatchedKeyFormatforImportedKey
        }
        try checkImportKey(format, algorithm, extractable, keyUsages)
        return try onImportKey(format: format, keyData: keyData, algorithm: algorithm, extractable: extractable, keyUsages: keyUsages)
    }
    
    public func importKey(format: KeyFormat, keyData: JsonWebKey, algorithm: Algorithm, extractable: Bool, keyUsages: Set<KeyUsage>) throws -> CryptoKey {
        if (format != KeyFormat.Jwk) {
            throw ProviderError.UnmatchedKeyFormatforImportedKey
        }
        try checkImportKey(format, algorithm, extractable, keyUsages)
        return try onImportKey(format: format, keyData: keyData, algorithm: algorithm, extractable: extractable, keyUsages: keyUsages)
    }

    private func checkDigest(_ algorithm: Algorithm) throws {
        try checkAlgorithmName(algorithm)
    }
    
    private func checkGenerateKey(_ algorithm: Algorithm, _ extractable: Bool, _ keyUsages: Set<KeyUsage>) throws {
        try checkAlgorithmName(algorithm)
        try checkGenerateKeyParams(algorithm: algorithm)
        if (keyUsages.count == 0) {
            throw ProviderError.KeyUsageNeeded
        }
        let allowedUsages: Set<KeyUsage>
        if self.symmetricKeyUsage != nil {
            allowedUsages = self.symmetricKeyUsage!
        } else {
            allowedUsages = self.privateKeyUsage!.union(self.publicKeyUsage!)
        }
        try checkKeyUsages(keyUsages, allowedUsages)
    }
    
    private func checkSign(_ algorithm: Algorithm, _ key: CryptoKey) throws {
        try checkAlgorithmName(algorithm)
        try checkAlgorithmParams(algorithm)
        try checkCryptoKey(key, KeyUsage.Sign)
    }
    
    private func checkVerify(_ algorithm: Algorithm, _ key: CryptoKey) throws {
        try checkAlgorithmName(algorithm)
        try checkAlgorithmParams(algorithm)
        try checkCryptoKey(key, KeyUsage.Verify)
    }
    
    private func checkEncrypt(_ algorithm: Algorithm, _ key: CryptoKey) throws {
        try checkAlgorithmName(algorithm)
        try checkAlgorithmParams(algorithm)
        try checkCryptoKey(key, KeyUsage.Encrypt)
    }
    
    private func checkDecrypt(_ algorithm: Algorithm, _ key: CryptoKey) throws {
        try checkAlgorithmName(algorithm)
        try checkAlgorithmParams(algorithm)
        try checkCryptoKey(key, KeyUsage.Decrypt)
    }
    
    private func checkDeriveBits(_ algorithm: Algorithm, _ baseKey: CryptoKey, _ length: UInt64) throws {
        try checkAlgorithmName(algorithm)
        try checkAlgorithmParams(algorithm)
        try checkCryptoKey(baseKey, KeyUsage.DeriveBits)
        let (remainder, _) = length.remainderReportingOverflow(dividingBy: 8)
        if remainder != 0 {
            throw ProviderError.DeriveBitsMalformed
        }
    }
    
    private func checkExportKey(_ format: KeyFormat, _ key: CryptoKey) throws {
        if (!key.extractable) {
            throw ProviderError.KeyUnExtractable
        }
    }
    
    private func checkImportKey(_ format: KeyFormat, _ algorithm: Algorithm, _ extractable: Bool, _ keyUsages: Set<KeyUsage>) throws {
        try checkAlgorithmName(algorithm)
        try checkAlgorithmParams(algorithm)
        try checkImportParams(algorithm)
        
        if (self.symmetricKeyUsage != nil) {
            try checkKeyUsages(keyUsages, self.symmetricKeyUsage!)
        } else {
            do {
                try checkKeyUsages(keyUsages, self.privateKeyUsage!)
            } catch {
                try checkKeyUsages(keyUsages, self.publicKeyUsage!)
            }
        }
    }
    
    internal func checkAlgorithmName(_ algorithm: Algorithm) throws {
        if (algorithm.name.lowercased() != self.name.lowercased()) {
            throw ProviderError.AlgorithmNameNotRecognized(algorithmName: algorithm.name)
        }
    }
    
    internal func checkAlgorithmParams(_ algorithm: Algorithm) throws {
        // there are no generic checks
    }
    
    internal func checkKeyUsages(_ usages: Set<KeyUsage>, _ allowed: Set<KeyUsage>) throws {
        let forbiddenUsages = usages.subtracting(allowed)
        if (!forbiddenUsages.isEmpty) {
            throw ProviderError.KeyUsageForbidden(forbiddenUsages: forbiddenUsages)
        }
    }
    
    internal func checkCryptoKey(_ key: CryptoKey, _ keyUsage: KeyUsage) throws {
        try checkAlgorithmName(key.algorithm)
        if (!key.usages.contains(keyUsage)) {
            throw ProviderError.KeyUsageForbidden(forbiddenUsages: [keyUsage])
        }
    }
    
    internal func checkImportParams(_ algorithm: Algorithm) throws {
        // there are no generic checks to perform
    }
}
