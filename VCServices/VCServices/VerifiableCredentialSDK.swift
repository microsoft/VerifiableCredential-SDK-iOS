/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCEntities

public enum VCSDKInitStatus
{
    case firstTimeMasterIdentifierCreated
    case newMasterIdentifierCreated
    case accessGroupForKeysUpdated
    case success
    case error(error: Error)
}

public class VerifiableCredentialSDK {
    
    static let identifierService = IdentifierService()
    
    /// Initialized the SDK.
    /// Returns: TRUE, if needed to create Master Identifier
    ///          FALSE, if Master Identifier is able to be fetched (included private keys from KeyStore)
    public static func initialize(logConsumer: VCLogConsumer = DefaultVCLogConsumer(),
                                  accessGroupIdentifier: String? = nil) -> VCSDKInitStatus {

        VCSDKLog.sharedInstance.add(consumer: logConsumer)
        
        
        /// Get access group identifier for app.
        if let accessGroupIdentifier = accessGroupIdentifier {
            VCSDKConfiguration.sharedInstance.setAccessGroupIdentifier(with: accessGroupIdentifier)
        }
        
        /// Try to fetch master identifier from storage.
        var identifier: Identifier
        do {
            
            identifier = try identifierService.fetchMasterIdentifier()
            
        } catch {
            
            /// If unable to fetch master identifier, create a new one.
            VCSDKLog.sharedInstance.logWarning(message: "Failed to fetch master identifier with: \(String(describing: error))")
            return createNewIdentifier(status: .firstTimeMasterIdentifierCreated)
            
        }
        
        /// Make sure keys are valid for master identifier, if they are not valid, update access group.
        do {
            if !identifierService.areKeysValid(for: identifier) {
                try identifierService.updateAccessGroupForKeys(for: identifier)
                return .accessGroupForKeysUpdated
            }
        } catch {
            
            /// if keys are not found in storage, create a new master identifier.
            if case KeyContainerError.noSigningKeyFoundInStorage = error
            {
                VCSDKLog.sharedInstance.logWarning(message: "Failed find signing keys in storage with: \(String(describing: error))")
                return createNewIdentifier(status: .newMasterIdentifierCreated)
            }
            
            return .error(error: error)
        }
        
        /// VC sdk initialization successful.
        return .success
    }
    
    private static func createNewIdentifier(status: VCSDKInitStatus) -> VCSDKInitStatus {
        do {
            _ = try identifierService.createAndSaveIdentifier(forId: VCEntitiesConstants.MASTER_ID, andRelyingParty: VCEntitiesConstants.MASTER_ID)
            return status
        } catch {
            return .error(error: error)
        }
    }
}
