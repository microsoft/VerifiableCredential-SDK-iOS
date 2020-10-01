/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

enum PresentationResponseError: Error {
    case noAudienceSpecifiedInRequest
}

public struct PresentationResponseContainer {
    let request: PresentationRequest
    let expiryInSeconds: Int
    let audience: String
    public let requestedIdTokenMap: RequestedIdTokenMap = [:]
    public let requestedSelfAttestedClaimMap: RequestedSelfAttestedClaimMap = [:]
    public let requestVCMap: RequestedVerifiableCredentialMap = [:]
    
    public init(from request: PresentationRequest, expiryInSeconds exp: Int = 3000) throws {
        self.request = request
        self.expiryInSeconds = exp
        
        guard let aud = request.content.audience else {
            throw PresentationResponseError.noAudienceSpecifiedInRequest
        }
        
        self.audience = aud
    }
}
