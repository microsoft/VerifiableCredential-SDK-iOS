/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VCEntities

public struct ContractDecoder: Decoding {
    typealias Decodable = SignedContract
    
    public func decode(data: Data) throws -> SignedContract {
        
        guard let token = SignedContract(from: data) else {
            throw DecodingError.unableToDecodeToken
        }
        
        return token
    }
}
