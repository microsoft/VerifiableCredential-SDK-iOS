/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

enum TokenVerifierError: Error {
    case unsupportedAlgorithmFoundInJWK
    case malformedJWK
}

public struct TokenVerifier: TokenVerifying {
    
    private let cryptoOperations: CryptoOperating
    
    public init(cryptoOperations: CryptoOperating = CryptoOperations()) {
        self.cryptoOperations = cryptoOperations
    }
    
    public func verify<T>(token: JwsToken<T>, usingPublicKey key: JWK) throws -> Bool {
        
        guard let signature = token.signature else {
            return false
        }
        
        guard let encodedMessage = token.protectedMessage.data(using: .ascii) else {
            throw VCTokenError.unableToParseString
        }
        
        let hashedMessage = cryptoOperations.hash(message: encodedMessage, algorithm: .SHA256)
        
        return try cryptoOperations.verify(signature: signature, forMessageHash: hashedMessage, usingPublicKey: transformKey(key: key))
    }
    
    private func transformKey(key: JWK) throws -> PublicKey {
        switch key.curve?.uppercased() {
        case SupportedVerificationAlgorithm.Secp256k1.rawValue:
            return try transformSecp256k1(key: key)
        case SupportedVerificationAlgorithm.ED25519.rawValue:
            return try transformED25519(key: key)
        default:
            throw TokenVerifierError.unsupportedAlgorithmFoundInJWK
        }
        
    }
    
    private func transformSecp256k1(key: JWK) throws -> Secp256k1PublicKey {
        guard let x = key.x, let y = key.y,
              let encodedX = Data(base64URLEncoded: x),
              let encodedY = Data(base64URLEncoded: y),
              let secpKey = Secp256k1PublicKey(x: encodedX, y: encodedY) else {
            throw TokenVerifierError.malformedJWK
        }
        
        return secpKey
    }
    
    private func transformED25519(key: JWK) throws -> ED25519PublicKey {
        guard let x = key.x,
              let encodedX = Data(base64URLEncoded: x),
              let edKey = ED25519PublicKey(x: encodedX) else {
            throw TokenVerifierError.malformedJWK
        }
        
        return edKey
    }
}


