//
//  URLResponse+GetStatusCode.swift
//  networking
//
//  Created by Sydney Morton on 7/25/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation
import PromiseKit

extension URLResponse {
    func convertToHttpUrlResponse(able: Bool = true) throws -> HTTPURLResponse {
        guard let httpResponse = self as? HTTPURLResponse, able else {
            throw NetworkingError.unknownNetworkingError(withBody: "")
        }
        return httpResponse
    }
}
