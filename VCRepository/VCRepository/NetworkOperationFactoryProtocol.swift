/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking

protocol NetworkOperationFactoryProtocol {
    func create<T: NetworkOperation>(_ type: T.Type, withUrl url: String) throws -> T?
}
