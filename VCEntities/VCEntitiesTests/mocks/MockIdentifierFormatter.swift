/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

@testable import VCEntities

struct MockIdentifierFormatter: IdentifierFormatting {
    
    let returningString: String
    
    init(returningString: String) {
        self.returningString = returningString
    }
    
    func createIonLongForm(recoveryKey: ECPublicJwk, updateKey: ECPublicJwk, didDocumentKeys: [ECPublicJwk], serviceEndpoints: [IdentifierDocumentServiceEndpoint]) throws -> String {
        return self.returningString
    }
}
