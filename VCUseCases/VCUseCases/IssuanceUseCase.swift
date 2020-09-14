/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/


import Foundation
import PromiseKit
import VCRepository
import VcNetworking
import VcJwt

class IssuanceUseCase {
    
    let repo = IssuanceRepository()
    let signer = Secp256k1Signer()
    let verifier = Secp256k1Verifier()
    
    func getRequest(usingUrl url: String) -> Promise<Contract> {
        return self.repo.getRequest(withUrl: url)
    }
    
    func sendResponse(token: inout JwsToken<IssuanceResponseClaims>, usingUrl url: String) throws -> Promise<VerifiableCredential> {
        // create Issuance Response Claims with everything needed and wrap in JWS token
        // sign that token with key related to DID that wants to use
        // send response and get VerifiableCredential back... return with Contract?
        let keyId = KeyId(id: UUID())
        try token.sign(using: signer, withSecret: keyId)
        return self.repo.sendResponse(withUrl: url, withBody: token)
    }
    
}
