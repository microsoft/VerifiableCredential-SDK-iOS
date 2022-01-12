/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct SubmissionDescriptor: Codable {
    
    public let id: String
    
    public let path: String
    
    public let format: String
    
    public let encoding: String
}
