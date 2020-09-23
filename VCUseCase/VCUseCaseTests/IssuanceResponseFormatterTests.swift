/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import VCRepository
import VcNetworking
import VcJwt

@testable import VCUseCase

class IssuanceResponseFormatterTests: XCTestCase {
    
    var formatter: IssuanceResponseFormatter!
    var contract: Contract!
    var mockResponse: IssuanceResponse!
    var mockIdentifier: MockIdentifier!
    let expectedContractUrl = "https://portableidentitycards.azure-api.net/v1.0/9c59be8b-bd18-45d9-b9d9-082bc07c094f/portableIdentities/contracts/AIEngineerCert"

    override func setUpWithError() throws {
        let signer = MockTokenSigner(x: "x", y: "y")
        self.formatter = IssuanceResponseFormatter(signer: signer)
        
        let encodedContract = TestData.aiContract.rawValue.data(using: .utf8)!
        self.contract = try JSONDecoder().decode(Contract.self, from: encodedContract)
        
        try self.mockResponse = IssuanceResponse(from: self.contract, contractUri: self.expectedContractUrl)
        
        self.mockIdentifier = MockIdentifier()
    }

    func testFormatToken() throws {
        let expec = self.expectation(description: "Fire")
        formatter.format(response: self.mockResponse, usingIdentifier: self.mockIdentifier).done {
            formattedToken in
            XCTAssertEqual(formattedToken.content.did, self.mockIdentifier.id)
            XCTAssertEqual(formattedToken.content.contract, self.mockResponse.contractUri)
            XCTAssertEqual(formattedToken.content.audience, self.mockResponse.audience)
            XCTAssert(MockTokenSigner.wasSignCalled)
            XCTAssert(MockTokenSigner.wasGetPublicJwkCalled)
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTFail()
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }

}
