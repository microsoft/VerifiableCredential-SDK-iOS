/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

enum JwsEncoderError: Error {
    case unsupportedEncodingFormat
    case unableToStringifyData
}

enum JwsFormat {
    case compact
}

class JwsEncoder {
    
    private let encoder = JSONEncoder()
    
    func encode<T>(_ token: JwsToken<T>, format: JwsFormat = JwsFormat.compact) throws -> String {
        switch format {
        case .compact:
            return try encodeUsingCompactFormat(token: token)
        }
    }
    
    private func encodeUsingCompactFormat<T>(token: JwsToken<T>) throws -> String {
        
        var compactToken = try token.getProtectedMessage()
        if let signature = token.signature?.base64URLEncodedString() {
            compactToken = compactToken + "." + signature
        }
        return compactToken
    }
}
