/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcCrypto

struct Secp256k1Verifier: TokenVerifying {
    
    private let algorithm: Signing
    private let hashAlgorithm: Sha256
    
    init?(using algorithm: Signing = Secp256k1(), andHashAlgorithm hashAlg: Sha256 = Sha256()) {
        self.algorithm = algorithm
        self.hashAlgorithm = hashAlg
    }
    
    func verify<T>(token: JwsToken<T>, usingPublicKey key: Secp256k1PublicKey) throws -> Bool {
        
        guard let signature = token.signature else {
            return false
        }
        
        guard let encodedMessage = try token.getProtectedMessage().data(using: .utf8) else {
            throw VcJwtError.unableToParseString
        }
        
        let hashedMessage = self.hashAlgorithm.hash(data: encodedMessage)
        return try algorithm.isValidSignature(signature: signature, forMessageHash: hashedMessage, usingPublicKey: key)
    }
}


