//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class CryptoHelpers {
    
    /**
    Map the JWA algorithm to the W3C crypto API algorithm.
    The method restricts the supported algorithms. This can easily be extended.
    Based on https://www.w3.org/TR/WebCryptoAPI/#jwk-mapping
    
    - Parameters:
       - jwaAlgorithmName Requested algorithm
    
    - Returns:
       - W3C crypto API algorithm
    */
    public static func jwaToWebCrypto(jwaAlgorithmName: String, args: Any...) throws -> Algorithm {
        switch jwaAlgorithmName.uppercased() {
        case JoseConstants.Rs256.rawValue:
            return try formRsaAlgorithm(jwaAlgorithmName)
        case JoseConstants.Rs384.rawValue:
            return try formRsaAlgorithm(jwaAlgorithmName)
        case JoseConstants.Rs512.rawValue:
            return try formRsaAlgorithm(jwaAlgorithmName)
        case JoseConstants.RsaOaep.rawValue:
            return RsaOaepParams(hash: Sha.sha256)
        case JoseConstants.RsaOaep256.rawValue:
            return RsaOaepParams(hash: Sha.sha256)
        case JoseConstants.AesGcm128.rawValue:
            return try formAesGcmAlgorithm(jwaAlgorithmName, args)
        case JoseConstants.AesGcm192.rawValue:
            return try formAesGcmAlgorithm(jwaAlgorithmName, args)
        case JoseConstants.AesGcm256.rawValue:
            return try formAesGcmAlgorithm(jwaAlgorithmName, args)
        case JoseConstants.Es256K.rawValue:
            return EcdsaParams(hash: Sha.sha256, namedCurve: "P-256K", format: "DER")
        default:
            throw CryptoError.AlgorithmNotSupported(name: jwaAlgorithmName)
        }
    }
    
    private static func formRsaAlgorithm(_ algorithmName: String) throws -> RsaHashedImportParams {
        let strComponents = algorithmName.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let arrayOfComponents = strComponents.filter { $0 != "" }
        if let match = arrayOfComponents.first {
            return try RsaHashedImportParams(hash: Sha.getAlgorithm(length: Int(match)!))
        }
        throw CryptoError.AlgorithmNotSupported(name: algorithmName)
    }
    
    private static func formAesGcmAlgorithm(_ algorithmName: String, _ args: Any...) throws -> AesGcmParams {
        let iv = args[0] as! [UInt8]
        let aad = args[1] as! [UInt8]
        let strComponents = algorithmName.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let arrayOfComponents = strComponents.filter { $0 != "" }
        if let match = arrayOfComponents.first {
            let length = UInt16(match)!
            return AesGcmParams(iv: iv, additionalData: aad, tagLength: UInt8(128), length: length)
        }
        throw CryptoError.AlgorithmNotSupported(name: algorithmName)
    }
    
    
    public static func extractDidAndKeyId(keyId: String) throws -> (String?, String) {
        let components = keyId.split(separator: "#")
        if components.count == 0 {
            return (nil, keyId)
        } else if components.count == 1 {
            return (nil, String(components[0]))
        } else if components.count == 2 {
            return(String(components[0]), String(components[1]))
        } else {
            throw PortableIdentityCardError.IdentifierMalformed
        }
    }
}
