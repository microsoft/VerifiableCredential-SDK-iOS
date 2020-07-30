//
//  Test.swift
//  sdk
//
//  Created by Sydney Morton on 7/30/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation
import Networking

class Test {
    
    func test() throws {
        let fetch = try FetchContract(withUrl: "https://portableidentitycards.azure-api.net/dev-v1.0/536279f6-15cc-45f2-be2d-61e352b51eef/portableIdentities/contracts/WoodgroveId")
        fetch.fire().done { result in
            print(result)
        }.catch { error in
            print(error)
        }
    }
}
