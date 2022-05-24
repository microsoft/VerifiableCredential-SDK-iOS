/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCEntities

/// status of a successful initialization
public enum VCSDKInitStatus
{
    case newMasterIdentifierCreated
    case success
}

/// Class used to Initialize the SDK.
public class VerifiableCredentialSDK {
    
    public static let identifierService = IdentifierService()
    
    /// Initialized the SDK.
    /// Returns:  Result<VCSDKInitStatus>, if successfully initialized the SDK.
    ///        Result<Error>, if there was an error, and unable to initialize SDK.
    public static func initialize(logConsumer: VCLogConsumer = DefaultVCLogConsumer(),
                                  accessGroupIdentifier: String? = nil) -> Result<VCSDKInitStatus, Error> {

        /// Step 1: Add Log to VCSDKLog shared instance.
        VCSDKLog.sharedInstance.add(consumer: logConsumer)
        
        /// Step 2: Set access group identifier for key chain.
        if let accessGroupIdentifier = accessGroupIdentifier {
            VCSDKConfiguration.sharedInstance.setAccessGroupIdentifier(with: accessGroupIdentifier)
        }
        
        /// Step 3: if master identifier does not exist, create a new one.
        if !identifierService.doesMasterIdentifierExist()
        {
            return createNewIdentifier()
        }
        
        /// Step 4: return success.
        return .success(.success)
    }
    
    private static func createNewIdentifier() -> Result<VCSDKInitStatus, Error> {
        do {
            _ = try identifierService.createAndSaveIdentifier(forId: VCEntitiesConstants.MASTER_ID,
                                                              andRelyingParty: VCEntitiesConstants.MASTER_ID)
            return .success(.newMasterIdentifierCreated)
        } catch {
            return .failure(error)
        }
    }
}
