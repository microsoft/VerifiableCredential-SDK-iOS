//
//  KeyStore.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 2/3/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

protocol KeyStore {
    
    /**
      Returns the key associated with the specified key reference.
     
       - Parameters:
         - keyReference for which to return the key.
     */
    func getSecretKey(keyReference: String) throws -> SecretKeyContainer
    
    func getPrivateKey(keyReference: String) throws -> PrivateKeyContainer
    
    func getPublicKey(keyReference: String) throws -> PublicKeyContainer
    
    /**
     Returns the key associated with the specific key id
     
     - Parameters:
       - keyIdentifier: the key identifier to search for
     */
    func getSecretKeyById(keyId: String) throws -> SecretKey?
    
    func getPrivateKeyById(keyId: String) throws -> PrivateKey?
    
    func getPublicKeyById(keyId: String) throws -> PublicKey?
    
    /**
     Saves the specified key to the key store using the key reference.
     
     - Parameters:
       - keyReference: reference for the kid being saved.
       - key: being saved to the key store
     */
    func save(keyReference: String, key: SecretKey) throws
    
    func save(keyReference: String, key: PrivateKey) throws
    
    func save(keyReference: String, key: PublicKey) throws
    
    /**
     Lists all key references with their corresponding key ids
     */
    func list() -> [String: KeyStoreListItem]
    

}
