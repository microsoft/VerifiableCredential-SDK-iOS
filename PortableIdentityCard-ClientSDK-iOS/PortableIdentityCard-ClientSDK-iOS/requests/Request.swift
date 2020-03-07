//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Foundation

/// An object that represents a request from a Relying Party.
protocol Request {
    
    /// the Identifier for a Relying Party. If Request is decentralized, identifier will be a DID.
    var relyingPartyIdentifier: String { get }
    
    func getClaimRequests()
    
    func getVerifiableCredentialRequests()
    
    func getIdTokenRequests()
    
}
