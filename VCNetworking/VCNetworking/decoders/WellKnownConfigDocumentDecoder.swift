/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VCEntities

public struct WellKnownConfigDocumentDecoder: Decoding {
    typealias Decodable = DomainLinkageCredential
    
    let decoder = JSONDecoder()
    
    public func decode(data: Data) throws -> DomainLinkageCredential {
        return try decoder.decode(DomainLinkageCredential.self, from: data)
    }
}
