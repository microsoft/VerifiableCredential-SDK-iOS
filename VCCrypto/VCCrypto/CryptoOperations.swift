/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

enum CryptoOperationsError: Error {
    case invalidPublicKey
}

public struct CryptoOperations: CryptoOperating {
    
    public init() {}
    
    /// Only supports Secp256k1 signing.
    public func sign(messageHash: Data, usingSecret secret: VCCryptoSecret) throws -> Data  {
        let algorithm = try Secp256k1(secret: secret)
        return try algorithm.sign(messageHash: messageHash)
    }
    
    public func hash(message: Data, algorithm: SupportedHashAlgorithm) -> Data {
        switch algorithm {
        case .SHA256:
            return Sha256().hash(data: message)
        case .SHA512:
            return Sha512().hash(data: message)
        }
    }
    
    /// Only support Secp256k1 public key retrieval.
    public func getPublicKey(fromSecret secret: VCCryptoSecret) throws -> PublicKey {
        return try Secp256k1(secret: secret).getPublicKey()
    }
    
    public func verify(signature: Data,
                       forMessageHash messageHash: Data,
                       usingPublicKey publicKey: PublicKey) throws -> Bool {
        
        let algorithm = try getAlgorithm(publicKey: publicKey)
        return try algorithm.isValidSignature(signature: signature, forMessageHash: messageHash)
    }
    
    private func getAlgorithm(publicKey: PublicKey) throws -> any Signing {
        switch publicKey.algorithm {
        case .ED25519:
            return try ED25519(publicKey: publicKey)
        case .Secp256k1:
            return try Secp256k1(publicKey: publicKey)
        }
    }
}
