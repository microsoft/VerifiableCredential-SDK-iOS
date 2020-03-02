//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

/*
 * A type of operation that may be performed using a key.
 */
enum KeyUsage: String, Codable {
    
    case Encrypt = "encrypt"
    case Decrypt = "decrypt"
    case Sign = "sign"
    case Verify = "verify"
    case DeriveKey = "deriveKey"
    case DeriveBits = "deriveBits"
    case WrapKey = "wrapKey"
    case UnwrapKey = "unwrapKey"
}

func toKeyUsage(key_op: String) throws -> KeyUsage {
    switch key_op {
    case KeyUsage.Encrypt.rawValue:
        return KeyUsage.Encrypt
    case KeyUsage.Decrypt.rawValue:
        return KeyUsage.Decrypt
    case KeyUsage.Sign.rawValue:
        return KeyUsage.Sign
    case KeyUsage.Verify.rawValue:
        return KeyUsage.Verify
    case KeyUsage.DeriveBits.rawValue:
        return KeyUsage.DeriveBits
    case KeyUsage.DeriveKey.rawValue:
        return KeyUsage.DeriveKey
    case KeyUsage.WrapKey.rawValue:
        return KeyUsage.WrapKey
    case KeyUsage.UnwrapKey.rawValue:
        return KeyUsage.UnwrapKey
    default:
        throw CryptoError.UnknownKeyOperation(keyOperation: key_op)
        
    }
}
