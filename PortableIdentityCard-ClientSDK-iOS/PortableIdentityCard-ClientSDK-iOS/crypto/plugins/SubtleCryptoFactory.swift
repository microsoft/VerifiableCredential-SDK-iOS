//
//  SubtleCryptoFactory.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/28/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

let defaultAlgorithm = "*"

enum SubtleCryptoError: Error {
    case Scoping
    case WrappedKeyNotJSONWebKey
}

class SubtleCryptoFactory {
    
    private let defaultSubtleCryptoMapItem: SubtleCryptoMapItem
    
    // The key encrypters
    var keyEncrypters: [String: [SubtleCryptoMapItem]]
    
    // The shared key encrypters
    var sharedKeyEncrypters: [String: [SubtleCryptoMapItem]]
    
    // The symmetric content encrypters
    var symmetricEncrypters: [String: [SubtleCryptoMapItem]]
    
    // The message signers
    var messageSigners: [String: [SubtleCryptoMapItem]]
    
    // The hmac operations
    var messageAuthenticationCodeSigners: [String: [SubtleCryptoMapItem]]
    
    // The digest operations
    var messageDigests: [String: [SubtleCryptoMapItem]]
    
    
    init(defaultSubtleCrypto: SubtleCrypto) {
        self.defaultSubtleCryptoMapItem = SubtleCryptoMapItem(subtleCrypto: defaultSubtleCrypto, scope: SubtleCryptoScope.All)
        self.keyEncrypters = [defaultAlgorithm: [self.defaultSubtleCryptoMapItem] ]
        self.sharedKeyEncrypters = [defaultAlgorithm: [self.defaultSubtleCryptoMapItem] ]
        self.symmetricEncrypters = [defaultAlgorithm: [self.defaultSubtleCryptoMapItem] ]
        self.messageSigners = [defaultAlgorithm: [self.defaultSubtleCryptoMapItem] ]
        self.messageAuthenticationCodeSigners = [defaultAlgorithm: [self.defaultSubtleCryptoMapItem] ]
        self.messageDigests = [defaultAlgorithm: [self.defaultSubtleCryptoMapItem] ]
    }
    
    /*
     * Sets the key encrypter plugin given the encryption algorithm's name
     * @param name The name of the algorithm
     * @param cryptoSuiteMapItem Array containing subtle crypto API's and their scope
     */
    func addKeyEncrypter(name: String, subtleCrypto: SubtleCryptoMapItem) {
        self.keyEncrypters = addOrCreateListFor(dict: self.keyEncrypters, name, subtleCrypto)
    }
    
    /*
     * Gets the key encrypter object given the encryption algorithm's name
     * @param name The name of the algorithm
     * @return The corresponding crypto API
     */
    func getKeyEncrypter(name: String, scope: SubtleCryptoScope) throws -> SubtleCrypto {
        return try getSubtleCryptoFrom(dict: self.keyEncrypters, name, scope)
    }
    
    /*
     * Sets the shared key encrypter plugin given the encryption algorithm's name
     * @param name The name of the algorithm
     * @param cryptoSuiteMapItem Array containing subtle crypto API's and their scope
     */
    func addSharedKeyEncrypter(name: String, subtleCrypto: SubtleCryptoMapItem) {
        self.sharedKeyEncrypters = addOrCreateListFor(dict: self.sharedKeyEncrypters, name, subtleCrypto)
    }
    
    /*
     * Gets the shared key encrypter object given the encryption algorithm's name
     * Used for DH algorithms
     * @param name The name of the algorithms
     * @return The corresponding crypto API
     */
    func getSharedKeyEncrypter(name: String, scope: SubtleCryptoScope) throws -> SubtleCrypto {
        return try getSubtleCryptoFrom(dict: self.sharedKeyEncrypters, name, scope)
    }
    
    /*
     * Sets the SymmetricEncrypter object plugin given the encryption algorithm's name
     * @param name The name of the algorithm
     * @param cryptoSuiteMapItem Array ccontaining subtle crypto API's and their scope
     */
    func addSymmetricEncrypter(name: String, subtleCrypto: SubtleCryptoMapItem) {
        self.symmetricEncrypters = addOrCreateListFor(dict: self.symmetricEncrypters, name, subtleCrypto)
    }
    
