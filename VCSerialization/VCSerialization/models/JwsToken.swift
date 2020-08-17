/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

struct JwsToken: Serializable {
    
    let headers: [String: String]
    let content: String
    let signature: Data?
    
    init(with serializer: Serializer, data: Data) throws {
        guard let stringifiedToken = String(data: data, encoding: .utf8) else {
            throw SerializationError.unableToStringifyData(withData: data)
        }
        let splitStringifiedData = stringifiedToken.split(separator: ".")
        print(splitStringifiedData)
        
        guard let stringifiedHeaders = String(splitStringifiedData[0]).fromBase64URL() else {
            throw SerializationError.malFormedObject(withData: data)
        }
        
        let encodedHeaders = stringifiedHeaders.data(using: .utf8)
        
        if let dataHeaders = encodedHeaders {
            self.headers = try serializer.decoder.decode([String: String].self, from: dataHeaders)
        } else {
            self.headers = [:]
        }
        self.content = String(splitStringifiedData[1])
        self.signature = String(splitStringifiedData[2]).data(using: .utf8)
    }
    
    func serialize(to serializer: Serializer) throws -> Data {
        let serializedHeaders = try serializer.encoder.encode(self.headers)
        let nullableBase64EncodedHeaders = String(data: serializedHeaders, encoding: .utf8)?.toBase64URL()
        
        guard let base64EncodedHeaders = nullableBase64EncodedHeaders else {
            throw SerializationError.unableToStringifyData(withData: serializedHeaders)
        }
        
        var compactToken = "\(base64EncodedHeaders).\(self.content)"
        
        if let signature = self.signature {
            let stringifiedSignature = String(data: signature, encoding: .utf8)?.toBase64URL()
            compactToken = "\(compactToken).\(stringifiedSignature)"
        }
        
        if let serializedToken = compactToken.data(using: .utf8) {
            return serializedToken
        } else {
            throw SerializationError.nullData
        }
    }
    
    
}
