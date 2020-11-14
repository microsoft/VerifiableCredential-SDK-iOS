/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

enum PresentationResponseError: Error {
    case noAudienceSpecifiedInRequest
}

public struct PresentationResponseContainer: ResponseContaining {
    let request: PresentationRequest
    let expiryInSeconds: Int
    public let audienceUrl: String
    public let audienceDid: String
    public var requestedIdTokenMap: RequestedIdTokenMap = [:]
    public var requestedSelfAttestedClaimMap: RequestedSelfAttestedClaimMap = [:]
    public var requestVCMap: RequestedVerifiableCredentialMap = [:]
    
    public init(from presentationRequest: PresentationRequest, expiryInSeconds exp: Int = 3000) throws {
        
        self.audienceUrl = presentationRequest.content.redirectURI ?? ""
        self.audienceDid = presentationRequest.content.issuer ?? ""
        self.request = presentationRequest
        self.expiryInSeconds = exp
    }
}
