/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest
import VCEntities
import VCCrypto
import PromiseKit

@testable import VCServices

/// testing flows until we get into App
class FlowTests: XCTestCase {
    
    var contract: Contract!
    var presentationRequest: PresentationRequest? = nil
    
    override func setUpWithError() throws {
        let encodedContract = TestData.aiContract.rawValue.data(using: .utf8)!
        self.contract = try JSONDecoder().decode(Contract.self, from: encodedContract)
        let _ = try VerifiableCredentialSDK.initialize()
    }
    
    override func tearDownWithError() throws {
        try CoreDataManager.sharedInstance.deleteAllIdentifiers()
    }
    
    func testIssuance() throws {

        let usecase = IssuanceService()
        let expec = self.expectation(description: "Fire")
        
        let contractUri = "https://portableidentitycards.azure-api.net/v1.0/9c59be8b-bd18-45d9-b9d9-082bc07c094f/portableIdentities/contracts/AIEngineerCert"
        var response = try IssuanceResponseContainer(from: contract, contractUri: contractUri)
        response.requestedSelfAttestedClaimMap["name"] = "sydney"
        
        usecase.send(response: response).done {
            response in
            print(response)
            expec.fulfill()
        }.catch { error in
            print(error)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 20)
    }
    
    func testPresentation() throws {
        
        let issuanceUseCase = IssuanceService()
        let presentationUseCase = PresentationService()
        
        let expec = self.expectation(description: "Fire")
        
        let requestUri = "openid://vc/?request_uri=https://test-relyingparty.azurewebsites.net/request/6_QgVJ10JSX4Qg"
        
        firstly {
            presentationUseCase.getRequest(usingUrl: requestUri)
        }.then { request in
            self.getIssuanceRequest(issuanceUseCase: issuanceUseCase, request: request)
        }.then { request in
            try self.getIssuanceResponse(useCase: issuanceUseCase, issuanceRequest: request)
        }.then { vc in
            try self.sendPresentationResponse(useCase: presentationUseCase, request: self.presentationRequest!, vc: vc)
        }.done { response in
            print(response ?? "presentation successful!")
            expec.fulfill()
        }.catch { error in
            print(error)
            print(type(of: error))
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 600)
    }
    
    private func getIssuanceRequest(issuanceUseCase: IssuanceService, request: PresentationRequest) -> Promise<IssuanceRequest> {
        self.presentationRequest = request
        return issuanceUseCase.getRequest(usingUrl: request.token.content.presentationDefinition.inputDescriptors.first!.issuanceMetadata.first!.contract!)
    }
    
    private func getIssuanceResponse(useCase: IssuanceService, issuanceRequest: IssuanceRequest) throws -> Promise<VerifiableCredential> {
        var response = try IssuanceResponseContainer(from: issuanceRequest.content, contractUri: "https://portableidentitycards.azure-api.net/v1.0/9c59be8b-bd18-45d9-b9d9-082bc07c094f/portableIdentities/contracts/AIEngineerCert")
        response.requestedSelfAttestedClaimMap["Name"] = "sydney"
        return useCase.send(response: response)
    }
    
    private func sendPresentationResponse(useCase: PresentationService,
                                          request: PresentationRequest,
                                          vc: VerifiableCredential) throws -> Promise<String?> {
        var responseContainer = try PresentationResponseContainer(from: request)
        responseContainer.requestVCMap["VerifiedAIEngineerCertificate"] = vc
        return useCase.send(response: responseContainer)
    }
}
