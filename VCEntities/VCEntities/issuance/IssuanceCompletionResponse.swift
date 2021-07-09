/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct IssuanceCompletionMessage {
    static let IssuanceSuccessful = "issuance_successful"
    static let IssuanceFailed = "issuance_failed"
}

/// The data object that the Client will send back after a successful issuance.
public struct IssuanceCompletionResponse: Codable, Equatable {
    
    /// If the issuance  succeeded or failed.
    public let message: String
    
    /// The state from the original request
    public let state: String
    
    /// Any details to be included in the response.
    public let details: String
    
}
