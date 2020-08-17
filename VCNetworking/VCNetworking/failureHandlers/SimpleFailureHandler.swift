/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import Foundation
import VCSerialization

class SimpleFailureHandler: FailureHandler {
    
    func onFailure(data: Data, response: HTTPURLResponse) throws -> NetworkingError {
        guard let responseBody = String(data: data, encoding: .utf8) else {
            throw NetworkingError.serverError(withBody: "Unable to parse error response")
        }
        switch response.statusCode {
        case 400:
            return NetworkingError.badRequest(withBody: responseBody)
        case 401:
            return NetworkingError.unauthorized(withBody: responseBody)
        case 403:
            return NetworkingError.forbidden(withBody: responseBody)
        case 404:
            return NetworkingError.notFound(withBody: responseBody)
        case 500...599:
            return NetworkingError.serverError(withBody: responseBody)
        default:
           return NetworkingError.unknownNetworkingError(withBody: responseBody)
        }
    }
}
