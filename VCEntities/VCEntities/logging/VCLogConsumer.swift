/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

public protocol VCLogConsumer
{
    /**
     Logs a trace with calling function name, line, file.
     - Parameters:
     - traceLevel: VCTraceLevel of the log like verbose, info
     */
    func log(_ traceLevel: VCTraceLevel,
             message: String,
             functionName: String,
             file: String,
             line: Int)
}
