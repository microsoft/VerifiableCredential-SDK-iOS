/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

/// Algorithm that hashes message and signs using Secp256k1
struct ES256k: Signing {
    
    /// Supported hashing algorithm for ES256k
    let hashAlgorithm: Sha256
    
    /// Supported curve for ES256k
    let curveAlgorithm: Secp256k1
    
    init(hashAlgorithm: Sha256 = Sha256(),
         curveAlgorithm: Secp256k1 = Secp256k1()) {
        self.hashAlgorithm = hashAlgorithm
        self.curveAlgorithm = curveAlgorithm
        
    }
    
    /// Hashes and signs a message
    /// - Parameters:
    ///   - message: 32 bytes message
    /// - Returns: The signature
    func sign(message: Data, withSecret secret: VCCryptoSecret) throws -> Data {
        let hashedMessage = hashAlgorithm.hash(data: message)
        return try curveAlgorithm.sign(messageHash: hashedMessage, withSecret: secret)
    }
    
    /// Validate a signature
    /// - Parameters:
    ///   - signature: The signature to validate
    ///   - messageHash: The message hash
    /// - Returns: True if the signature is valid
    func isValidSignature(signature: Data,
                          forMessage message: Data,
                          usingPublicKey publicKey: PublicKey) throws -> Bool {
        let hashedMessage = hashAlgorithm.hash(data: message)
        return try curveAlgorithm.isValidSignature(signature: signature, forMessageHash: hashedMessage, usingPublicKey: publicKey)
       
    }
    
    func createPublicKey(forSecret secret: VCCryptoSecret) throws -> PublicKey {
        return try curveAlgorithm.createPublicKey(forSecret: secret)
    }
}

