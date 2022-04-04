/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCEntities

public enum VerifiableCredentialSDKInitializationStatus
{
    case masterIdentifierCreated
    case masterIdentifierCreatedWithError(error: Error)
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
                                  accessGroupIdentifier: String? = nil) -> VerifiableCredentialSDKInitializationStatus {

        VCSDKLog.sharedInstance.add(consumer: logConsumer)
        
        if let accessGroupIdentifier = accessGroupIdentifier {
            VCSDKConfiguration.sharedInstance.setAccessGroupIdentifier(with: accessGroupIdentifier)
        }
        
        do {
            let identifier = try identifierService.fetchMasterIdentifier()
            if try identifierService.updateAccessGroupForKeysIfNeeded(for: identifier) {
                return .accessGroupForKeysUpdated
            }
        } catch {
            
            if error is IdentifierDatabaseError {
                VCSDKLog.sharedInstance.logWarning(message: "Failed to fetch master identifier with: \(String(describing: error))")
                return createNewIdentifier()
            }
            
            if case KeyContainerError.noSigningKeyFoundInStorage = error
            {
                VCSDKLog.sharedInstance.logWarning(message: "Failed find signing keys in storage with: \(String(describing: error))")
                let _ = createNewIdentifier()
                return .masterIdentifierCreatedWithError(error: error)
            }
            
            return .error(error: error)
        }
        
        return .success
    }
    
    private static func createNewIdentifier() -> VerifiableCredentialSDKInitializationStatus {
        do {
            _ = try identifierService.createAndSaveIdentifier(forId: VCEntitiesConstants.MASTER_ID, andRelyingParty: VCEntitiesConstants.MASTER_ID)
            return .masterIdentifierCreated
        } catch {
            return .error(error: error)
        }
    }
}
