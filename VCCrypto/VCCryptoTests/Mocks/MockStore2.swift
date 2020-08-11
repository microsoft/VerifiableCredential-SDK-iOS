//
//  MockStore2.swift
//  VCCryptoTests
//
//  Created by Daniel Godbout on 8/7/20.
//  Copyright © 2020 Daniel Godbout. All rights reserved.
//

import Foundation

import Foundation
@testable import VCCrypto
internal class SecretStoreMock2 {
    
    private var memoryStore = [UUID: Data]()
    
    func getSecret(keyId: UUID) -> Secret throws {
        var secret = self.memoryStore[keyId]!
        f(&secret)
        try clear()
        defer {}
    }
    
    func saveSecret(secret: Secret) throws -> UUID {
        let uuid = UUID()
        memoryStore[uuid] = secret
        return uuid;
    }
    
    func clear() throws {
        self.memoryStore = [UUID: Secret]()
    }
}
