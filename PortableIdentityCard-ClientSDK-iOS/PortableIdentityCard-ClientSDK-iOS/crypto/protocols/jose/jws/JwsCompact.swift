//
//  JwsCompact.swift
//  PortableIdentityCard-ClientSDK-iOS
//
//  Created by Sydney Morton on 2/7/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

/**
 JWS in compact form.
 */
struct JwsCompact: Codable {
    
    /**
     The application-specfic payload.
     */
    var payload: String
    
    /**
     The protected (signed) header.
     */
    var protected: String
    
    /**
     The JWS Signature.
     */
    var signature: String
}
