//
//  KeyStoreError.swift
//  PortableIdentityCard-ClientSDK-iOS
//
//  Created by Sydney Morton on 2/27/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

enum KeyStoreError: Error {
    
    case KeysInContainerNotSecretKeys
    case KeysInContainerNotPrivateKeys
    case KeysInContainerNotPublicKeys
    case KeyNotSavedProperly(reason: KeychainResult)

}
