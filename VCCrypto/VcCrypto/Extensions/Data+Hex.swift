/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

extension Data {
//    public init(hexString: String) {
//        var byteArray = [UInt8]()
//        for i in 0..<hexString.count/2 {
//            let index = i * 2
//            let range = hexString.index(hexString.startIndex, offsetBy: index)...hexString.index(hexString.startIndex, offsetBy: index+1)
//            byteArray.append(UInt8(String(hexString[range]), radix: 16)!)
//        }
//        self.init(byteArray)
//    }
    
    public init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
    
    public func toHexString() -> String {
        // let hexArray = self.map{ (byte) -> String in String(format: "%02hhx", byte) }
        // return hexArray.joined()
        
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
