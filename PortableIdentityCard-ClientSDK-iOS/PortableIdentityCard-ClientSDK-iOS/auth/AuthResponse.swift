//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Foundation

/// Auth Response Class that contains response details and collects claims
class AuthResponse {
    
    /// request object that response is responding to, or nil if no request.
    let request: AuthRequest?
    
    /// an array of idTokens to send back with response.
    var idTokens: [IdToken] = []
    
    /// an array of verifiable credentials to send back with response.
    var verifiableCredentials: [VerifiableCredential] = []
    
    /**
     Initialized a response object from a request object, or forms a generic response object if request is nil
     
     - Parameters:
      - request: request object response to responding to.
     */
    init(request: AuthRequest?) {
        self.request = request
    }
    
    /**
     Add claim to response object.
     
     - Parameters:
      - claim: Claim object to be added to response.
     */
    func addClaim(claim: Claim) throws {
        
        if let idToken = claim as? IdToken
        {
            self.idTokens.append(idToken)
        }
        else if let verifiableCredential = claim as? VerifiableCredential
        {
            self.verifiableCredentials.append(verifiableCredential)
        }
        else
        {
            throw AuthResponseError.ClaimTypeNotSupported
        }
    }
}

/// Auth Response Errors.
enum AuthResponseError: Error {
    case ClaimTypeNotSupported
}
