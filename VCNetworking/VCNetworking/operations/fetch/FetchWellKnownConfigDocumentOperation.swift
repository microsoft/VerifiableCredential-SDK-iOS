/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import PromiseKit
import VCEntities

public class FetchWellKnownConfigDocumentOperation: InternalNetworkOperation {
    public typealias ResponseBody = WellKnownConfigDocument
    
    public let decoder = WellKnownConfigDocumentDecoder()
    public let urlSession: URLSession
    public let urlRequest: URLRequest
    
    public init(withUrl urlStr: String, session: URLSession = URLSession.shared) throws {
        
        var fullUrlString: String
        if urlStr.hasSuffix("/") {
            fullUrlString = urlStr + Constants.WELL_KNOWN_SUBDOMAIN
        } else {
            fullUrlString = urlStr + "/" + Constants.WELL_KNOWN_SUBDOMAIN
        }
        
        guard let url = URL(string: fullUrlString) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        
        self.urlRequest = URLRequest(url: url)
        self.urlSession = session
    }
}
