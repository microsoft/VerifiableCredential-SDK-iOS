/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCToken

public struct AttestationResponseDescriptor: Codable {
    public let idTokens: [String: String]?
    public let presentations: [String: String]?
    public let selfIssued: [String: String]?
    
    public init(idTokens: [String: String]? = nil,
                presentations: [String: String]? = nil,
                selfIssued: [String: String]? = nil) {
        self.idTokens = idTokens
        self.presentations = presentations
        self.selfIssued = selfIssued
    }
}
