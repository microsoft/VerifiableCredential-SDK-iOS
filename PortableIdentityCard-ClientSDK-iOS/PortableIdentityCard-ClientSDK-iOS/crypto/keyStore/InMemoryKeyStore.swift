//
//  InMemoryKeyStore.swift
//  PortableIdentityCard-ClientSDK-iOS
//
//  Created by Sydney Morton on 2/6/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

class InMemoryKeyStore: KeyStore {
    func getSecretKey(keyReference: String) throws -> SecretKeyContainer {
        throw CryptoError.NotImplemented
    }
    
    func getPrivateKey(keyReference: String) throws -> PrivateKeyContainer {
        throw CryptoError.NotImplemented
    }
    
    func getPublicKey(keyReference: String) throws -> PublicKeyContainer {
        throw CryptoError.NotImplemented
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
        throw CryptoError.NotImplemented
    }
    
    func save(keyReference: String, key: PrivateKey) throws {
        throw CryptoError.NotImplemented
    }
    
    func save(keyReference: String, key: PublicKey) throws {
        throw CryptoError.NotImplemented
    }
    
    func list() -> [String : KeyStoreListItem] {
        return [:]
    }
    

}
