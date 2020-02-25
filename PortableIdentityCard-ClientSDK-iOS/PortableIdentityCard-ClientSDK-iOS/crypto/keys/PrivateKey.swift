//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

protocol PrivateKey: PublicKey {
    
    override var alg: String? { get }
    
    /**
     Gets the corresponding public key
     
     - Returns:
        - The corresponding Public Key
     */
    func getPublicKey() throws -> PublicKey

}

extension PrivateKey {
    func minimumAlphabeticJwk() throws -> String {
        return try self.getPublicKey().minimumAlphabeticJwk()
    }
}
