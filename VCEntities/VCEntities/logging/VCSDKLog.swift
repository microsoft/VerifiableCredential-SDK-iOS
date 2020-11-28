/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public enum LogLevel {
    case VERBOSE
    case DEBUG
    case INFO
    case WARN
    case ERROR
    case FAILURE
}

public protocol LogConsumer {
    func log(logLevel: LogLevel, message: String, throwable: Error?, tag: String)
}

// TODO: tag equivalent in iOS?
public struct VCSDKLog {
    
    public static let sharedInstance = VCSDKLog()
    
    private static var consumers: [LogConsumer] = []
    
    public static func add(consumer: LogConsumer) {
        consumers.append(consumer)
    }
    
    public static func v(message: String, throwable: Error? = nil, tag: String = "") {
        log(logLevel: LogLevel.VERBOSE,
            message: message,
            throwable: throwable,
            tag: tag)
    }
    
    public static func d(message: String, throwable: Error? = nil, tag: String = "") {
        log(logLevel: LogLevel.DEBUG,
            message: message,
            throwable: throwable,
            tag: tag)
    }
    
    public static func i(message: String, throwable: Error? = nil, tag: String = "") {
        log(logLevel: LogLevel.INFO,
            message: message,
            throwable: throwable,
            tag: tag)
    }
    
    public static func w(message: String, throwable: Error? = nil, tag: String = "") {
        log(logLevel: LogLevel.WARN,
            message: message,
            throwable: throwable,
            tag: tag)
    }
    
    public static func e(message: String, throwable: Error? = nil, tag: String = "") {
        log(logLevel: LogLevel.ERROR,
            message: message,
            throwable: throwable,
            tag: tag)
    }
    
    public static func f(message: String, throwable: Error? = nil, tag: String = "") {
        log(logLevel: LogLevel.FAILURE,
            message: message,
            throwable: throwable,
            tag: tag)
    }
    
    private static func log(logLevel: LogLevel, message: String, throwable: Error?, tag: String) {
        consumers.forEach { logger in
            logger.log(logLevel: logLevel, message: message, throwable: throwable, tag: tag)
        }
    }
    
}
