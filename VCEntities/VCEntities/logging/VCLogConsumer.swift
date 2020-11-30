/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

/// VCLogger protocol
public protocol VCLogConsumer
{
    /**
     Logs a trace with calling function name, line, file.
     - Parameters:
        - traceLevel: VCTraceLevel of the log like verbose, info
        - domain: Logging application eg: PhoneFactor, Broker, MSAL
        - formatMessage: The format of log message
        - args: Var args supporting the log message
     */
    func log(_ traceLevel: VCTraceLevel,
                  formatMessage: String,
                  _ args: CVarArg...,
                  functionName: String,
                  file: String,
                  line: Int)
}
