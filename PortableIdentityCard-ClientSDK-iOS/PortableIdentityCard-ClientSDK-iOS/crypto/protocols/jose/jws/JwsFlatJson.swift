//
//  Copyright (C) Microsoft Corporation. All rights reserved.
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
