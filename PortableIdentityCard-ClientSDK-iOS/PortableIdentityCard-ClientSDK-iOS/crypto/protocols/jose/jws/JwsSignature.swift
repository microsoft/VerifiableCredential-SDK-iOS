//
//  JwsSignature.swift
//  PortableIdentityCard-ClientSDK-iOS
//
//  Created by Sydney Morton on 2/7/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

class JwsSignature: NSObject, Codable {
    
    /**
     The protected (signed) header.
     */
    let protected: String
    
    /**
     The unprotected (unverified) header.
     */
    let header: [String: String]?
    
    /**
     The JWS Signature
     */
    let signature: String
    
    init(protected: String, header: [String:String]?, signature: String) {
        self.protected = protected
        self.header = header
        self.signature = signature
    }
    
    /**
     Get key id from header or nil if does not exist
     */
    public func getKid() -> String? {
        return getMember(member: JoseConstants.Kid.rawValue)
    }
    
    /**
     Get algorithm name from header or nil if not exists
     */
    public func getAlgorithmName() -> String? {
        return getMember(member: JoseConstants.Alg.rawValue)
    }
    
    /**
     Get member from Signed Protected Header or Header if not found in protected header.
     
     - Parameters:
      - member key contained in protected header whose value want to retrieve
     
     - Returns:
      - the value mapped to the member in the protected headers or nil if there does not exist one.l
     */
    private func getMember(member: String) -> String? {
        if (!self.protected.isEmpty) {
            guard let jsonProtected = protected.fromBase64URL()?.data(using: .utf8) else {
                return nil
            }
            do {
                let mapObject = try JSONDecoder().decode(Dictionary<String, String>.self, from: jsonProtected)
                if let value = mapObject[member] {
                    return value
                }
            } catch {
                return nil
            }
        }
        if let headers = self.header {
            if let value = headers[member] {
                return value
            }
            return nil
        }
        return nil
    }
}
