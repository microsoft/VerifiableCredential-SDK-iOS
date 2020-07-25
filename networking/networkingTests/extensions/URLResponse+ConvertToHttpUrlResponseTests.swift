//
//  URLResponse+ConvertToHttpUrlResponseTests.swift
//  networkingTests
//
//  Created by Sydney Morton on 7/25/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import XCTest

@testable import networking

class URLResponseExtensionTests: XCTestCase {

    func testThrowsError() {
        let response = URLResponse.init(url: URL(string: "test")!, mimeType: nil, expectedContentLength: 42, textEncodingName: nil)
        XCTAssertThrowsError(try response.convertToHttpUrlResponse(able: false)) { error in
            print(error)
        }
    }
}
