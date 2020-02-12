//
//  KeyTypeFactory.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 2/4/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

/// Factory class to create @enum KeyType Objects
class KeyTypeFactory: NSObject {
    
    /**
       Create the key type according to the selected algorithm.
     
       - Parameters:
         - algorithm: Web Crypto compliant algorithm object
     */
    public static func createViaWebCrypto(algorithm: Algorithm) throws -> KeyType {
        switch algorithm.name.lowercased() {
        case "hmac":
            return KeyType.Octets
        case "ecdsa", "ecdh":
            return KeyType.EllipticCurve
        case "rsassa-pkcs1-v1_5", "rsa-oaep", "rsa-oaep-256":
            return KeyType.RSA
        default:
            throw CryptoError.AlgorithmNotSupported(name: algorithm.name)
        }
    }
    
    /**
       Create the key use according to the selected algorithm.
     
       - Parameters:
         - algorithm: JWA algorithm constant
     */
    public static func createViaJwa(algorithm: String) throws -> KeyType {
        let alg = try CryptoHelpers.jwaToWebCrypto(jwaAlgorithmName: algorithm)
        return try KeyTypeFactory.createViaJwa(algorithm: alg.name)
    }
    

}
