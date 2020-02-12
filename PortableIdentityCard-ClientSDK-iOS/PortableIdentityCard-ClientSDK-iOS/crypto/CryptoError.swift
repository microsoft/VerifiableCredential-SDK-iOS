//
//  CryptoError.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/30/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

enum CryptoError: Error {

    case NoSHAAlgorithmWithLength(length: Int)
    case AlgorithmNotSupported(name: String)
    case UnknownKeyType(keyType: String)
    case UnknownKeyOperation(keyOperation: String)
    
    case NoAlgorithmSpecifiedForKey(keyName: String)
    case NoAlgorithmSpecifiedInSignature
    case InvalidSignature
    case CannotGenerateSymmetricKey
    case JsonWebKeyMalformed
    case NotImplemented
    case NoKeyFoundFor(keyName: String)
    case UnableToParseToken(token: String)
    case JWSContainsNoSignatures
    
    case JSONEncodingError
    case JSONDecodingError
}
