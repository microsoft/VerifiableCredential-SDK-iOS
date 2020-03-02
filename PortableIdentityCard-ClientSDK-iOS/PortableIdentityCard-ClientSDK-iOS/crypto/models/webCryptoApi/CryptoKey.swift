//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

struct CryptoKey: Codable {
    let type: KeyScopeType
    let extractable: Bool
    let algorithm: Algorithm
    let usages: [KeyUsage]
}
