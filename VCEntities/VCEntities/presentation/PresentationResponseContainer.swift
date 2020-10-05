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
    public let audience: String
    public var requestedIdTokenMap: RequestedIdTokenMap = [:]
    public var requestedSelfAttestedClaimMap: RequestedSelfAttestedClaimMap = [:]
    public var requestVCMap: RequestedVerifiableCredentialMap = [:]
    
    public init(from presentationRequest: PresentationRequest, expiryInSeconds exp: Int = 3000) throws {
        
        self.audience = presentationRequest.content.redirectURI
        self.request = presentationRequest
        self.expiryInSeconds = exp
        
        print(request.content.redirectURI)
    }
}
