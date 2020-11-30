/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

// TODO: tag equivalent in iOS?
public struct VCSDKLog {
    
    public static let sharedInstance = VCSDKLog()
    
    private static var consumers: [VCLogConsumer] = []
    
    public static func add(consumer: VCLogConsumer) {
        consumers.append(consumer)
    }
    
    public static func v(formatMessage: String,
                         _ args: CVarArg...,
        functionName: String = #function,
        file: String = #file,
        line: Int = #line) {
        log(VCTraceLevel.VERBOSE,
            formatMessage: formatMessage,
            args,
            functionName: functionName,
            file: file,
            line: line)
    }
    
    public static func d(formatMessage: String,
                         _ args: CVarArg...,
        functionName: String = #function,
        file: String = #file,
        line: Int = #line) {
        log(VCTraceLevel.DEBUG,
            formatMessage: formatMessage,
            args,
            functionName: functionName,
            file: file,
            line: line)
    }
    
    public static func i(formatMessage: String,
                         _ args: CVarArg...,
        functionName: String = #function,
        file: String = #file,
        line: Int = #line) {
        log(VCTraceLevel.INFO,
            formatMessage: formatMessage,
            args,
            functionName: functionName,
            file: file,
            line: line)
    }
    
    public static func w(formatMessage: String,
                         _ args: CVarArg...,
        functionName: String = #function,
        file: String = #file,
        line: Int = #line) {
        log(VCTraceLevel.WARN,
            formatMessage: formatMessage,
            args,
            functionName: functionName,
            file: file,
            line: line)
    }
    
    public static func e(formatMessage: String,
                         _ args: CVarArg...,
        functionName: String = #function,
        file: String = #file,
        line: Int = #line) {
        log(VCTraceLevel.ERROR,
            formatMessage: formatMessage,
            args,
            functionName: functionName,
            file: file,
            line: line)
    }
    
    public static func f(formatMessage: String,
                         _ args: CVarArg...,
        functionName: String = #function,
        file: String = #file,
        line: Int = #line) {
        log(VCTraceLevel.FAILURE,
            formatMessage: formatMessage,
            args,
            functionName: functionName,
            file: file,
            line: line)
    }
    
    private static func log(_ traceLevel: VCTraceLevel,
                            formatMessage: String,
                            _ args: CVarArg...,
        functionName: String,
        file: String,
        line: Int) {
        consumers.forEach { logger in
            logger.log(traceLevel,
                       formatMessage: formatMessage,
                       args,
                       functionName: functionName,
                       file: file,
                       line: line)
        }
    }
    
}
