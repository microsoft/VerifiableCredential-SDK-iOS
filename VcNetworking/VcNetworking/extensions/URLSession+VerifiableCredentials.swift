/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import Foundation
import VCEntities

extension URLSession {
    
    public static var noRedirectsSharedSession = URLSession(delegate: VCURLSessionDelegate())
    
    convenience init(delegate: URLSessionDelegate) {
        self.init(configuration: URLSessionConfiguration.default, delegate: delegate, delegateQueue: nil)
    }
}

/// Delegate that does not allow redirects
class VCURLSessionDelegate: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        // Stops the redirection, and returns (internally) the response body.
        completionHandler(nil)
    }
}
