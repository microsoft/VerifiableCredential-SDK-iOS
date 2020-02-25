//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class CryptoKeyPair: NSObject {
    
    let publicKey: CryptoKey
    
    let privateKey: CryptoKey
    
    init(publicKey: CryptoKey, privateKey: CryptoKey) {
        self.publicKey = publicKey
        self.privateKey = privateKey
    }

}
