/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct RequestedVerifiableCredentialMapping {
    public let type: String
    public let vc: VerifiableCredential
    
    public init(type: String, verifiableCredential: VerifiableCredential) {
        self.type = type
        self.vc = verifiableCredential
    }
}
