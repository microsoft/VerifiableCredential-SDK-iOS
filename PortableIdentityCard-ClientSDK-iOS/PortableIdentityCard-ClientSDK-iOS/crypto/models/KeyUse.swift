//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

enum KeyUse: String, Codable {
    case Signature = "sig"
    case Encryption = "enc"
}

func toKeyUse(use: String?) -> KeyUse? {
    switch use {
        case KeyUse.Signature.rawValue:
            return KeyUse.Signature
        case KeyUse.Encryption.rawValue:
            return KeyUse.Encryption
        default:
            return nil
    }
}
