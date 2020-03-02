//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

struct JsonWebKey: Codable {
    
    /// The following fields are defined in Section 3.1 of JSON Web Key
    let kty: String
    let kid: String?
    let use: String?
    let key_ops: Set<String>?
    let alg: String?
    
    /// The following fields are defined in JSON Web Key Parameters Registration
    let ext: Bool?
    
    /// The following fields are defined in Section 6 of JSON Web Algorithms
    let crv: String?
    let x: String?
    let y: String?
    let d: String?
    let n: String?
    let e: String?
    let p: String?
    let q: String?
    let dp: String?
    let dq: String?
    let qi: String?
    let k: String?
}
