/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

public struct DisplayDescriptor: Codable, Equatable {
    
    public let id: String = ""
    public let locale: String = ""
    public let contract: String = ""
    public let card: CardDisplayDescriptor = CardDisplayDescriptor()
    public let consent: ConsentDisplayDescriptor = ConsentDisplayDescriptor()
    public let claims: [String: ClaimDisplayDescriptor] = [:]
}
