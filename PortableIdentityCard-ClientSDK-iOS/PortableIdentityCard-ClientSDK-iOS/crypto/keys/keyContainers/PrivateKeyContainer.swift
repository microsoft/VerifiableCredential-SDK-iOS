//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class PrivateKeyContainer: KeyContainer {
    
    init(kty: KeyType, keys: [PrivateKey], use: KeyUse?, alg: Algorithm?) {
        super.init(kty: kty, keys: keys, use: use, alg: alg)
    }

}
