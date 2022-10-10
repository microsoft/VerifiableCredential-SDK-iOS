/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public protocol Signing {
    
    func sign(messageHash: Data) throws -> Data
    
    func isValidSignature(signature: Data, forMessageHash messageHash: Data) throws -> Bool
    
    func getPublicKey() throws -> PublicKey
}
