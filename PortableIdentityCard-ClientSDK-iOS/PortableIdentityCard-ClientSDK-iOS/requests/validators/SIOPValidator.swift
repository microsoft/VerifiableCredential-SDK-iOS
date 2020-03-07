//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Foundation

class SIOPValidator: Validator {
    
    let identifier: String
    
    /**
     Creates an SIOPValidator Object.
     TODO: flesh this out more.
     
     - Parameters:
      - identifier: the decentralized identifier that can be used to discover DID Document.
     */
    init(identifier: String) {
        self.identifier = identifier
    }
    
    func validate(request: Request) throws -> Bool {
        throw PortableIdentityCardError.NotImplemented
    }
    
    
}
