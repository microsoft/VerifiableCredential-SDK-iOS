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
class JwsToken: NSObject, Codable {
    
    private let payload: String
    
    public let signatures: Set<JwsSignature>
    
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
