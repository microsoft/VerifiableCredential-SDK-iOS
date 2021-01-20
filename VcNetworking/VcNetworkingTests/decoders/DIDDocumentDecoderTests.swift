/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import VCEntities

@testable import VCNetworking

class DIDDocumentDecoderTests: XCTestCase {
    
    var expectedDocument: IdentifierDocument!
    var encodedDiscoveryServiceResponse: Data!
    let decoder = DIDDocumentDecoder()
    
    override func setUpWithError() throws {
        let publicKey = IdentifierDocumentPublicKeyV1(id: "idTest",
                                                      type: "typeTest",
                                                      controller: "controllerTest",
                                                      publicKeyJwk: nil,
                                                      purposes: [])
        expectedDocument = IdentifierDocument(service: ["serviceTest"],
                                              verificationMethod: [publicKey],
                                              authentication: ["authTest"])
        encodedDiscoveryServiceResponse = try JSONEncoder().encode(DiscoveryServiceResponse(didDocument: expectedDocument))
    }
    
    func testDecode() throws {
        let actualDocument = try decoder.decode(data: encodedDiscoveryServiceResponse)
        XCTAssertEqual(actualDocument, expectedDocument)
    }
}

