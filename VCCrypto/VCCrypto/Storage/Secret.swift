/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

internal protocol Secret: VCCryptoSecret & InternalSecret {}

public protocol VCCryptoSecret{
    
    /// The secret id
    var id:UUID { get }
}

protocol InternalSecret  {
    
    /// The secret bytes
    func withUnsafeBytes(f: (UnsafeRawBufferPointer) throws -> Void) throws
    
    /// The 4 characters representing the secret type in the store
    static var typeName: String { get }
}
