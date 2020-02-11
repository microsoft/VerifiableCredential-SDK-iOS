//
//  JwsFormat.swift
//  PortableIdentityCard-ClientSDK-iOS
//
//  Created by Sydney Morton on 2/7/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

enum JwsFormat: String, Codable {
    case Compact = "compact"
    case FlatJson = "flatJson"
    case GeneralJson = "generalJson"
}
