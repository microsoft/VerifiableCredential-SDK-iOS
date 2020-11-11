/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

enum ExchangeRequestError: Error {
    case noAudienceFound
}

public struct ExchangeRequestContainer {
    
    public let exchangeableVerifiableCredential: VerifiableCredential
    
    public let newOwnerDid: String
    
    public let currentOwnerIdentifier: Identifier
    
    public let audience: String
    
    public init(exchangeableVerifiableCredential: VerifiableCredential,
                newOwnerDid: String,
                currentOwnerIdentifier: Identifier) throws {
        
        guard let requestAudience = exchangeableVerifiableCredential.token.content.vc.exchangeService?.id else {
            throw ExchangeRequestError.noAudienceFound
        }
        
        self.audience = requestAudience
        self.exchangeableVerifiableCredential = exchangeableVerifiableCredential
        self.newOwnerDid = newOwnerDid
        self.currentOwnerIdentifier = currentOwnerIdentifier
    }

}
