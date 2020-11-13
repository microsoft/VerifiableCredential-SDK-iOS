/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCEntities
import VCCrypto

public class VerifiableCredentialSDK {
    
    public static func initialize() throws {
        
        let identifierService = IdentifierService()
        
        guard try identifierService.fetchMasterIdentifier() != nil else {
            _ = try identifierService.createAndSaveIdentifier(forId: "master", andRelyingParty: "master")
            return
        }
    }
    

}
