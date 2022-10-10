/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

public struct TokenVerifier: TokenVerifying {
    
    private let cryptoOperations: CryptoOperating
    private let hashAlgorithm: Sha256 = Sha256()
    
    public init(cryptoOperations: CryptoOperating = CryptoOperations()) {
        self.cryptoOperations = cryptoOperations
    }
    
    public func verify<T>(token: JwsToken<T>, usingPublicKey key: any PublicJwk) throws -> Bool {
        
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
        
        return try cryptoOperations.verify(signature: signature, forMessageHash: hashedMessage, usingPublicKey: secpKey)
    }
}


