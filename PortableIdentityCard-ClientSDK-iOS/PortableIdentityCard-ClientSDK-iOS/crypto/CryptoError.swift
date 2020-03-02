//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

/// TODO Split into specfic error classes
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
    
    case JSONEncodingError(withProperty: String)
    case JSONDecodingError(withProperty: String)
}
