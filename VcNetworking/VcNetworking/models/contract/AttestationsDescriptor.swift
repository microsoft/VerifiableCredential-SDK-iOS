/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct AttestationsDescriptor: Codable, Equatable {
    public let selfIssued: SelfIssuedClaimsDescriptor?
    public let presentations: [PresentationDescriptor]?
    public let idTokens: [IdTokenDescriptor]?

}
