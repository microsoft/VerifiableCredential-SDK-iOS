/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import PromiseKit
import VCEntities

public class FetchDIDDocumentOperation: InternalNetworkOperation {
    public typealias ResponseBody = IdentifierDocument
    
    public let decoder = DIDDocumentDecoder()
    public let urlSession: URLSession
    public let urlRequest: URLRequest
    
    public init(withIdentifier identifier: String, session: URLSession = URLSession.shared) throws {
        guard var urlComponents = URLComponents(string: Constants.DISCOVERY_URL) else {
            throw NetworkingError.invalidUrl(withUrl: Constants.DISCOVERY_URL)
        }
        
        urlComponents.path = Constants.DISCOVERY_URL_PATH + identifier
        
        guard let url = urlComponents.url else {
            throw NetworkingError.invalidUrl(withUrl: urlComponents.string ?? Constants.DISCOVERY_URL)
        }
        
        self.urlRequest = URLRequest(url: url)
        self.urlSession = session
    }
}
