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
        
        guard let aud = presentationRequest.content.redirectURI,
            let did = presentationRequest.content.issuer else {
                throw PresentationResponseError.noAudienceSpecifiedInRequest
        }
        
        self.audienceDid = did
        self.audienceUrl = aud
        self.request = presentationRequest
        self.expiryInSeconds = exp
    }
}
