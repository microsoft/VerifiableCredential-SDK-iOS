/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

enum CryptoOperationsError: Error {
    case invalidPublicKey
    case signingAlgorithmNotSupported
    case signingAlgorithmDoesNotSupportVerification
    case signingAlgorithmDoesNotSupportSigning
}

/// Operations that are involved in verification cryptographic operations..
public struct CryptoOperations: CryptoOperating {
    
    private let signingAlgorithms: [String: SigningAlgorithm]
    
    public init(signingAlgorithms: [String: SigningAlgorithm] = [:]) {
        var supportedAlgorithms = SupportedSigningAlgorithms().algorithms()
        
        /// merge injected algorithms with support algorithms.
        /// If merge conflict occurs, choose supported algorithm if all operations are supported,
        /// else choose injected algorithm if all operations are supported. Default to supported algorithm.
        supportedAlgorithms.merge(signingAlgorithms) { first, second in
            if first.supportedSigningOperations == .All {
                return first
            } else if second.supportedSigningOperations == .All {
                return second
            }
            
            return first
        }
        
        self.signingAlgorithms = supportedAlgorithms
    }
    
    /// Only supports Secp256k1 signing.
    public func sign(message: Data, usingSecret secret: VCCryptoSecret) throws -> Data {
        /// Temporary: TODO when we need to support other algorithm support, add extensibility.
        let algorithm = SupportedSigningAlgorithm.Secp256k1
        
        guard let signingAlgo = signingAlgorithms[algorithm.rawValue.uppercased()] else {
            throw CryptoOperationsError.signingAlgorithmNotSupported
        }
        
        guard signingAlgo.supportedSigningOperations == .All ||
                signingAlgo.supportedSigningOperations == .Signing else {
            throw CryptoOperationsError.signingAlgorithmDoesNotSupportVerification
        }
        
        return try signingAlgo.algorithm.sign(message: message, withSecret: secret)
    }
    
    /// Only support Secp256k1 public key retrieval.
    public func getPublicKey(fromSecret secret: VCCryptoSecret) throws -> PublicKey {
        return try Secp256k1().createPublicKey(forSecret: secret)
    }
    
    public func verify(signature: Data,
                       forMessage message: Data,
                       usingPublicKey publicKey: PublicKey) throws -> Bool {
        
        guard let signingAlgo = signingAlgorithms[publicKey.algorithm.rawValue.uppercased()] else {
            throw CryptoOperationsError.signingAlgorithmNotSupported
        }
        
        guard signingAlgo.supportedSigningOperations == .All ||
                signingAlgo.supportedSigningOperations == .Verification else {
            throw CryptoOperationsError.signingAlgorithmDoesNotSupportVerification
        }

        return try signingAlgo.algorithm.isValidSignature(signature: signature, forMessage: message, usingPublicKey: publicKey)
    }
}
