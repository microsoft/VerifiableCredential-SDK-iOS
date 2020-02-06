//
//  PrivateKeyContainer.swift
//  PortableIdentityCard-ClientSDK-iOS
//
//  Created by Sydney Morton on 2/6/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

class PrivateKeyContainer: KeyContainer {
    
    init(kty: KeyType, keys: [PrivateKey], use: KeyUse?, alg: Algorithm?) {
        super.init(kty: kty, keys: keys, use: use, alg: alg)
    }

}
