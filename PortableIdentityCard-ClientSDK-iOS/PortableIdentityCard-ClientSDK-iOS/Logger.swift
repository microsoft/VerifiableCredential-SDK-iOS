//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

enum LogType {
    case error
    case verbose
    case info
}

class Logger {
    
    public func logTrace(_ type: LogType, _ message: String) {
        print(message)
        /// TODO
    }

}
