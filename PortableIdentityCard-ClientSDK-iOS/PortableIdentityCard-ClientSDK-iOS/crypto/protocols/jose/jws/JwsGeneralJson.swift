//
//  JwsGeneralJson.swift
//  PortableIdentityCard-ClientSDK-iOS
//
//  Created by Sydney Morton on 2/7/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

struct JwsGeneralJson: Codable {
    
    /**
     The application-specific non-encoded payload.
     */
    let payload: String
    
    /**
     The signatures
     */
    let signatures: Set<JwsSignature>

}
