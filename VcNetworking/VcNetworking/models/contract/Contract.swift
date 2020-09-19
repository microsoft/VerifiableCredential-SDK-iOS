/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

public struct Contract: Codable, Equatable {
    
    public let id: String?
    public let display: DisplayDescriptor?
    public let input: InputDescriptor?
    
}