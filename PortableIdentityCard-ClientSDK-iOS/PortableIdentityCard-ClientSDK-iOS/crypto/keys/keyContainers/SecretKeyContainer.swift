//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class SecretKeyContainer: KeyContainer {
    
    init(kty: KeyType, keys: [SecretKey], use: KeyUse?, alg: Algorithm?) {
        super.init(kty: kty, keys: keys, use: use, alg: alg)
    }

}
