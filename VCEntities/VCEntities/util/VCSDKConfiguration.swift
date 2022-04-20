/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

public struct VCSDKConfiguration: VCSDKConfigurable {
    
    public static var sharedInstance = VCSDKConfiguration()
    
    public private(set) var accessGroupIdentifier: String?
    
    private init() {}
    
    mutating func setAccessGroupIdentifier(with id: String) {
        self.accessGroupIdentifier = id
    }
}
