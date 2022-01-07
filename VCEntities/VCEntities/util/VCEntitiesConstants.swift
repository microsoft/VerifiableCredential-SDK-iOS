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
    
    // JWK public key
    public static let SUPPORTED_PUBLICKEY_TYPE = "EcdsaSecp256k1VerificationKey2019"
    public static let PUBLICKEY_AUTHENTICATION_PURPOSE_V1 = "authentication"
    public static let PUBLICKEY_AUTHENTICATION_PURPOSE_V0 = "auth"
    public static let PUBLICKEY_GENERAL_PURPOSE_V0 = "general"
    
    // OIDC Protocol
    public static let ALGORITHM_SUPPORTED_IN_VP = "ES256K"
    public static let CREDENTIAL_FORMAT_SUPPORTED = "jwt"
    public static let DID_METHODS_SUPPORTED = "ion"
    public static let RESPONSE_TYPE = "id_token"
    public static let RESPONSE_MODE = "post"
    public static let SCOPE = "openid"
    public static let SUBJECT_IDENTIFIER_TYPE_DID = "did"
    
    public static let PIN = "pin"
}
