/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking
import PromiseKit

protocol ApiCalling: Fetching, Posting { }

class ApiCalls: ApiCalling {
    let networkOperationFactory: NetworkOperationCreating
    
    init(networkOperationFactory: NetworkOperationCreating = NetworkOperationFactory()) {
        self.networkOperationFactory = networkOperationFactory
    }
}
