/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

@testable import VCCrypto

final class PublicKeyMock: PublicKey, Equatable {
    
    var algorithm: SupportedVerificationAlgorithm = .Secp256k1
    
    var uncompressedValue: Data = Data(count: 32)
    
    static func == (lhs: PublicKeyMock, rhs: PublicKeyMock) -> Bool {
        return lhs.uncompressedValue == rhs.uncompressedValue
    }
}
