//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Foundation

/// Static class that manages request objects.
class RequestManager {
    
    /**
     Creates a request object and validates it based on rules in the validator.
     TODO: Create an overloaded method that takes in JWT instead of String for raw request.
     
     - Parameters:
      - rawRequest: raw request that will be used to create request.
     
     - Throws: if cannot create request from raw request.
     
     - Returns: Request that was created and validated.
     
     */
    static func createRequest(rawRequest: String) throws -> Request {
        throw PortableIdentityCardError.NotImplemented
    }
    
    /**
     Creates a request object and validates it based on rules in the validator.
     
     - Parameters:
      - rawRequest: raw request that will be used to create request.
      - validator: validator that will be used to validate created request.
     
     - Throws: if cannot create request from raw request or if not a valid request.
     
     - Returns: Request that was created and validated.
     
     */
    static func validateAndCreateRequest(rawRequest: String, validator: Validator) throws -> Request {
        throw PortableIdentityCardError.NotImplemented
    }
}
