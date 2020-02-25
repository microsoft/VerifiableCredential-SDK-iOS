//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class PublicKeyContainer: KeyContainer {
    
    init(kty: KeyType, keys: [PublicKey], use: KeyUse?, alg: Algorithm?) {
        super.init(kty: kty, keys: keys, use: use, alg: alg)
    }

}
