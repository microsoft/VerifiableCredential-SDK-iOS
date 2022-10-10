/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

/// A protocol to support cryptopgraphic operations,
public protocol CryptoOperating {
    
    /// Sign a message hash using a specific secret, and return the signature.
    func sign(messageHash: Data, usingSecret secret: VCCryptoSecret) throws -> Data
    
    /// Hash a message using one of the supported hash algorithms.
    func hash(message: Data, algorithm: SupportedHashAlgorithm) -> Data
    
    /// Get a public key derived from the secret.
    func getPublicKey(fromSecret secret: VCCryptoSecret) throws -> PublicKey
    
    /// Verify a signature for a the message hash using a public key. and return true if valid signature, false if invalid.
    func verify(signature: Data, forMessageHash messageHash: Data, usingPublicKey publicKey: PublicKey) throws -> Bool
}
