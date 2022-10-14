/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

enum CryptoOperationsError: Error {
    case invalidPublicKey
}

/// Operations that are involved in verification cryptographic operations..
public struct CryptoOperations: CryptoOperating {
    
    public init() {}
    
    /// Only supports Secp256k1 signing.
    public func sign(message: Data, usingSecret secret: VCCryptoSecret) throws -> Data  {
        let algorithm = ES256k()
        return try algorithm.sign(message: message, withSecret: secret)
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
        return try Secp256k1().createPublicKey(forSecret: secret)
    }
    
    public func verify(signature: Data,
                       forMessage message: Data,
                       usingPublicKey publicKey: PublicKey) throws -> Bool {
        
        let algorithm = try getAlgorithm(publicKey: publicKey)
        return try algorithm.isValidSignature(signature: signature, forMessage: message, usingPublicKey: publicKey)
    }
    
    private func getAlgorithm(publicKey: PublicKey) throws -> Signing {
        switch publicKey.algorithm {
        case .ED25519:
            return EdDSA()
        case .Secp256k1:
            return ES256k()
        }
    }
}
