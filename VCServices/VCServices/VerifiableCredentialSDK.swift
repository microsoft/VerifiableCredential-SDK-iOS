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

/// initialization errors.
public enum VCSDKInitError: Error {
    case invalidKeys
}

/// Class used to Initialize the SDK.
public class VerifiableCredentialSDK {
    
    public static let identifierService = IdentifierService()
    
    /// Initialized the SDK.
    /// Returns: TRUE, if needed to create Master Identifier
    ///          FALSE, if Master Identifier is able to be fetched (included private keys from KeyStore)
    public static func initialize(logConsumer: VCLogConsumer = DefaultVCLogConsumer(),
                                  accessGroupIdentifier: String? = nil) -> Result<VCSDKInitStatus, Error> {

        VCSDKLog.sharedInstance.add(consumer: logConsumer)
        
        /// Get access group identifier for app.
        if let accessGroupIdentifier = accessGroupIdentifier {
            VCSDKConfiguration.sharedInstance.setAccessGroupIdentifier(with: accessGroupIdentifier)
        }
        
        /// Try to fetch master identifier from storage.
        do {
            
            _ = try identifierService.fetchMasterIdentifier()
            
            if try !identifierService.areKeysValid() {
                return .failure(VCSDKInitError.invalidKeys)
            }
            
        } catch {
            
            /// If unable to fetch master identifier, create a new one.
            VCSDKLog.sharedInstance.logWarning(message: "Failed to fetch master identifier with: \(String(describing: error))")
            return createNewIdentifier()
            
        }
        
        /// VC sdk initialization successful.
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
