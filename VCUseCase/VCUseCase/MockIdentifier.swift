/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcJwt
import VcNetworking

struct MockIdentifier {
    let keyId: KeyId = KeyId(id: UUID())
}
