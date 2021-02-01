/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import PromiseKit
import VCEntities

public class FetchContractOperation: InternalNetworkOperation {
    public typealias ResponseBody = SignedContract
    
    public let decoder: ContractDecoder = ContractDecoder()
    public let urlSession: URLSession
    public var urlRequest: URLRequest
    
    public init(withUrl urlStr: String, session: URLSession = URLSession.shared) throws {
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        
        self.urlSession = session
        self.urlRequest = URLRequest(url: url)
        
        /// sets value in order to get a signed version of the contract
        self.urlRequest.addValue("x-ms-sign-contract", forHTTPHeaderField: "true")
    }
}
