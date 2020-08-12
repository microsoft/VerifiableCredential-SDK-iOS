/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import CommonCrypto

enum HmacSha512Error: Error {
    case invalidMessage
    case invalidSecret
}

public struct HmacSha512 {
    
    /// Authenticate a message
    /// - Parameters:
    ///   - message: The message to authenticate
    ///   - secret: The secret used for authentication
    /// - Returns: The authentication code for the message
    public func authenticate(message: Data, withSecret secret: VCCryptoSecret) throws -> Data {
        guard message.count > 0 else { throw HmacSha512Error.invalidMessage }
        guard secret is Secret else { throw HmacSha512Error.invalidSecret }
        
        var messageAuthCode : [UInt8] = [UInt8](repeating: 0, count:Int(CC_SHA512_DIGEST_LENGTH))
        try (secret as! Secret).withUnsafeBytes { (secretPtr) in
            message.withUnsafeBytes {
                CCHmac(UInt32(kCCHmacAlgSHA512), secretPtr.bindMemory(to: UInt8.self).baseAddress!, secretPtr.count, $0.baseAddress, message.count, &messageAuthCode)
            }
        }
        
        return Data(messageAuthCode)
    }
    
    /// Verify that the authentication code is valid
    /// - Parameters:
    ///   - mac: The authentication code
    ///   - message: The message
    ///   - secret: The secret used
    /// - Returns: True if the authentication code is valid
    public func isValidAuthenticationCode(_ mac: Data, authenticating message: Data, withSecret secret: VCCryptoSecret) throws -> Bool {
        let authCode = try self.authenticate(message: message, withSecret: secret)
        return mac == authCode
    }
}
