//
//  JoseConstants.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/30/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

/*
    Class for JOSE constants
 */
enum JoseConstants: String {
    
    // Define JOSE protocol name
    case Jose = "JOSE"
    
    // Define JWE protocol name
    case Jwe = "JWE"
    
    // Define JWS protocol name
    case Jws = "JWS"
    
    // Define JOSE algorithm constants
    case RsaOaep256 = "RSA-OAEP-256"
    case RsaOaep = "RSA-OAEP"
    case Rs256 = "RS256"
    case Rs384 = "RS384"
    case Rs512 = "RS512"
    case Es256K, DefaultSigningAlgorithm = "ES256K"
    case EcDsa = "ECDSA"
    case EdDsa = "EDDSA"
    case AesGcm128 = "128GCM"
    case AesGcm192 = "192GCM"
    case AesGcm256 = "256GCM"
    case Hs256 = "HS256"
    case Sha256 = "HA-256"
    case Hs512 = "HS512"
    
    // Define the JOSE protocol elements
    case Alg = "alg"
    case Kid = "kid"
    case Enc = "enc"
    
    // Define elements in the JWE Crypto Token
    case TokenProtected = "protected"
    case TokenUnprotected = "unprotected"
    case TokenAad = "aad"
    case TokenIv = "iv"
    case TokenCipherText = "ciphertext"
    
    
    // Define elements in the JWS Crypto Token
    case TokenTag = "tag"
    case TokenRecipients = "recipients"
    case TokenPayload = "payload"
    case TokenSignatures = "signatures"
    case TokenSignature = "signature"
    case TokenFormat = "format"
    
    
    // Define elements in the JOSE options
    case OptionProtectedHeader = "ProtectedHeader"
    case OptionHeader = "Header"
    case OptionKidPrefix = "KidPrefix"
    case OptionContentEncryptionAlgorithm = "ContentEncryptionAlgorithm"
    
    // Define JOSE serialization formats
    case SerializationJwsFlatJson = "JwsFlatJson"
    case SerializationJweFlatJson = "JweFlatJson"
    case SerializationJwsGeneralJson = "JwsGeneralJson"
    case SerializationJweGeneralJson = "JweGeneralJson"
    
    
}