    /*
     * Gets the SymmetricEncrypter object given the symmetric encryption algorithm's name
     * @param name The name of the algorithm
     * @returns the corresponding crypto API.
     */
    func getSymmetricEncrypter(name: String, scope: SubtleCryptoScope) throws -> SubtleCrypto {
        return try getSubtleCryptoFrom(dict: self.symmetricEncrypters, name, scope)
    }
    
    /*
     * Sets the message signer object plugin given the encryption algorithm's name
     * @param name the name of the algorithm
     * @param cryptoSuiteMapItem array containing subtle crypto API's and their scope
     */
    func addMessageSigner(name: String, subtleCrypto: SubtleCryptoMapItem) {
        self.messageSigners = addOrCreateListFor(dict: self.messageSigners, name, subtleCrypto)
    }
    
    /*
     * Gets the message signer object given the signing algorithm's name
     * @param name the name of the algorithm
     * @return the corresponding crypto API
     */
    func getMessageSigner(name: String, scope: SubtleCryptoScope) throws -> SubtleCrypto {
        return try getSubtleCryptoFrom(dict: self.messageSigners, name, scope)
    }
    
    /*
     * Sets the mmac signer object plugin given the encryption algorithm's name
     * @param name the name of the algorithm
     * @param cryptoSuiteMapItem array containing subtle crypto API's and their scope
     */
    func addMessageAuthenticationCodeSigners(name: String, subtleCrypto: SubtleCryptoMapItem) {
        self.messageAuthenticationCodeSigners = addOrCreateListFor(dict: self.messageAuthenticationCodeSigners, name, subtleCrypto)
    }
    
    /*
     * Gets the mac signer object given the signing algorithm's name
     * @param name the name of the algorithm
     * @returns the corresponding crypto API
     */
    func getMessageAuthenticationCodeSigners(name: String, scope: SubtleCryptoScope) throws -> SubtleCrypto {
        return try getSubtleCryptoFrom(dict: self.messageAuthenticationCodeSigners, name, scope)
    }
    
    /*
     * Sets the message digest object given the digest algorithm's name
     * @params name the name of the algorithm
     * @param cryptoSuiteMapItem
     */
    func addMessageDigest(name: String, subtleCrypto: SubtleCryptoMapItem) {
        self.messageDigests = addOrCreateListFor(dict: self.messageDigests, name, subtleCrypto)
    }
    
    /*
     * Gets the message diget object given the digest algorithm's name
     * @param name the name of the algorithm
     * @returns the corresponding crypto API
     */
    func getMessageDigest(name: String, scope: SubtleCryptoScope) throws -> SubtleCrypto {
        return try getSubtleCryptoFrom(dict: self.messageDigests, name, scope)
    }
    
    private func addOrCreateListFor(dict: [String: [SubtleCryptoMapItem]], _ name: String, _ subtleCrypto: SubtleCryptoMapItem) -> [String: [SubtleCryptoMapItem]] {
        var mutableDict = dict
        if var list = dict[name] {
            list.append(subtleCrypto)
            mutableDict[name] = list
        } else {
            mutableDict[name] = [subtleCrypto]
        }
        return mutableDict
    }
    
    private func getSubtleCryptoFrom(dict: [String: [SubtleCryptoMapItem]], _ name: String, _ scope: SubtleCryptoScope) throws -> SubtleCrypto {
        if let list = dict[name] {
            do {
                return try findSubtleCryptoFor(list: list, scope: scope)
            } catch {
                // catch quietly
            }
        }
        return try findSubtleCryptoFor(list: dict[defaultAlgorithm]!, scope: scope)
        
    }
    
    private func findSubtleCryptoFor(list: [SubtleCryptoMapItem], scope: SubtleCryptoScope) throws -> SubtleCrypto {
        let exactScope = list.filter { $0.scope == scope }
        if let first = exactScope.first {
            return first.subtleCrypto
        } else if (scope != SubtleCryptoScope.All) {
            let closeEnoughScope = list.filter { $0.scope == SubtleCryptoScope.All }
            if let first = closeEnoughScope.first {
                return first.subtleCrypto
            }
        }
        throw SubtleCryptoError.Scoping
    }

}
