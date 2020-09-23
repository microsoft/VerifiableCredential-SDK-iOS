/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct VerifiableCredentialDescriptor: Codable {
    let context: [String]
    let type: [String]
    let credentialSubject: Dictionary<String, Any>
    let credentialStatus: ServiceDescriptor?
    let exchangeService: ServiceDescriptor?
    let revokeService: ServiceDescriptor?

    enum CodingKeys: String, CodingKey {
        case context = "@context"
        case type, credentialSubject, credentialStatus, exchangeService, revokeService
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        context = try values.decode([String].self, forKey: .context)
        type = try values.decode([String].self, forKey: .type)
        credentialStatus = try values.decode(ServiceDescriptor.self, forKey: .credentialStatus)
        exchangeService = try values.decode(ServiceDescriptor.self, forKey: .exchangeService)
        revokeService = try values.decode(ServiceDescriptor.self, forKey: .revokeService)
        credentialSubject = try values.decode(Dictionary<String, Any>.self, forKey: .credentialSubject)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(context, forKey: .context)
        try container.encode(type, forKey: .type)
        try container.encode(credentialSubject, forKey: .credentialSubject)
        try container.encode(credentialStatus, forKey: .credentialStatus)
        try container.encode(exchangeService, forKey: .exchangeService)
        try container.encode(revokeService, forKey: .revokeService)
    }
    
    private func decodeCredentialStatus(using decoder: Decoder) {
        
    }
}
