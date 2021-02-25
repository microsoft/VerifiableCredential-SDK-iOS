/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct TraceHelper {
    
    public static var sharedInstance = TraceHelper()
    
    public var userAgentInfo: String = ""
    
    private init() {}
    
    public mutating func setUserAgentInfo(with info: String) {
        self.userAgentInfo = info
    }
}
