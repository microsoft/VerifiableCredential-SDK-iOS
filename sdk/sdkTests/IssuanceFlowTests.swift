//
//  VCUseCaseTests.swift
//  VCUseCaseTests
//
//  Created by Sydney Morton on 9/14/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import XCTest
import VCRepository
import VCCrypto
import VCUseCase
import VCEntities
import PromiseKit

class IssuanceUseCaseTests: XCTestCase {
    
    var usecase: IssuanceUseCase!
    var contract: Contract!
    let expectedUrl = "https://test3523.com"
    
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
        
        let requestUri = "openid://vc/?request_uri=https://test-relyingparty.azurewebsites.net/request/UZWlr4uOY13QiA"
        
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

