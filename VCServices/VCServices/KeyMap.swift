//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Foundation

public protocol KeyMap {
    func keyFor(id: UUID) -> Data?
}
