//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Foundation

/// Superclass to represent a generic Algorithm class.
class Algorithm: NSObject, Codable {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
