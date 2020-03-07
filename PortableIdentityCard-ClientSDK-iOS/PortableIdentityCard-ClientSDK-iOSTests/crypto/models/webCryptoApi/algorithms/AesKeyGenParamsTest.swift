//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import XCTest
@testable import PortableIdentityCard_ClientSDK_iOS

class AesKeyGenParamsTest: XCTestCase {

    /// Expected Encoded Algorithm String.
    let encodedExpectedAlgorithm = """
    {
      "name" : "Test Algorithm",
      "length" : 42
    }
    """

    /**
     Attempts to decode Algorithm object.
     */
    func testDecode() throws {
        
        let algorithmData = encodedExpectedAlgorithm.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let actualAlgorithm: AesKeyGenParams = try decoder.decode(AesKeyGenParams.self, from: algorithmData)
        helperPropertiesTests(actualAlgorithm: actualAlgorithm)
    }
    
    /**
     Attempts to encode Algorithm object.
     */
    func testEncode() throws {
        let algorithm: AesGcmParams = AesGcmParams(iv: [43], additionalData: [44], tagLength: 45, length: 42)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        // encode Algorithm.
        let encodedAlgorithm = try encoder.encode(algorithm)
        
        let decoder = JSONDecoder()
        let actualAlgorithm = try decoder.decode(AesKeyGenParams.self, from: encodedAlgorithm)
        helperPropertiesTests(actualAlgorithm: actualAlgorithm)
    }
    
    private func helperPropertiesTests(actualAlgorithm: AesKeyGenParams) {
        XCTAssertEqual(actualAlgorithm.name, W3cCryptoApiConstants.AesGcm.rawValue, "Test algorithm property, name, was not decoded properly.")
        XCTAssertEqual(actualAlgorithm.length, 42, "Test algorithm property, length, was not decoded properly")
    }

}
