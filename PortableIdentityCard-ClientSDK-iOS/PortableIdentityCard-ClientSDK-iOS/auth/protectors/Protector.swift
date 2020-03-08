//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Foundation

/// protocol used when protecting (signing/encrypting/etc) an object.
protocol Protector {
    
    /**
     Protect the object.
     */
    func protect() -> String
}
