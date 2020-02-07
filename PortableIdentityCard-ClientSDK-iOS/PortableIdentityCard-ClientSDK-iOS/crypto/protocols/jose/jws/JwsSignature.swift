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
}
