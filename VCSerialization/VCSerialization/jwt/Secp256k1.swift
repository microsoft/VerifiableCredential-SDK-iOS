/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcCrypto

private let algorithm = Secp256k1()
private let hashAlgorithm = Sha512() // TODO Sha256

class Secp256k1Signer: TokenSigning {

    func sign<T>(token: JwsToken<T>, withSecret secret: VcCryptoSecret) throws -> Signature {
        
        let encodedMessage = try token.getProtectedMessage()
        guard let messageData = encodedMessage.data(using: .utf8) else {
            throw JwsEncoderError.unableToStringifyData
        }
        
        let hashedMessage = hashAlgorithm.hash(data: messageData)
        let signature = try algorithm.sign(messageHash: hashedMessage, withSecret: secret).base64EncodedData()
        
        return signature
    }
}

class Secp256k1Verifier: TokenVerifying {
    func verify<T>(token: JwsToken<T>, publicKeys: [Secp256k1PublicKey]) throws -> Bool {
        
        guard let signature = token.signature else {
            return false
        }
        
        let encodedMessage = try token.getProtectedMessage()
        guard let messageData = encodedMessage.data(using: .utf8) else {
            throw JwsEncoderError.unableToStringifyData
        }
        
        return try algorithm.isValidSignature(signature: signature, forMessageHash: messageData, usingPublicKey: publicKeys.first!)
    }
}

