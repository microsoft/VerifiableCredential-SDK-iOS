/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest
import VCRepository
import VCEntities
import VCCrypto
import PromiseKit

@testable import VCUseCase

/// testing flows until we get into App
class FlowTests: XCTestCase {
    
    var contract: Contract!
    
    override func setUpWithError() throws {
        let encodedContract = TestData.aiContract.rawValue.data(using: .utf8)!
        self.contract = try JSONDecoder().decode(Contract.self, from: encodedContract)
    }
    
    func testIssuance() throws {
        
        let cryptoOp = CryptoOperations(secretStore: SecretStoreMock())
        let identifier = try IdentifierCreator(cryptoOperations: cryptoOp).create()

        let usecase = IssuanceUseCase()
        let expec = self.expectation(description: "Fire")
        
        let contractUri = "https://portableidentitycards.azure-api.net/v1.0/9c59be8b-bd18-45d9-b9d9-082bc07c094f/portableIdentities/contracts/AIEngineerCert"
        let response = try IssuanceResponseContainer(from: contract, contractUri: contractUri)
        
        usecase.send(response: response, identifier: identifier).done {
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
        
        let cryptoOp = CryptoOperations(secretStore: SecretStoreMock())
        let identifier = try IdentifierCreator(cryptoOperations: cryptoOp).create()
        
        let issuanceUseCase = IssuanceUseCase()
        let presentationUseCase = PresentationUseCase()
        
        let expec = self.expectation(description: "Fire")
        
        let requestUri = "openid://vc/?request_uri=https://test-relyingparty.azurewebsites.net/request/hd6M8DH6ON3Jlw"
        
        firstly {
            presentationUseCase.getRequest(usingUrl: requestUri)
        }.then { request in
            issuanceUseCase.getRequest(usingUrl: request.content.presentationDefinition.inputDescriptors.first!.issuanceMetadata.first!.contract!)
        }.then { contract in
            try self.getIssuanceResponse(useCase: issuanceUseCase, contract: contract, identifier: identifier)
        }.done { vc in
            print(vc)
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTFail()
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 20)
    }
    
    private func getIssuanceResponse(useCase: IssuanceUseCase, contract: Contract, identifier: Identifier) throws -> Promise<VerifiableCredential> {
        let response = try IssuanceResponseContainer(from: contract, contractUri: "https://portableidentitycards.azure-api.net/v1.0/9c59be8b-bd18-45d9-b9d9-082bc07c094f/portableIdentities/contracts/AIEngineerCert")
        return useCase.send(response: response, identifier: identifier)
    }
}
