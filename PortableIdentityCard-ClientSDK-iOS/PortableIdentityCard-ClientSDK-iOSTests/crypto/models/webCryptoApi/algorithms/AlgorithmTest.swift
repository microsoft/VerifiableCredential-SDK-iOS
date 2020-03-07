//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import XCTest
@testable import PortableIdentityCard_ClientSDK_iOS

/// Unit Test Class for Algorithm Class.
class AlgorithmTests: XCTestCase {
    
    /// Expected Encoded Algorithm String .
    let encodedExpectedAlgorithm = """
    {
      "name" : "testAlgorithm"
    }
    """

    /**
     Attempts to decode Algorithm object.
     */
    func testDecoding() throws {
        
        let algorithmData = encodedExpectedAlgorithm.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let algorithm: Algorithm = try decoder.decode(Algorithm.self, from: algorithmData)
        XCTAssertEqual(algorithm.name, "testAlgorithm", "Test algorithm was not decoded properly.")
    }
    
    /**
     Attempts to encode Algorithm object.
     */
    func testEncoding() throws {
        let algorithm = Algorithm(name: "testAlgorithm")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encodedAlgorithm = try encoder.encode(algorithm)
        let stringifiedEncodedAlgorithm = String(data: encodedAlgorithm, encoding: .utf8)!
        print(stringifiedEncodedAlgorithm)
        print(encodedExpectedAlgorithm)
        XCTAssertEqual(stringifiedEncodedAlgorithm, encodedExpectedAlgorithm, "Test Algorithm was not encoded properly")
    }
}
