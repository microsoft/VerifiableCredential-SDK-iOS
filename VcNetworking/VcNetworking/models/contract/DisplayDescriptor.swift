/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

struct DisplayDescriptor: Codable {
    let id, locale: String
    let contract: String
    let card: CardDisplayDescriptor
    let consent: ConsentDisplayDescriptor
    let claims: [String: ClaimDisplayDescriptor]
}
