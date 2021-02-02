/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import VCEntities
import VCJwt

@testable import VCNetworking

class ContractDecoderTests: XCTestCase {
    
    var expectedContract: SignedContract!
    var encodedContract: Data!
    let decoder = ContractDecoder()
    
    override func setUpWithError() throws {
        let encodedContractData = TestData.contract.rawValue.data(using: .utf8)!
        let contract = try JSONDecoder().decode(Contract.self, from: encodedContractData)
        expectedContract = SignedContract(headers: Header(), content: contract)
        encodedContract = try JwsEncoder().encode(expectedContract).data(using: .ascii)
    }
    
    func testDecode() throws {
        let actualContract = try decoder.decode(data: encodedContract)
        XCTAssertEqual(actualContract.content, expectedContract.content)
    }
}
