//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import XCTest
@testable import PortableIdentityCard_ClientSDK_iOS

class AesGcmParamsTest: XCTestCase {

    /// Expected Encoded Algorithm String.
    let encodedExpectedAlgorithm = """
    {
      "name" : "\(W3cCryptoApiConstants.AesGcm.rawValue)",
      "iv" : [43],
      "additionalData" : [44],
      "tagLength" : 45,
      "length" : 42
    }
    """

    /**
     Attempts to decode Algorithm object.
     */
    func testDecode() throws {
        
        let algorithmData = encodedExpectedAlgorithm.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let actualAlgorithm: AesGcmParams = try decoder.decode(AesGcmParams.self, from: algorithmData)
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
        let actualAlgorithm = try decoder.decode(AesGcmParams.self, from: encodedAlgorithm)
        helperPropertiesTests(actualAlgorithm: actualAlgorithm)
    }
    
    private func helperPropertiesTests(actualAlgorithm: AesGcmParams) {
        XCTAssertEqual(actualAlgorithm.name, W3cCryptoApiConstants.AesGcm.rawValue, "Test algorithm property, name, was not decoded properly.")
        XCTAssertEqual(actualAlgorithm.iv, [43], "Test algorithm property, iv, was not decoded properly")
        XCTAssertEqual(actualAlgorithm.additionalData, [44], "Test algorithm property, additionalData, was not decoded properly")
        XCTAssertEqual(actualAlgorithm.tagLength, 45, "Test algorithm property, additionalData, was not decoded properly")
        XCTAssertEqual(actualAlgorithm.length, 42, "Test algorithm property, length, was not decoded properly")
    }

}
