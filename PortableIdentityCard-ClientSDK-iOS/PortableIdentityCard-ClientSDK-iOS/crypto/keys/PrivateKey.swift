//
//  PrivateKey.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 2/3/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

protocol PrivateKey: PublicKey {
    
    override var alg: String? { get }
    
    /**
     Gets the corresponding public key
     
     - Returns:
        - The corresponding Public Key
     */
    func getPublicKey() -> PublicKey

}

extension PrivateKey {
    func minimumAlphabeticJwk() -> String {
        return self.getPublicKey().minimumAlphabeticJwk()
    }
}
