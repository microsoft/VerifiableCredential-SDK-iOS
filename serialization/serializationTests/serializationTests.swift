//
//  serializationTests.swift
//  serializationTests
//
//  Created by Sydney Morton on 7/27/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import XCTest
@testable import serialization

class serializationTests: XCTestCase {

    override func setUpWithError() throws {}

    func testExample() throws {
        let data = serializedContract.data(using: .utf8)!
        let serializer = Serializer()
        let contract = try serializer.deserialize(Contract.self, data: data)
        print(contract)
    }
    
    let serializedContract =  """
                        {"id":"WoodgroveId","display":{"id":"display","locale":"en-US","contract":"https://portableidentitycards.azure-api.net/dev-v1.0/536279f6-15cc-45f2-be2d-61e352b51eef/portableIdentities/contracts/WoodgroveId","card":{"title":"Verified Employee","issuedBy":"Woodgrove","backgroundColor":"#391463","textColor":"#FFFFFF","logo":{"uri":"https://test-relyingparty.azurewebsites.net/images/woodgrove_logo.png","description":"Woodgrove logo"},"description":"Woodgrove Org Identity Card."},"consent":{"title":"Do you want to get your Woodgrove Identity Card?","instructions":"You will need to sign in with your Woodgrove credentials."},"claims":{"vc.credentialSubject.name":{"type":"String","label":"Name"},"vc.credentialSubject.email":{"type":"String","label":"Email"},"vc.credentialSubject.firstName":{"type":"String","label":"First Name"},"vc.credentialSubject.lastName":{"type":"String","label":"Last Name"}}},"input":{"id":"input","credentialIssuer":"https://portableidentitycards.azure-api.net/dev-v1.0/536279f6-15cc-45f2-be2d-61e352b51eef/portableIdentities/card/issue","issuer":"did:ion:EiCfeOciEjwupwRQsJC3wMZzz3_M3XIo6bhy7aJkCG6CAQ?-ion-initial-state=eyJkZWx0YV9oYXNoIjoiRWlEMDQwY2lQakUxR0xqLXEyWmRyLVJaXzVlcU8yNFlDMFI5bTlEd2ZHMkdGQSIsInJlY292ZXJ5X2NvbW1pdG1lbnQiOiJFaUMyRmQ5UE90emFNcUtMaDNRTFp0Wk43V0RDRHJjdkN4eTNvdlNERDhKRGVRIn0.eyJ1cGRhdGVfY29tbWl0bWVudCI6IkVpQ2gtaTFDMW1fM2N4SGJNM3pXemRRdExxMnBvRldaX25FVEJTb0NhT2JZTWciLCJwYXRjaGVzIjpbeyJhY3Rpb24iOiJyZXBsYWNlIiwiZG9jdW1lbnQiOnsicHVibGljX2tleXMiOlt7ImlkIjoic2lnXzBmOTdlZWZjIiwidHlwZSI6IkVjZHNhU2VjcDI1NmsxVmVyaWZpY2F0aW9uS2V5MjAxOSIsImp3ayI6eyJrdHkiOiJFQyIsImNydiI6InNlY3AyNTZrMSIsIngiOiJoQ0xsb3JJbGx2M2FWSkRiYkNxM0VHbzU2bWV6Q3RLWkZGcUtvS3RVc3BzIiwieSI6Imh1VG5iTEc3MWU0NDNEeVJkeU5DX3dfc3paR0hVYUcxUHdsMHpXb0h2LUEifSwicHVycG9zZSI6WyJhdXRoIiwiZ2VuZXJhbCJdfV19fV19","attestations":{"idTokens":[{"encrypted":false,"claims":[{"claim":"name","required":false,"indexed":false},{"claim":"upn","required":false,"indexed":false},{"claim":"given_name","required":false,"indexed":false},{"claim":"family_name","required":false,"indexed":false}],"required":false,"configuration":"https://login.microsoftonline.com/woodgrove.ms/.well-known/openid-configuration","client_id":"40be4fb5-7f3a-470b-aa37-66ed43821bd7","redirect_uri":"https://didwebtest.azurewebsites.net/verify"}]}}}
                    """

}
