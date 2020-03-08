//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Foundation

/// A class to validate a Request object based on a specific protocol.
protocol Validator {
   
    /**
     Validate a request.
     TODO: make JWT Object?
     
     - Parameters:
        - request: Object that is being validated.
     
     - Returns: true, if request is valid.
     */
    func validate(request: AuthRequest) throws -> Bool
}
