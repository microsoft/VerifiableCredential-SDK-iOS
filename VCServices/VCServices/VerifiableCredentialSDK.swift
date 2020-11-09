/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCEntities
import VCCrypto

public class VerifiableCredentialSDK {
    
    public static func initialize() throws {
        
        let cryptoOperations = CryptoOperations()
        let identifierDatabase = IdentifierDatabase(cryptoOperations: cryptoOperations)
        let identifierCreator = IdentifierCreator(cryptoOperations: cryptoOperations)
        
        guard try identifierDatabase.fetchMasterIdentifier() != nil else {
            let identifier = try identifierCreator.create()
            try identifierDatabase.saveIdentifier(identifier: identifier)
            return
        }
    }
    

}
