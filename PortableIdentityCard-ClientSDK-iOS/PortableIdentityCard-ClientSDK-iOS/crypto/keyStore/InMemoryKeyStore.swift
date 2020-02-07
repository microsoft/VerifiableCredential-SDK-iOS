//
//  InMemoryKeyStore.swift
//  PortableIdentityCard-ClientSDK-iOS
//
//  Created by Sydney Morton on 2/6/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

class InMemoryKeyStore: KeyStore {
    
    private var secretKeys: [String: SecretKeyContainer] = [:]
    private var privateKeys: [String: PrivateKeyContainer] = [:]
    private var publicKeys: [String: PublicKeyContainer] = [:]
    
    func getSecretKey(keyReference: String) throws -> SecretKeyContainer {
        if let key = secretKeys[keyReference] {
            return key
        } else {
            throw CryptoError.NoKeyFoundFor(keyName: keyReference)
        }
    }
    
    func getPrivateKey(keyReference: String) throws -> PrivateKeyContainer {
        if let key = privateKeys[keyReference] {
            return key
        } else {
            throw CryptoError.NoKeyFoundFor(keyName: keyReference)
        }
    }
    
    func getPublicKey(keyReference: String) throws -> PublicKeyContainer {
        if let key = publicKeys[keyReference] {
            return key
        } else {
            if let keyContainer = privateKeys[keyReference] {
                return try PublicKeyContainer(kty: keyContainer.kty, keys: keyContainer.keys.map { try ($0 as! PrivateKey).getPublicKey() }, use: keyContainer.use, alg: keyContainer.alg)
            } else {
                throw CryptoError.NoKeyFoundFor(keyName: keyReference)
            }
        }
    }
    
    func getSecretKeyById(keyId: String) throws -> SecretKey? {
        throw CryptoError.NotImplemented
    }
    
    func getPrivateKeyById(keyId: String) throws -> PrivateKey? {
        throw CryptoError.NotImplemented
    }
    
    func getPublicKeyById(keyId: String) throws -> PublicKey? {
        throw CryptoError.NotImplemented
    }
    
    func save(keyReference: String, key: SecretKey) throws {
        if let savedKeyContainer = self.secretKeys[keyReference] {
            savedKeyContainer.keys.append(key)
        } else {
            var algorithm: Algorithm?
            if let alg = key.alg {
                algorithm = try CryptoHelpers.jwaToWebCrypto(jwaAlgorithmName: alg)
            } else {
                algorithm = nil
            }
            self.secretKeys[keyReference] = SecretKeyContainer(
                kty: key.kty,
                keys: [key],
                use: key.use,
                alg: algorithm)
        }
    }
    
    func save(keyReference: String, key: PrivateKey) throws {
        if let savedKeyContainer = self.privateKeys[keyReference] {
            savedKeyContainer.keys.append(key)
        } else {
            var algorithm: Algorithm?
            if let alg = key.alg {
                algorithm = try CryptoHelpers.jwaToWebCrypto(jwaAlgorithmName: alg)
            } else {
                algorithm = nil
            }
            self.privateKeys[keyReference] = PrivateKeyContainer(
                kty: key.kty,
                keys: [key],
                use: key.use,
                alg: algorithm)
        }
    }
    
    func save(keyReference: String, key: PublicKey) throws {
        if let savedKeyContainer = self.publicKeys[keyReference] {
            savedKeyContainer.keys.append(key)
        } else {
            var algorithm: Algorithm?
            if let alg = key.alg {
                algorithm = try CryptoHelpers.jwaToWebCrypto(jwaAlgorithmName: alg)
            } else {
                algorithm = nil
            }
            self.publicKeys[keyReference] = PublicKeyContainer(
                kty: key.kty,
                keys: [key],
                use: key.use,
                alg: algorithm)
        }
    }
    
    func list() -> [String : KeyStoreListItem] {
        /// TODO
        return [:]
    }
    

}
