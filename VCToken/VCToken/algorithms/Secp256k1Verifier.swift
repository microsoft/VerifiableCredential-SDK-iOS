/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

public struct Secp256k1Verifier: TokenVerifying {
    
    private let algorithm: Signing
    private let hashAlgorithm: Sha256
    
    public init(using algorithm: Signing = Secp256k1(), andHashAlgorithm hashAlg: Sha256 = Sha256()) {
        self.algorithm = algorithm
        self.hashAlgorithm = hashAlg
    }
    
    public func verify<T>(token: JwsToken<T>, usingPublicKey key: ECPublicJwk) throws -> Bool {
        
        guard token.headers.algorithm == "ES256K" else {
            throw JwsTokenError.unsupportedAlgorithm(name: token.headers.algorithm)
        }
        
        guard let signature = token.signature else {
            return false
        }
        
        guard let encodedMessage = token.protectedMessage.data(using: .ascii) else {
            throw VCTokenError.unableToParseString
        }
        
        guard let x = Data(base64URLEncoded: key.x),
              let y = Data(base64URLEncoded: key.y),
              let secpKey = Secp256k1PublicKey(x: x, y: y) else {
            throw VCTokenError.unableToParseString
        }
        
        let hashedMessage = self.hashAlgorithm.hash(data: encodedMessage)
        
        return try algorithm.isValidSignature(signature: signature, forMessageHash: hashedMessage, usingPublicKey: secpKey)
    }
}


