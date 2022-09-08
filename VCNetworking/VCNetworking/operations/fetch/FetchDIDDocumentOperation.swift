/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import PromiseKit
import VCEntities

class FetchDIDDocumentOperation: InternalNetworkOperation {
    typealias ResponseBody = IdentifierDocument
    
    let decoder = DIDDocumentDecoder()
    let urlSession: URLSession
    var urlRequest: URLRequest
    var correlationVector: CorrelationHeader?
    
    init(withIdentifier identifier: String,
         andCorrelationVector correlationVector: CorrelationHeader? = nil,
         session: URLSession = URLSession()) throws {
        
        guard let discoveryUrl = VCSDKConfiguration.sharedInstance.discoveryUrl,
              var urlComponents = URLComponents(string: discoveryUrl) else {
            throw NetworkingError.invalidUrl(withUrl: VCSDKConfiguration.sharedInstance.discoveryUrl)
        }
        
        let pathSuffix = urlComponents.path.last == "/" ? identifier : "/" + identifier
        urlComponents.path = urlComponents.path + pathSuffix
        
        guard let url = urlComponents.url else {
            throw NetworkingError.invalidUrl(withUrl: urlComponents.string ?? discoveryUrl)
        }
        
        self.urlRequest = URLRequest(url: url)
        self.urlSession = session
        self.correlationVector = correlationVector
    }
}
