/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import PromiseKit

struct MetricConstants {
    static let Name = "eventName"
    static let Duration = "duration_ms"
}

public func logNetworkTime(name: String,
                    correlationVector: CorrelationHeader? = nil,
                    _ block: @escaping () -> Promise<(data: Data, response: URLResponse)>) -> Promise<(data: Data, response: URLResponse)> {
    let startTime = Date().timeIntervalSince1970
    let result = block().get { body in
        
        let elapsedTime = Date().timeIntervalSince1970 - startTime
        
        var properties = [
            MetricConstants.Name: name,
            "CV_request": correlationVector?.value ?? ""
        ]
        
        if let httpResponse = body.response as? HTTPURLResponse {
            properties["isSuccessful"] = String(describing: httpResponse.statusCode >= 200 && httpResponse.statusCode < 300)
            properties["CV_response"] = httpResponse.allHeaderFields[correlationVector?.name] as? String ?? ""
            properties["code"] = String(describing: httpResponse.statusCode)
        }
        
        let measurements = [MetricConstants.Duration: NSNumber(value: elapsedTime)]
        
        VCSDKLog.sharedInstance.event(name: name, properties: properties, measurements: measurements)
    }

    return result
}
