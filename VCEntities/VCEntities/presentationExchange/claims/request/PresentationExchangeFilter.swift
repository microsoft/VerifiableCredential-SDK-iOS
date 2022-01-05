/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

/**
 * Contents of the Presentation Exchnage Filter inside of a Input Descriptor Field  from the Presentation Exchange protocol.
 *
 * @see [Presentation Exchange Spec](https://identity.foundation/presentation-exchange/#input-descriptor-object)
 */
public struct PresentationExchangeFilter: Codable, Equatable {
    
    /// type of value (ex. String)
    public let type: String?
    
    /// JSON Schema descriptor
    public let pattern: String?
}
