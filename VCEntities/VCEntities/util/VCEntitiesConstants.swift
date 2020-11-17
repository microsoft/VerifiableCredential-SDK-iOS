/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct VCEntitiesConstants {
    static let SELF_ISSUED = "https://self-issued.me"
    
    // TODO: temporary until deterministic key generation is implemented.
    public static let MASTER_ID = "master"
    
    // key actions in a DID Document
    public static let SIGNING_KEYID_PREFIX = "sign_"
    public static let UPDATE_KEYID_PREFIX = "update_"
    public static let RECOVER_KEYID_PREFIX = "recover_"
}
