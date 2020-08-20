/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

extension Data {
    public init?(base64URLEncoded base64URLString: String) {
        var base64Encoded = base64URLString
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let paddingCount = 4 - base64Encoded.count % 4
        for _ in 0...paddingCount {
            base64Encoded.append("=")
        }
       
        self.init(base64Encoded: base64Encoded)
    }
    
    public func base64URLEncodedString() -> String {
        return self.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
