/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public protocol Signing {
    
    /// Sign a message hash and return signature.
    func sign(messageHash: Data) throws -> Data
    
    /// Validate a signature based on the message hash.
    func isValidSignature(signature: Data, forMessageHash messageHash: Data) throws -> Bool
    
    /// Get public key.
    func getPublicKey() throws -> PublicKey
}
