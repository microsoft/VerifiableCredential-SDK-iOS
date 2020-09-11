/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

enum JwsDecoderError: Error {
    case unsupportedEncodingFormat
}

public class JwsDecoder {
    
    private let decoder = JSONDecoder()
    
    public init() {}
    
    public func decode<T>(_ type: T.Type, token: String) throws -> JwsToken<T> {

        let splitStringifiedData = token.components(separatedBy: ".")
        
        guard splitStringifiedData.count == 3 || splitStringifiedData.count == 2 else {
            throw JwsDecoderError.unsupportedEncodingFormat
        }
        
        guard let dataHeaders = Data(base64URLEncoded: splitStringifiedData[0]) else {
            throw VcJwtError.unableToParseData
        }
        
        let headers = try decoder.decode(Header.self, from: dataHeaders)
        
        guard let dataContents = Data(base64URLEncoded: splitStringifiedData[1]) else {
            throw VcJwtError.unableToParseData
        }
        
        let contents = try decoder.decode(T.self, from: dataContents)
        
        var signature: Data?
        if splitStringifiedData.count == 3 {
            signature = Data(base64URLEncoded: splitStringifiedData[2])
        }
        
        return JwsToken(headers: headers, content: contents, signature: signature)
    }
}
