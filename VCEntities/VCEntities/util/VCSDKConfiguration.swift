/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct VCSDKConfiguration {
    
    public static var sharedInstance = VCSDKConfiguration()
    
    public private(set) var accessGroupIdentifier: String? = nil
    
    private init() {}
    
    mutating func setAccessGroupIdentifier(with id: String) {
        self.accessGroupIdentifier = id
    }
}
