/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

protocol SuccessHandler {
    func onSuccess<ResponseBody>(_ type: ResponseBody.Type, data: Data, response: HTTPURLResponse) throws -> ResponseBody
}
