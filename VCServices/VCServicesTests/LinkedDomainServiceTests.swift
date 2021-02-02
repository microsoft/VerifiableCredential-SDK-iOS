/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest
import VCEntities

@testable import VCServices

class LinkedDomainServiceTests: XCTestCase {
    
    var service: LinkedDomainService!
    var mockIdentifier: Identifier!
    
    override func setUpWithError() throws {
        let discoveryApiCalls = MockDiscoveryApiCalls(resolveSuccessfully: true)
        
        service = LinkedDomainService(didDocumentDiscoveryApiCalls: discoveryApiCalls,
                                      wellKnownDocumentApiCalls: <#T##WellKnownConfigDocumentNetworking#>,
                                      domainLinkageValidator: <#T##DomainLinkageCredentialValidating#>)
        
        self.presentationRequest = PresentationRequest(from: TestData.presentationRequest.rawValue)!
        
        self.mockIdentifier = try identifierCreator.create(forId: "master", andRelyingParty: "master")
        
        try identifierDB.saveIdentifier(identifier: mockIdentifier)
        
        MockPresentationResponseFormatter.wasFormatCalled = false
        MockPresentationApiCalls.wasPostCalled = false
        MockPresentationApiCalls.wasGetCalled = false
        MockDiscoveryApiCalls.wasGetCalled = false
        MockPresentationRequestValidator.wasValidateCalled = false
    }
}
