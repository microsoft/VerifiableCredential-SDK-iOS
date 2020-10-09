/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest
import VCJwt

@testable import VCEntities

class IdentifierFormatterTests: XCTestCase {
    
    let formatter = IdentifierFormatter()
    let expectedDid = "did:ion:EiCwQRh6648Z1gUjgs9GgQpdx_bAGPS_MnuUCi3PLUWgEg?-ion-initial-state=eyJkZWx0YV9oYXNoIjoiRWlEY1ZZeVVNaGpNc0E3SWhCSW5EbEN6Z2pRTm45Tk93UENzUjZBMFFsblEzQSIsInJlY292ZXJ5X2NvbW1pdG1lbnQiOiJFaUNpT0ZIcHdqRGJ1eUg5TjRGYUNOb1pDMzRBMUpEUlV3eWhadnZ1dzNfdjBBIn0.eyJwYXRjaGVzIjpbeyJkb2N1bWVudCI6eyJwdWJsaWNfa2V5cyI6W3siaWQiOiJ0ZXN0S2V5IiwicHVycG9zZSI6WyJhdXRoIiwiZ2VuZXJhbCJdLCJ0eXBlIjoiRWNkc2FTZWNwMjU2azFWZXJpZmljYXRpb25LZXkyMDE5IiwiandrIjp7ImtleV9vcHMiOlsidmVyaWZ5Il0sInVzZSI6InNpZyIsIngiOiJJcjVscVQyeURDWGRXSThIZ01qMmVyejlIVkNoRkZ2NEJkNzBvRHFjbHZzIiwieSI6Il91U1FiMk5OTzNNTW5zUzgzQnlNeGF5R2JrM09EWXhBbE14LV9ZT3c1b2MiLCJhbGciOiJFUzI1NmsiLCJrdHkiOiJFQyIsImNydiI6InNlY3AyNTZrMSIsImtpZCI6InRlc3RLZXkifX1dLCJzZXJ2aWNlX2VuZHBvaW50cyI6W119LCJhY3Rpb24iOiJyZXBsYWNlIn1dLCJ1cGRhdGVfY29tbWl0bWVudCI6IkVpQ2lPRkhwd2pEYnV5SDlONEZhQ05vWkMzNEExSkRSVXd5aFp2dnV3M192MEEifQ"
    
    func testFormatting() throws {
        let key = ECPublicJwk(x: "Ir5lqT2yDCXdWI8HgMj2erz9HVChFFv4Bd70oDqclvs", y: "_uSQb2NNO3MMnsS83ByMxayGbk3ODYxAlMx-_YOw5oc", keyId: "testKey")
        let actualDid = try formatter.createIonLongForm(recoveryKey: key, updateKey: key, didDocumentKeys: [key], serviceEndpoints: [])
        XCTAssertEqual(actualDid, expectedDid)
        
    }


}
