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
    
    public init(withUrl urlStr: String, session: URLSession = URLSession.shared) throws {
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        
        self.urlRequest = URLRequest(url: url)
        self.urlSession = session
    }
}
