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
        
        guard let base64EncodedHeaders = String(data: try encoder.encode(token.headers), encoding: .utf8)?.toBase64URL() else {
            throw JwsEncoderError.unableToStringifyData
        }
        
        guard let base64EncodedContents = String(data: try encoder.encode(token.content), encoding: .utf8)?.toBase64URL() else {
            throw JwsEncoderError.unableToStringifyData
        }
        
        var compactToken = base64EncodedHeaders + "." + base64EncodedContents
        
        if let signature = token.signature, let base64EncodedSignature = String(data: signature, encoding: .utf8)?.toBase64URL() {
            compactToken = compactToken + "." + base64EncodedSignature
        }
        return compactToken
    }
}
