//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

/*
 * Class for W3C Crypto API constants
 */
enum W3cCryptoApiConstants: String, Codable {
    
    /*
     * Define W3C JWK constants
     */
    case Jwk = "jwk"
    
    /*
     * Define W3C Algorithm constants
     */
    case RsaOaep = "RSA-OAEP-256"
    case RsaSsaPkcs1V15 = "RSASSA-PKCS1-v1_5"
    case Sha1 = "SHA-1"
    
    /*
     * Non-standard
     */
    case Sha224 = "SHA-224"
    
    /*
     * Define W3C Algorithm constants
     */
    case Sha256 = "SHA-256"
    case Sha384 = "SHA-384"
    case Sha512 = "SHA-512"
    case EcDsa = "ECDSA"
    case EdDsa = "EDDSA"
    
    /*
     * @see https://www.w3.org/TR/WebCryptoAPI/#dfn-NamedCurve
     */
    case Secp256r1 = "P-256"
    case Secp384r1 = "P-384"
    case Secp521r1 = "P-521"
    case Secp256k1 = "P-256K"
    case Ed25519 = "ed25519"
    
    case AesCtr = "AES-CTR"
    case AesCbc = "AES-CBC"
    case AesGcm = "AES-KW"
    
    case Hmac = "HMAC"

}
