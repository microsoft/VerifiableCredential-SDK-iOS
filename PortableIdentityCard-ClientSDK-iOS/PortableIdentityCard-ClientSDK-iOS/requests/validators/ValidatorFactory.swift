//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Foundation

/// Factory class to create correct validator based on request object.
class ValidatorFactory {
   
    /**
     Make correct Validator based on request.
     TODO: decide on input (scopes, jwt, Request?).
     1. checks scopes to see if OIDC token or SIOP token or other as comes along.
     2. initializes and returns correct validator.
     
     - Parameters:
      - token: token that will be validated.
     
     - Returns: validator for specific request.
     */
    static func makeValidator(token: String) throws -> Validator {
        throw PortableIdentityCardError.NotImplemented
    }
    
}
