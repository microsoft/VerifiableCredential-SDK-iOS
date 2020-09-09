/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public enum NetworkingError: Error, Equatable {
    case badRequest(withBody: String)
    case forbidden(withBody: String)
    case invalidUrl(withUrl: String)
    case notFound(withBody: String)
    case serverError(withBody: String)
    case unauthorized(withBody: String)
    case unknownNetworkingError(withBody: String)
    case unableToParseString
    case unableToParseData
}
