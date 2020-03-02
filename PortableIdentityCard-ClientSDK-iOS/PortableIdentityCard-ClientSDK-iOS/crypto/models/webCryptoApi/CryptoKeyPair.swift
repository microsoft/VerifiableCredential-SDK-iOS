//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

struct CryptoKeyPair: Codable {
    let publicKey: CryptoKey
    let privateKey: CryptoKey
}
