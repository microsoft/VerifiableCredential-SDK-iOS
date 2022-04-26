/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

public struct Microsoft2020IdentifierBackup : Codable {
    
    private struct Constants {
        static let OnTheWireMainIdentifier = "did.main.identifier"
    }
    
    public var master: Identifier?
    public var etc: [Identifier]
    public var all: [Identifier] {
        if let master = self.master {
            return [master] + self.etc
        }
        return self.etc
    }
    
    init() {
        self.master = nil
        self.etc = []
    }

    public init(from decoder:Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let decoded = try container.decode([RawIdentity].self)

        var master: RawIdentity? = nil
        self.etc = []
        try decoded.forEach{ rawIdentity in
            if rawIdentity.name == Constants.OnTheWireMainIdentifier {
                master = rawIdentity
                return
            }
            try self.etc.append(rawIdentity.asIdentifier())
        }
        master?.name = AliasComputer().compute(forId: VCEntitiesConstants.MASTER_ID,
                                               andRelyingParty: VCEntitiesConstants.MASTER_ID)
        self.master = try master?.asIdentifier()
    }
    
    public func encode(to encoder: Encoder) throws {

        var output = try self.etc.map(RawIdentity.init)
        if let master = self.master {
            // For interoperability w/the Android implementation..
            var mapped = try RawIdentity(identifier: master)
            mapped.name = Constants.OnTheWireMainIdentifier
            output.insert(mapped, at: 0)
        }
        
        var container = encoder.singleValueContainer()
        try container.encode(output)
    }
}
