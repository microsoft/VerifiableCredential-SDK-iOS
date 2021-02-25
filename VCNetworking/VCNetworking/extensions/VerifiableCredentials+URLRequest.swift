/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VCEntities

extension URLRequest {

    init(_ url: URL) {
        self.init(url: url)
        
        if TraceHelper.sharedInstance.userAgentInfo != "" {
            self.setValue("User-Agent", forHTTPHeaderField: TraceHelper.sharedInstance.userAgentInfo)
        }
    }
}
