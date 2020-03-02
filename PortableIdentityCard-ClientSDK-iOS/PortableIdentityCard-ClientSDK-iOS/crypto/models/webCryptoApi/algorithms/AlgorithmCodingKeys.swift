//
//  AlgorithmCodingKeys.swift
//  PortableIdentityCard-ClientSDK-iOS
//
//  Created by Sydney Morton on 3/2/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

/**
 Enum of Coding Keys to be defined in Algorithms.
 */
enum AlgorithmCodingKeys: String, CodingKey {
    
    /// Coding Key for generic Algorithm.
    case name
    case hash
    
    /// Coding Keys for AES GCM Params.
    case iv
    case additionalData
    case tagLength
    
    /// Coding Keys for AES.
    case length
    case namedCurve
    
    /// Coding Keys for EC Keys.
    case format
    case keyReference
    
    /// Coding Keys for RSA.
    case modulusLength
    case publicExponent
    
    /// Coding Keys for RSA OEAP
    case label

}
