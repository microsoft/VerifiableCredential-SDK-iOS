//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Foundation

/// An object that represents a request from a Relying Party.
class AuthRequest {
    
    /// the raw request that formed request.
    /// TODO: do I need this or just the nonce/state
    let rawRequest: String?
    
    /// the Identifier for a Relying Party. If Request is decentralized, identifier will be a DID.
    let relyingPartyIdentifier: String
    
    /// An array of id token requests.
    let idTokenRequests: [ClaimRequest]?
    
    /// An array of verifiable credential requests.
    let verifiableCredentialRequests: [ClaimRequest]?
    
    /**
     Initializes an Auth Request object.
     */
    init(rawRequest: String?,
         relyingPartyIdentifier: String,
         idTokenRequests: [ClaimRequest]?,
         verifiableCredentialRequests: [ClaimRequest]?) {
        self.rawRequest = rawRequest
        self.relyingPartyIdentifier = relyingPartyIdentifier
        self.idTokenRequests = idTokenRequests
        self.verifiableCredentialRequests = verifiableCredentialRequests
    }
}
