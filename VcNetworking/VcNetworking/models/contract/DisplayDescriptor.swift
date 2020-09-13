/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

struct DisplayDescriptor: Codable, Equatable {
    
    let id: String = ""
    let locale: String = ""
    let contract: String = ""
    let card: CardDisplayDescriptor = CardDisplayDescriptor()
    let consent: ConsentDisplayDescriptor = ConsentDisplayDescriptor()
    let claims: [String: ClaimDisplayDescriptor] = [:]
}
