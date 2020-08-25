/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

enum JwsDecoderError: Error {
    case unsupportedEncodingFormat
}

class JwsDecoder {
    
    private let decoder = JSONDecoder()
    
    func decode<T>(_ type: T.Type, token: String) throws -> JwsToken<T> {

        let splitStringifiedData = token.components(separatedBy: ".")
        print(splitStringifiedData)
        
        guard splitStringifiedData.count == 3 else {
            throw JwsDecoderError.unsupportedEncodingFormat
        }
        
        var headers = Header()
        if let dataHeaders = Data(base64URLEncoded: splitStringifiedData[0]) {
            headers = try decoder.decode(Header.self, from: dataHeaders)
        }
        
        let content = try decoder.decode(T.self, from: Data(base64URLEncoded: splitStringifiedData[1])!)
        let signature = Data(base64URLEncoded: splitStringifiedData[2])
        return JwsToken(headers: headers, content: content, signature: signature)
    }
}
