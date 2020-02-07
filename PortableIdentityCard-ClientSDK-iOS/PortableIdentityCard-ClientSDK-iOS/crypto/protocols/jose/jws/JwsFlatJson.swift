//
//  JwsFlatJson.swift
//  PortableIdentityCard-ClientSDK-iOS
//
//  Created by Sydney Morton on 2/7/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

struct JwsFlatJson: Codable {
    
    /**
     The application-specfic payload.
     */
    let payload: String
    
    /**
     The protected (signed) header.
     */
    let protected: String
    
    /**
     The unprotected (unverified) header.
     */
    let header: [String: String]?
    
    /**
     The JWS Signature.
     */
    let signature: String

}
