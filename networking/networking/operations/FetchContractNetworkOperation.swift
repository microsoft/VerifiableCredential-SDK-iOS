//
//  FetchContractNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation
import PromiseKit

class FetchContractNetworkOperation  {
    
    let urlSession: URLSession
    
    let url = URL(string: "https://portableidentitycards.azure-api.net/dev-v1.0/536279f6-15cc-45f2-be2d-61e352b51eef/portableIdentities/contracts/WoodgroveId")!
    
    init(urlSession: URLSession = URLSession.shared) {
      self.urlSession = urlSession
    }
    
    func fire() -> Promise<Swift.Result<MockedContract, Error>> {
        return firstly {
            urlSession.dataTask(.promise, with: url)
        }.compactMap { data, response in
            do {
                let contract = try JSONDecoder().decode(MockedContract.self, from: data)
                return .success(contract)
            } catch {
                return .failure(error)
            }
        }
    }
}
