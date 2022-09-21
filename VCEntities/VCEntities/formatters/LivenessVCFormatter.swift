/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCToken

public class LivenessVCFormatter {
    
    public init() {}
    
    public func format(content: Data, metadata: String, identifier: Identifier) throws -> VerifiableCredential
    {
        throw FormatterError.noSigningKeyFound
    }
}
