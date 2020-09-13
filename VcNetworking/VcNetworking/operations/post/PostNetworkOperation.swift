/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import PromiseKit

/**
 * Post Network Operation Protocol with default methods for all Post Network Operations.
 */
public protocol PostNetworkOperation: NetworkOperation {
    associatedtype Encoder: Encoding
    associatedtype RequestBody where RequestBody == Encoder.RequestBody
}
