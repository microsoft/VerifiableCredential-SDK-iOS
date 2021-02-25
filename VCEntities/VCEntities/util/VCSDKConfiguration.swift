/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct VCSDKConfiguration {
    
    public static var sharedInstance = VCSDKConfiguration()
    
    public var userAgentInfo: String = ""
    
    private init() {}
    
    public mutating func setUserAgentInfo(with info: String) {
        self.userAgentInfo = info
    }
}
