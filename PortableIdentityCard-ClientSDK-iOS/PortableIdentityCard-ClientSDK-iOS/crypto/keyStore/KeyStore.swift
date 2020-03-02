//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

protocol KeyStore {
    
    /**
      Returns the key associated with the specified key reference.
     
       - Parameters:
         - keyReference for which to return the key.
     */
    func getSecretKeyContainer(keyReference: String) throws -> SecretKeyContainer
    
    func getPrivateKeyContainer(keyReference: String) throws -> PrivateKeyContainer
    
    // func getPublicKeyContainer(keyReference: String) throws -> PublicKeyContainer
    
    /**
     Saves the specified key to the key store using the key reference.
     
     - Parameters:
       - keyReference: reference for the kid being saved.
       - key: being saved to the key store
     */
    func save(withCaseSensitiveKeyReference keyReference: String, key: KeyStoreItem) throws
    
    /**
     Lists all key references with their corresponding key ids
     */
    func list() throws -> [String: KeyStoreListItem]
    

}
