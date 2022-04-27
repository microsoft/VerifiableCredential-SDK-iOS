/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest

@testable import VCServices

class DifWordListTests: XCTestCase {

    func testGenerateDifPassword() throws {
        let fixture = try DifWordList()
        guard let password = fixture?.generatePassword() else {
            XCTFail("Failed to generate a password with \(String(describing: fixture))")
            return
        }

        NSLog("Generated password: %@", password)
        let words = password.components(separatedBy: .whitespacesAndNewlines)
        XCTAssertEqual(words.count, Constants.PasswordSetSize, "Unexpected number of words in generated password")
    }
}
