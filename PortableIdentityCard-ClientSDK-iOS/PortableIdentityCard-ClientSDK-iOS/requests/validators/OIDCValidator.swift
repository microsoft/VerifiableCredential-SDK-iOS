//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Foundation

class OIDCValidator: Validator {
    
    let publicKeys: [String]
    
    /**
     Creates an OIDCValidator Object.
     TODO: flesh this out more. 
     
     - Parameters:
      - publicKeys: an array of public keys that can be used validate signatures.
     */
    init(publicKeys: [String]) {
        self.publicKeys = publicKeys
    }
    
    func validate(request: Request) throws -> Bool {
        throw PortableIdentityCardError.NotImplemented
    }
    
    
}
