//
//  CryptoDetails.swift
//  CryptoCoins
//
//  Created by MeTaLlOiD on 16/10/24.
//

import Foundation
struct CryptoDetails: Codable {
    let cryptoDetails: [CryptoDetail]
}

struct CryptoDetail: Codable, Hashable {
    
    let name: String
    let symbol: String
    let isNew: Bool
    let isActive: Bool
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case isNew = "is_new"
        case isActive = "is_active"
        case type
    }
}
