/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

public protocol SuccessHandling {
    associatedtype Decoder: Decoding

    func onSuccess(data: Data) throws -> Decoder.ResponseBody
}
