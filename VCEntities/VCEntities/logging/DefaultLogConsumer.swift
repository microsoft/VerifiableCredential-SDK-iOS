/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct DefaultLogConsumer: LogConsumer {
    
    public init() {}
    
    public func log(logLevel: LogLevel, message: String, throwable: Error?, tag: String) {
        print(message)
    }
}
