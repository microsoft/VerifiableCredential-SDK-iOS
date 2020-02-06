//
//  SecretKeyContainer.swift
//  PortableIdentityCard-ClientSDK-iOS
//
//  Created by Sydney Morton on 2/6/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

class SecretKeyContainer: KeyContainer {
    
    init(kty: KeyType, keys: [SecretKey], use: KeyUse?, alg: Algorithm?) {
        super.init(kty: kty, keys: keys, use: use, alg: alg)
    }

}
