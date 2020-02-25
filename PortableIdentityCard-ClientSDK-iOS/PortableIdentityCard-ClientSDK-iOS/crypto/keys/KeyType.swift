//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

/// Key Type Enum for keys we support
enum KeyType: String, Codable {
    case EllipticCurve = "EC"
    case Octets = "oct"
    case RSA = "RSA"
}

/**
   Maps String to Key Type.
 
   - Parameters:
     - keyType: String representation of KeyType
 
   - Returns: Key Type
 */
func toKeyType(keyType kty: String) throws -> KeyType {
    switch kty {
        case KeyType.EllipticCurve.rawValue:
            return KeyType.EllipticCurve
        case KeyType.RSA.rawValue:
            return KeyType.RSA
        case KeyType.Octets.rawValue:
            return KeyType.Octets
        default:
            throw CryptoError.UnknownKeyType(keyType: kty)
    }
}
