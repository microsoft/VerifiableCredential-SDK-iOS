/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct IONDocumentInitialState: Codable {
    let suffixData: SuffixDescriptor
    let delta: IONDocumentDeltaDescriptorV1
}
