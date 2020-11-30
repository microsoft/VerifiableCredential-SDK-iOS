/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCEntities
import VCCrypto

public class VerifiableCredentialSDK {
    
    /// Initialized the SDK.
    /// Returns: TRUE, if needed to create Master Identifier
    ///          FALSE, if Master Identifier is able to be fetched (included private keys from KeyStore)
    public static func initialize(logConsumer: VCLogConsumer = DefaultVCLogConsumer()) throws -> Bool {

        VCSDKLog.add(consumer: logConsumer)
        
        let identifierService = IdentifierService()
        
        do {
            _ = try identifierService.fetchMasterIdentifier()
            return false
        } catch {
            // TODO: log
            _ = try identifierService.createAndSaveIdentifier(forId: VCEntitiesConstants.MASTER_ID, andRelyingParty: VCEntitiesConstants.MASTER_ID)
            return true
        }
    }
}
