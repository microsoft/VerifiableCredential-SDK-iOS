/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

enum TokenVerifierError: Error {
    case unsupportedAlgorithm(alg: String)
}

class TokenVerifierFactory {
    static func getVerifier(forAlg alg: String) throws -> TokenVerifying {
        switch alg {
        case "ES256K":
            return Secp256k1Verifier()
        default:
            throw TokenVerifierError.unsupportedAlgorithm(alg: alg)
        }
    }
}


