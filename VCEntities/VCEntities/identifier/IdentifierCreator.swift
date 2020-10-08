/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

struct IdentifierCreator {
    
    let cryptoOperations: CryptoOperations
    let identifierFormatter: IdentifierFormatter = IdentifierFormatter()
    
    init(cryptoOperations: CryptoOperations) {
        self.cryptoOperations = cryptoOperations
    }
    
    func create() {}
}
