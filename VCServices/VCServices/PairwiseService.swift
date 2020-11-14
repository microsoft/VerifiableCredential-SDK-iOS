/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/


import PromiseKit
import VCRepository
import VCEntities

class PairwiseService {
    
    private let exchangeService: ExchangeService
    private let identifierService: IdentifierService
    
    convenience init() {
        self.init(exchangeService: ExchangeService(),
                  identifierService: IdentifierService())
    }
    
    init(exchangeService: ExchangeService,
         identifierService: IdentifierService) {
        self.exchangeService = exchangeService
        self.identifierService = identifierService
    }
    
    func createPairwiseResponse(response: ResponseContaining) -> Promise<ResponseContaining> {
        var res = response
        return firstly {
            self.createPairwiseIdentifier(forId: "master", andRelyingParty: response.audienceUrl)
        }.then { pairwiseIdentifier in
            self.exchangeRequestedVcs(vcs: response.requestVCMap, newOwnerDid: pairwiseIdentifier.longFormDid)
        }.then { vcMap in
            self.replaceResponseVcMap(response: &res, vcMap: vcMap)
        }
    }
    
    private func createPairwiseIdentifier(forId id: String, andRelyingParty rp: String) -> Promise<Identifier> {
        return Promise { seal in
            seal.fulfill(try identifierService.createAndSaveIdentifier(forId: id, andRelyingParty: rp))
        }
    }
    
    private func exchangeRequestedVcs(vcs: RequestedVerifiableCredentialMap, newOwnerDid: String) -> Promise<[TypeToVcTuple]> {
        var promises: [Promise<TypeToVcTuple>] = []
        for vc in vcs {
            promises.append(exchangeVerifiableCredential(type: vc.key, exchangeableVerifiableCredential: vc.value, newOwnerDid: newOwnerDid))
        }
        return when(fulfilled: promises)
    }
    
    private func exchangeVerifiableCredential(type: String, exchangeableVerifiableCredential vc: VerifiableCredential, newOwnerDid: String) -> Promise<TypeToVcTuple> {
        
        do {
            let ownerIdentifier = try getOwnerIdentifier(fromVc: vc)
            let exchangeRequest = try ExchangeRequestContainer(
                exchangeableVerifiableCredential: vc,
                newOwnerDid: newOwnerDid,
                currentOwnerIdentifier: ownerIdentifier)
            
            return firstly {
                self.exchangeService.send(request: exchangeRequest)
            }.then { vc in
                self.combineVCAndType(type: type, vc: vc)
            }
        } catch {
            return Promise { seal in
                seal.reject(error)
            }
        }
    }
    
    private func combineVCAndType(type: String, vc: VerifiableCredential) -> Promise<TypeToVcTuple> {
        return Promise { seal in
            seal.fulfill(TypeToVcTuple(type, vc))
        }
    }
    
    private func replaceResponseVcMap(response: inout ResponseContaining, vcMap: [TypeToVcTuple]) -> Promise<ResponseContaining> {
        let dict = Dictionary(uniqueKeysWithValues: vcMap)
        response.requestVCMap = dict
        return Promise { seal in
            seal.fulfill(response)
        }
    }
    
    private func getOwnerIdentifier(fromVc vc: VerifiableCredential) throws -> Identifier {
        let ownerLongformDid = vc.token.content.sub
        let nullableOwnerIdentifier = try identifierService.fetchIdentifer(withLongformDid: ownerLongformDid)
        
        guard let ownerIdentifier = nullableOwnerIdentifier else {
            throw PresentationServiceError.inputStringNotUri
        }
        
        return ownerIdentifier
    }
}

public typealias TypeToVcTuple = (String, VerifiableCredential)
