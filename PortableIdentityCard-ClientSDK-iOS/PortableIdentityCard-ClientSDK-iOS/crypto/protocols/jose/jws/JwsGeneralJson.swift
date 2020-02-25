//
//  Copyright (C) Microsoft Corporation. All rights reserved.
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
