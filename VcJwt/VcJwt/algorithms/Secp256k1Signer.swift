/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcCrypto

public struct Secp256k1Signer: TokenSigning {
    
    private let algorithm: Signing
    private let hashAlgorithm: Sha256
    
    public init(using algorithm: Signing = Secp256k1(), andHashAlgorithm hashAlg: Sha256 = Sha256()) {
        self.algorithm = algorithm
        self.hashAlgorithm = hashAlg
    }

    public func sign<T>(token: JwsToken<T>, withSecret secret: VcCryptoSecret) throws -> Signature {
        
        let encodedMessage = try token.getProtectedMessage()

        guard let messageData = encodedMessage.data(using: .utf8) else {
            throw VcJwtError.unableToParseData
        }
        
        let hashedMessage = hashAlgorithm.hash(data: messageData)
        return try algorithm.sign(messageHash: hashedMessage, withSecret: secret)
    }
}
