/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

enum Secp256k1SignerError: Error {
    case unableToCastPublicKeyToSecp256K1PublicKey
}

/// TODO: refactor class to be a generic signer.
public struct Secp256k1Signer: TokenSigning {
    
    private let hashAlgorithm: Sha256
    
    private let cryptoOperations: CryptoOperating
    
    public init(cryptoOperations: CryptoOperating = CryptoOperations(), andHashAlgorithm hashAlg: Sha256 = Sha256()) {
        self.cryptoOperations = cryptoOperations
        self.hashAlgorithm = hashAlg
    }

    public func sign<T>(token: JwsToken<T>, withSecret secret: VCCryptoSecret) throws -> Signature {
        
        let encodedMessage = token.protectedMessage

        guard let messageData = encodedMessage.data(using: .ascii) else {
            throw VCTokenError.unableToParseData
        }
        
        let hashedMessage = hashAlgorithm.hash(data: messageData)
        return try cryptoOperations.sign(messageHash: hashedMessage, usingSecret: secret)
    }
    
    public func getPublicJwk(from secret: VCCryptoSecret, withKeyId keyId: String) throws -> ECPublicJwk {
        let publicKey = try cryptoOperations.getPublicKey(fromSecret: secret)
        guard let key = publicKey as? Secp256k1PublicKey else {
            throw Secp256k1SignerError.unableToCastPublicKeyToSecp256K1PublicKey
        }
        return ECPublicJwk(withPublicKey: key, withKeyId: keyId)
    }
}
