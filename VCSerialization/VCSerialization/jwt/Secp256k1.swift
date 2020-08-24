/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcCrypto

private let algorithm = Secp256k1()
private let hashAlgorithm = Sha512() // TODO Sha256

class Secp256k1Signer: TokenSigning {

    func sign<T>(token: JwsToken<T>, withSecret secret: VcCryptoSecret) throws -> Signature {
        let encodedMessage = try encodeMessage(token: token)
        
        guard let messageData = encodedMessage.data(using: .utf8) else {
            throw JwsEncoderError.unableToStringifyData
        }
        
        let hashedMessage = hashAlgorithm.hash(data: messageData)
        let signature = try algorithm.sign(messageHash: hashedMessage, withSecret: secret).base64EncodedData()
        
        return signature
    }
    
    private func encodeMessage<T>(token: JwsToken<T>) throws -> String {
        let encoder = JSONEncoder()
        let encodedHeader = try encoder.encode(token.headers).base64EncodedData()
        let encodedContent = try encoder.encode(token.content).base64EncodedData()
        
        guard let stringifiedHeader = String(data: encodedHeader, encoding: .utf8) else {
            throw JwsEncoderError.unableToStringifyData
        }
        
        guard let stringifiedContent = String(data: encodedContent, encoding: .utf8) else {
            throw JwsEncoderError.unableToStringifyData
        }
        return stringifiedHeader  + "." + stringifiedContent
    }
}

class Secp256k1Verifier: TokenVerifying {
    func verify<T>(token: JwsToken<T>, publicKeys: [Secp256k1PublicKey]) throws -> Bool {
        try algorithm.isValidSignature(signature: token.signature!, forMessageHash: token.signature!, usingPublicKey: publicKeys.first!)
    }
}

