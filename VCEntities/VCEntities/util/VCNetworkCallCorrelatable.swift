//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

/**
 * Protocol for managing Correlation Vectors for network calls.
 */
public protocol VCNetworkCallCorrelatable {
    
    var value: CorrelationVectorHeader { get set }
    
    func create()
    
    func increment() -> String
}
