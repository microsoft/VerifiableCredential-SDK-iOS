//
//  Copyright (C) Microsoft Corporation. All rights reserved.
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
