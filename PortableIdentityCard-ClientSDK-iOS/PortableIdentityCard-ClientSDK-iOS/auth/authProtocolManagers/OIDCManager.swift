//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Foundation

/// Manager that handles OIDC requests and responses.
class OIDCManager : AuthProtocolManager {

    func validateAndFormRequest(fromRawRequest rawRequest: String, withValidator validator: Validator) throws -> AuthRequest {
        throw PortableIdentityError.NotImplemented
    }
    
    func validateRequest(fromRawRequest: String, withValidator: Validator) throws -> Bool {
        throw PortableIdentityError.NotImplemented
    }
    
    func createResponse(fromRequest request: AuthRequest) throws -> AuthResponse {
        throw PortableIdentityError.NotImplemented
    }
    
    func createResponse() throws -> AuthResponse {
        throw PortableIdentityError.NotImplemented
    }
    
    func protectResponse(withProtector protector: Protector, response: AuthResponse) throws -> String {
        throw PortableIdentityError.NotImplemented
    }
    
    func sendProtectedResponse(toUrl url: String, protectedResponse: String) throws -> Any {
        throw PortableIdentityError.NotImplemented
    }
    
    
}
