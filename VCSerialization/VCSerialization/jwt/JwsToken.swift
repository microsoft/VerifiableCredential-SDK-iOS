/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VcCrypto

struct JwsToken<T: Claims> {
    
    let headers: Header
    let content: T
    var signature: Signature?
    
    init(headers: Header, content: T, signature: Data?) {
        self.headers = headers
        self.content = content
        self.signature = signature
    }
    
    init(from encodedToken: String) throws {
        let decoder = JwsDecoder()
        self = try decoder.decode(T.self, token: encodedToken)
    }
    
    init?(from encodedToken: Data) {
        guard let stringifiedToken = String(data: encodedToken, encoding: .utf8) else {
            return nil
        }
        let decoder = JwsDecoder()
        do {
            self = try decoder.decode(T.self, token: stringifiedToken)
        } catch {
            return nil
        }
    }
    
    func serialize() throws -> String {
        let encoder = JwsEncoder()
        return try encoder.encode(self)
    }
    
    mutating func sign(using signer: TokenSigning, usingSecret secret: VcCryptoSecret) throws {
        self.signature = try signer.sign(token: self, withSecret: secret)
    }
    
    func verify() {
        
    }
}

typealias Signature = Data
