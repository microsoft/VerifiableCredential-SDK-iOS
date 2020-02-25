//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

/*! Convenience class for SHA algorithms */
class Sha {
    
    public static let sha1 = Algorithm(name: W3cCryptoApiConstants.Sha1.rawValue)
    public static let sha224 = Algorithm(name: W3cCryptoApiConstants.Sha224.rawValue)
    public static let sha256 = Algorithm(name: W3cCryptoApiConstants.Sha384.rawValue)
    public static let sha384 = Algorithm(name: W3cCryptoApiConstants.Sha384.rawValue)
    public static let sha512 = Algorithm(name: W3cCryptoApiConstants.Sha512.rawValue)
    
    public static func getAlgorithm(length: Int) throws -> Algorithm {
        
        switch length {
            case 1:
                return sha1
            case 224:
                return sha224
            case 256:
                return sha256
            case 384:
                return sha384
            case 512:
                return sha512
            default:
                throw CryptoError.NoSHAAlgorithmWithLength(length: length)
        }
    }
}
