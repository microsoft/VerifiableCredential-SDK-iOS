/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

/// Public Key protocol for verification of signatures.
public protocol PublicKey {
    
    /// Currently supported algorithms for signature verification.
    var algorithm: SupportedSigningAlgorithm { get }
    
    /// Uncompressed value of the public key.
    var uncompressedValue: Data { get }
}
