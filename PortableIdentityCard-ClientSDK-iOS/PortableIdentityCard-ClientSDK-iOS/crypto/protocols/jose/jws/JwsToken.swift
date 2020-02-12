//
//  JwsToken.swift
//  PortableIdentityCard-ClientSDK-iOS
//
//  Created by Sydney Morton on 2/7/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

/**
 Class for containing JWS token operations
 */
class JwsToken: NSObject {
    
    private let payload: String
    
    public var signatures: Set<JwsSignature>
    
    init(payload: String, signatures: Set<JwsSignature>=[]) {
        self.payload = payload
        self.signatures = signatures
    }
    
    init(content: [UInt8]) {
        let stringifiedContent = String(bytes: content, encoding: .utf8)
        let base64UrlEncodedContent = stringifiedContent?.toBase64URL()
        self.payload = base64UrlEncodedContent!
        self.signatures = []
    }
    
    init(content: String) {
        let base64UrlEncodedContent = content.toBase64URL()
        self.payload = base64UrlEncodedContent
        self.signatures = []
    }
    
    /**
     Serialize a JWS token object from token.
     
     - Parameters:
       - format Format that token will be serialized into (default is Compact form)
     
     - Returns:
      - serialized JWS token as a string
     */
    public func serialize(format: JwsFormat = JwsFormat.Compact) throws -> String {
        guard let signature = self.signatures.first else {
            throw CryptoError.JWSContainsNoSignatures
        }
        switch format {
        case .Compact:
            let compactToken = self.formCompactToken(signature: signature)
            return "\(compactToken.protected).\(compactToken.payload).\(compactToken.signature)"
        case .FlatJson:
            let flatToken = self.formFlatJsonToken(signature: signature)
            let encodedToken = try JSONEncoder().encode(flatToken)
            return String(data: encodedToken, encoding: .utf8)!
        case .GeneralJson:
            let generalToken = self.formGeneralJsonToken()
            let encodedToken = try JSONEncoder().encode(generalToken)
            return String(data: encodedToken, encoding: .utf8)!
        }
    }
    
    private func formCompactToken(signature: JwsSignature) -> JwsCompact {
        return JwsCompact(
            payload: self.payload,
            protected: signature.protected,
            signature: signature.signature)
    }
    
    private func formFlatJsonToken(signature: JwsSignature) -> JwsFlatJson {
        return JwsFlatJson(
            payload: self.payload,
            protected: signature.protected,
            header: signature.header,
            signature: signature.signature)
    }
    
    private func formGeneralJsonToken() -> JwsGeneralJson {
        return JwsGeneralJson(
            payload: self.payload,
            signatures: self.signatures)
    }
    
    /**
     Deserializes a string that was either in:
       1. compact form
       2. stringified general json form
       3. stringified flat json form
       into a JWSToken.
     
     - Parameters:
      - jws: signed token in some form
     
     - Returns:
      - JWSToken
     */
    public static func deserialize(jws: String) throws -> JwsToken {
        let jwsPieces = jws.split(separator: ".")
        if (jwsPieces.count == 3) {
            print("compact form detected")
            let protected = jwsPieces[0]
            let payload = jwsPieces[1]
            let signature = jwsPieces[2]
            let jwsSignatureObject = JwsSignature(protected: String(protected), header: nil, signature: String(signature))
            return JwsToken(payload: String(payload), signatures: [jwsSignatureObject])
        } else if jws.lowercased().contains("\"signatures\"") {
            print("general form detected")
            let dataToken = jws.data(using: .utf8)
            if let data = dataToken {
                let token = try JSONDecoder().decode(JwsGeneralJson.self, from: data)
                return JwsToken(payload: token.payload, signatures: token.signatures)
            } else {
                throw CryptoError.UnableToParseToken(token: jws)
            }
        } else if jws.lowercased().contains("\"signature\"") {
            print("flat form detected")
            let dataToken = jws.data(using: .utf8)
            if let data = dataToken {
                let token = try JSONDecoder().decode(JwsFlatJson.self, from: data)
                let signature = JwsSignature(protected: token.protected, header: token.header, signature: token.signature)
                return JwsToken(payload: token.payload, signatures: [signature])
            } else {
                throw CryptoError.UnableToParseToken(token: jws)
            }
        } else {
            throw CryptoError.UnableToParseToken(token: jws)
        }
    }
    
