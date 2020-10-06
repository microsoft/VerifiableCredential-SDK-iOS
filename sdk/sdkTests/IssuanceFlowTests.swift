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
        let store = SecretStoreMock()
        let key = Random32BytesSecret(withStore: store)!
        
        let retreivedSecret = try store.getSecret(id: key.id, itemTypeCode: "r32B")
        print(retreivedSecret.base64URLEncodedString())
        let sec = Secp256k1()
        let publicKey = try sec.createPublicKey(forSecret: key)
        print(publicKey.x.base64URLEncodedString())
        print(publicKey.y.base64URLEncodedString())
        XCTAssertEqual(publicKey.x.base64URLEncodedString(), "Ir5lqT2yDCXdWI8HgMj2erz9HVChFFv4Bd70oDqclvs")
        XCTAssertEqual(publicKey.y.base64URLEncodedString(), "_uSQb2NNO3MMnsS83ByMxayGbk3ODYxAlMx-_YOw5oc")
        
        let usecase = IssuanceUseCase()
        
        let identifier = MockIdentifier(keyId: key)
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
        let store = SecretStoreMock()
        let key = Random32BytesSecret(withStore: store)!
        
        let retreivedSecret = try store.getSecret(id: key.id, itemTypeCode: "r32B")
        print(retreivedSecret.base64URLEncodedString())
        let sec = Secp256k1()
        let publicKey = try sec.createPublicKey(forSecret: key)
        print(publicKey.x.base64URLEncodedString())
        print(publicKey.y.base64URLEncodedString())
        XCTAssertEqual(publicKey.x.base64URLEncodedString(), "Ir5lqT2yDCXdWI8HgMj2erz9HVChFFv4Bd70oDqclvs")
        XCTAssertEqual(publicKey.y.base64URLEncodedString(), "_uSQb2NNO3MMnsS83ByMxayGbk3ODYxAlMx-_YOw5oc")
        
        let issuanceUseCase = IssuanceUseCase()
        let presentationUseCase = PresentationUseCase()
        
        let identifier = MockIdentifier(keyId: key)
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
    
    private func getIssuanceResponse(useCase: IssuanceUseCase, contract: Contract, identifier: MockIdentifier) throws -> Promise<VerifiableCredential> {
        let response = try IssuanceResponseContainer(from: contract, contractUri: "https://portableidentitycards.azure-api.net/v1.0/9c59be8b-bd18-45d9-b9d9-082bc07c094f/portableIdentities/contracts/AIEngineerCert")
        return useCase.send(response: response, identifier: identifier)
    }
}

