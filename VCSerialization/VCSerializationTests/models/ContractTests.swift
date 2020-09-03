///*---------------------------------------------------------------------------------------------
//*  Copyright (c) Microsoft Corporation. All rights reserved.
//*  Licensed under the MIT License. See License.txt in the project root for license information.
//*--------------------------------------------------------------------------------------------*/
//
//import XCTest
//
//@testable import VCSerialization
//
//class ContractTests: XCTestCase {
//    
//    var expectedContract: Contract!
//    let serializer = Serializer()
//    
////    override func setUp() {
////        self.expectedContract = Contract(id: "contractId", display: self.setUpExpectedDisplay(), input: self.setUpInput())
////    }
//
////    func testSerializingContract() throws {
////        let serializedContract = try serializer.serialize(object: expectedContract)
////        let actualContract = try serializer.deserialize(Contract.self, data: serializedContract)
////        XCTAssertEqual(actualContract, expectedContract)
////        
////    }
//    
//    private func setUpInput() -> Input {
//        return Input(id: "inputId", credentialIssuer: "credentialIssuer", issuer: "issuerDid", attestations: self.setUpExpectedAttestations())
//    }
//    
//    private func setUpExpectedAttestations() -> Attestations {
//        let expectedSelfIssuedclaims = Claim(claim: "selfIssuedClaim", claimRequired: false, indexed: false)
//        let expectedSelfIssueds = SelfIssued(encrypted: false, claims: [expectedSelfIssuedclaims], selfIssuedRequired: false)
//        
//        let expectedIdTokenclaims = Claim(claim: "idTokenClaim", claimRequired: false, indexed: false)
//        let expectedIdTokens = IDToken(encrypted: false, claims: [expectedIdTokenclaims], idTokenRequired: false, configuration: "configForIdToken", clientID: "clientId", redirectURI: "redirectUri")
//        
//        let expectedPresentationclaims = Claim(claim: "idTokenClaim", claimRequired: false, indexed: false)
//        let expectedIssuer = Issuer(iss: "issuerDid")
//        let expectedPresentations = Presentation(encrypted: false, claims: [expectedPresentationclaims], presentationRequired: false, credentialType: "credentialType", issuers: [expectedIssuer], contracts: ["contract"])
//        
//        return Attestations(selfIssued: expectedSelfIssueds, presentations: [expectedPresentations], idTokens: [expectedIdTokens])
//    }
//    
////    private func setUpExpectedDisplay() -> Display {
////        let claim = Claims(type: "testClaimType", label: "ThisLabelTest")
////        let expectedClaims = ["testClaim": claim]
////        
////        let expectedConsentInfo = Consent(title: "testConsentScreenTitle", instructions: "instructions")
////        
////        let expectedLogo = Logo(uri: "whereIsComesFrom", logoDescription: "LogoDescription")
////        let expectedCard = Card(title: "titleOfCard", issuedBy: "DID", backgroundColor: "blue", textColor: "white", logo: expectedLogo, cardDescription: "ThisIsCardDescription")
////        
////        return Display(id: "displayId", locale: "locale", contract: "ContractURL", card: expectedCard, consent: expectedConsentInfo, claims: expectedClaims)
////    }
//
//}