    /**
     Adds a signature using the given key
     
     - Parameters:
      - signatureKeyReference reference to signing key
      - cryptoOperations CryptoOperations used to form the signatures
      - header optional headers added to the signature
     */
    public func sign(signatureKeyReference: String, cryptoOperations: CryptoOperations, header: [String: String] = [:]) throws {
        
        /// 1. get signing key from keyStore
        let signingKey: PrivateKey
        guard let privateKey = (try cryptoOperations.keyStore.getPrivateKey(keyReference: signatureKeyReference).getKey()) else {
            throw CryptoError.NoKeyFoundFor(keyName: signatureKeyReference)
        }
        signingKey = privateKey as! PrivateKey
        
        /// 2. compute headers
        // var headers: [String: String] = header
        var protected: [String: String] = [:]
        var algorithmName = ""
        
        /// 3. get algorithmName from headers or signing key
        if let algorithm = header[JoseConstants.Alg.rawValue] {
            algorithmName = algorithm
            protected[JoseConstants.Alg.rawValue] = algorithmName
        } else {
            if let algorithm = signingKey.alg {
                algorithmName = algorithm
                protected[JoseConstants.Alg.rawValue] = algorithmName
            } else {
                throw CryptoError.NoAlgorithmSpecifiedForKey(keyName: signatureKeyReference)
            }
        }
        
        if (header[JoseConstants.Kid.rawValue] == nil) {
            protected[JoseConstants.Kid.rawValue] = signingKey.kid
        }
        
        var encodedProtected = ""
        if (!protected.isEmpty) {
            let dataProtected = try JSONEncoder().encode(protected)
            let stringifiedProtectedOptional = String(data: dataProtected, encoding: .utf8)
            guard let stringifiedProtected = stringifiedProtectedOptional else {
                throw CryptoError.JSONEncodingError
            }
            encodedProtected = stringifiedProtected.toBase64URL()
        }
        
        let signatureInput = "\(encodedProtected).\(self.payload)"
        let signatureInputByteArray = [UInt8](signatureInput.utf8)
        
        let signature = try cryptoOperations.sign(payload: signatureInputByteArray, signingKeyReference: signatureKeyReference, algorithm: CryptoHelpers.jwaToWebCrypto(jwaAlgorithmName: algorithmName))
        
        let signatureBase64 = String(bytes: signature, encoding: .utf8)!.toBase64URL()
        
        self.signatures.insert(JwsSignature(protected: encodedProtected, header: header, signature: signatureBase64))
    }
    
    
    public func verify(cryptoOperations: CryptoOperations, publicKeys: [PublicKey] = [], all: Bool = false) throws -> Bool {
        let results = try self.signatures.map {
            try verifyJwsSignature(signature: $0, cryptoOperations: cryptoOperations)
        }
        
        if all {
            return results.reduce(true, { result, valid in
                result && valid
            })
        } else {
            return results.reduce(false, { result, valid in
                result || valid
            })
        }
    }
    
    private func verifyJwsSignature(signature: JwsSignature, cryptoOperations: CryptoOperations, publicKeys: [PublicKey] = []) throws -> Bool {
        // get KeyId from headers if present
        let fullyQuantifiedKid: String
        if let kid = signature.getKid() {
            fullyQuantifiedKid = kid
        } else {
            fullyQuantifiedKid = ""
        }
        
        let keyId = try CryptoHelpers.extractDidAndKeyId(keyId: fullyQuantifiedKid)
        
        let signatureInput = "\(signature.protected).\(self.payload)"
        let publicKeyOptional = try cryptoOperations.keyStore.getPublicKeyById(keyId: keyId.1)
        if let publicKey = publicKeyOptional {
            return try verifyWithKey(crypto: cryptoOperations, data: signatureInput, signature: signature, key: publicKey)
        } else {
            let publicKey = publicKeys.first { $0.kid.hasSuffix(keyId.1) }
            if let key = publicKey {
                /// key attempted with keyId
                return try verifyWithKey(crypto: cryptoOperations, data: signatureInput, signature: signature, key: key)
            } else if !publicKeys.isEmpty {
                /// first key attempted
                return try verifyWithKey(crypto: cryptoOperations, data: signatureInput, signature: signature, key: publicKeys.first!)
            } else {
                /// no keys attempted
                return false
            }
        }
    }
    
    private func verifyWithKey(crypto: CryptoOperations, data: String, signature: JwsSignature, key: PublicKey) throws -> Bool {
        guard let algorithmName = signature.getAlgorithmName() else {
            throw CryptoError.NoAlgorithmSpecifiedInSignature
        }
        let subtleAlgorithm = try CryptoHelpers.jwaToWebCrypto(jwaAlgorithmName: algorithmName)
        let subtle = try crypto.subtleCryptoFactory.getMessageSigner(name: subtleAlgorithm.name, scope: SubtleCryptoScope.Public)
        let keyOps: Set<KeyUsage>
        if let ops = key.key_ops {
            keyOps = ops
        } else {
            keyOps = [KeyUsage.Verify]
        }
        let cryptoKey = try subtle.importKey(format: KeyFormat.Jwk, keyData: key.toJwk(), algorithm: subtleAlgorithm, extractable: true, keyUsages: keyOps)
        let rawSignature = [UInt8](signature.signature.fromBase64URL()!.utf8)
        let rawData = [UInt8](data.utf8)
        return try subtle.verify(algorithm: subtleAlgorithm, key: cryptoKey, signature: rawSignature, data: rawData)
    }
}

extension String {
    
    func fromBase64URL() -> String? {
        var base64 = self
        base64 = base64.replacingOccurrences(of: "-", with: "+")
        base64 = base64.replacingOccurrences(of: "_", with: "/")
        while base64.count % 4 != 0 {
            base64 = base64.appending("=")
        }
        guard let data = Data(base64Encoded: base64) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64URL() -> String {
        var result = Data(self.utf8).base64EncodedString()
        result = result.replacingOccurrences(of: "+", with: "-")
        result = result.replacingOccurrences(of: "/", with: "_")
        result = result.replacingOccurrences(of: "=", with: "")
        return result
    }
}
