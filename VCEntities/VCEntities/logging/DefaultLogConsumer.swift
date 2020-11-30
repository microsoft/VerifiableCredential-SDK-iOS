/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

public struct DefaultVCLogConsumer: VCLogConsumer {
    
    public init() {}
    
    public func log(_ traceLevel: VCTraceLevel,
                    formatMessage: String,
                    _ args: CVarArg...,
        functionName: String = #function,
        file: String = #file,
        line: Int = #line) {
        print(formatMessage)
    }
}
