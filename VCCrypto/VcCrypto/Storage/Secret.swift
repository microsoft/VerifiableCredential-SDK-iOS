/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

internal protocol Secret: VcCryptoSecret & InternalSecret {}

public protocol VcCryptoSecret{
    
    /// The secret id
    var id:UUID { get }
}

protocol InternalSecret  {
    
    /// Invokes the closure passed as a param with a buffer pointer to the raw bytes of the secret. 
    func withUnsafeBytes(_ body: (UnsafeRawBufferPointer) throws -> Void) throws
    
    /// The 4 characters representing the secret type in the store. This correspond to kSecAttrType in keychain
    static var itemTypeCode: String { get }
}
