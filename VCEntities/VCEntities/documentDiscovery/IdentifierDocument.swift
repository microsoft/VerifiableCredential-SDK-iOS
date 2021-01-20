/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct IdentifierDocument: Codable, Equatable {
    public let service: [String]
    public let verificationMethod: [IdentifierDocumentPublicKeyV1]
    public let authentication: [String]
    
    public init(service: [String], verificationMethod: [IdentifierDocumentPublicKeyV1], authentication: [String]) {
        self.service = service
        self.verificationMethod = verificationMethod
        self.authentication = authentication
    }
}
