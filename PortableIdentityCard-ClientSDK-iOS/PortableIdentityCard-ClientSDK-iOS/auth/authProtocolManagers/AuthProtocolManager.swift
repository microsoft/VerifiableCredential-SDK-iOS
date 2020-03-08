//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Foundation

/// Static class that manages operations dealing with Auth Protocols such as OIDC or SIOP.
protocol AuthProtocolManager {
    
    /**
     Validates raw request based on rules in the validator, and forms Request from claims in Raw Request.
     TODO: Create an overloaded method that takes in JWT instead of String for raw request.
     
     - Parameters:
      - rawRequest: raw request that will be used to create request.
      - validator: validator used to validate that raw request conforms to specific auth protocol.
     
     - Throws: if cannot create request from raw request or if request is not validate.
     
     - Returns: request that was created and validated.
     
     */
    func validateAndFormRequest(fromRawRequest rawRequest: String, withValidator validator: Validator) throws -> AuthRequest
    
    /**
     Validates raw request based on rules in the validator.
     
     - Parameters:
      - rawRequest: raw request that will be used to create request.
      - validator: validator used to validate that raw request conforms to specific auth protocol.
     
     - Throws: if cannot create request from raw request.
     
     - Returns: true, if raw request is valid.
     
     */
    func validateRequest(fromRawRequest: String, withValidator: Validator) throws -> Bool
    
    
    /**
     Create response from the request.
     
     - Parameters:
      - request: request that the response is responding to. Request contains pass-through claims that response might need (i.e. nonce, state).
     
     - Returns: Request object that was created.
     */
    func createResponse(fromRequest request: AuthRequest) throws -> AuthResponse
    
    /**
     Create generic response.
     
     - Returns: Request object that was created.
     */
    func createResponse() throws -> AuthResponse
    
    /**
     Protect the response using protector parameter and return protected string.
     */
    func protectResponse(withProtector protector: Protector, response: AuthResponse) throws -> String
    
    /**
     Send the response to the provided url.
     */
    func sendProtectedResponse(toUrl url: String, protectedResponse: String) throws -> Any
    
    
}
