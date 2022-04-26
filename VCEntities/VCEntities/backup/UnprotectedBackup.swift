/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

public protocol UnprotectedBackup : Codable { }

/*
public typealias CredentialBackup = (credential: VerifiableCredential, metadata: VcMetadata)

public struct IdentifierBackup {

    public var master: Identifier?
    public var etc: [Identifier] = []

    public init(withMasterIdentifer identifier:Identifier? = nil) {
        self.master = identifier;
    }
    
    public mutating func addNonMaster(_ identifier:Identifier) {
        
        if let master = self.master,
           master.alias == identifier.alias {
            return
        }
        etc.append(identifier)
    }
    
    public var all : [Identifier] {
        
        if let master = self.master {
            return [master] + self.etc
        }
        return self.etc
    }
}

public struct UnprotectedBackup {
    public var seed: Data
    public var credentials: [CredentialBackup]
    public var identifiers: IdentifierBackup

    public init(seed: Data,
                credentials: [CredentialBackup],
                identifiers: IdentifierBackup) {
        self.seed = seed
        self.credentials = credentials
        self.identifiers = identifiers
    }
}
*/

