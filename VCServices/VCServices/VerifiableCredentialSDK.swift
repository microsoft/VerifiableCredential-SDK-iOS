/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCEntities
import VCCrypto

public class VerifiableCredentialSDK {
    
    public static func initialize() throws {
        
        let identifierService = IdentifierService()
        
        do {
            _ = try identifierService.fetchMasterIdentifier()
        } catch {
            // TODO: log
            _ = try identifierService.createAndSaveIdentifier(forId: VCEntitiesConstants.MASTER_ID, andRelyingParty: VCEntitiesConstants.MASTER_ID)
        }
    }
}
