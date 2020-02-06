//
//  PublicKeyContainer.swift
//  PortableIdentityCard-ClientSDK-iOS
//
//  Created by Sydney Morton on 2/6/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

class PublicKeyContainer: KeyContainer {
    
    init(kty: KeyType, keys: [PublicKey], use: KeyUse?, alg: Algorithm?) {
        super.init(kty: kty, keys: keys, use: use, alg: alg)
    }

}
