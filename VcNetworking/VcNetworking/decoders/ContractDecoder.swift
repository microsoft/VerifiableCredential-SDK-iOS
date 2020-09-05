/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

struct ContractDecoder: Decoding {
    public typealias T = MockContract
    
    let decoder = JSONDecoder()
    
    func decode(data: Data) throws -> MockContract {
        return try decoder.decode(MockContract.self, from: data)
    }
}
