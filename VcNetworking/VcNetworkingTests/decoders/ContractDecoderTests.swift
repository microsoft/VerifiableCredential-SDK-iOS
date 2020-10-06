/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import VCEntities

@testable import VCNetworking

class ContractDecoderTests: XCTestCase {
    
    var expectedContract: Contract!
    var encodedContract: Data!
    let decoder = ContractDecoder()
    
    override func setUpWithError() throws {
        encodedContract = TestData.contract.rawValue.data(using: .utf8)!
        expectedContract = try JSONDecoder().decode(Contract.self, from: encodedContract)
    }
    
    func testDecode() throws {
        let actualContract = try decoder.decode(data: encodedContract)
        XCTAssertEqual(actualContract, expectedContract)
    }
}
