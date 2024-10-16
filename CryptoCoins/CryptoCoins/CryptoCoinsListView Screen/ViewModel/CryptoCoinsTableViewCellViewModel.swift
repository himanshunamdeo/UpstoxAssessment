//
//  CryptoCoinsTableViewCellViewModel.swift
//  CryptoCoins
//
//  Created by MeTaLlOiD on 16/10/24.
//

import Foundation

enum CryptoType: String {
    case activeCoin = "coin"
    case activeToken = "token"
    
    var getImageName: String {
        switch self {
        case .activeCoin:
            return "ActiveCoin"
        case .activeToken:
            return "ActiveToken"
        }
    }
}

class CryptoCoinsTableViewCellViewModel {
    
    private var cryptoDetail: CryptoDetail
    
    init(cryptoDetail: CryptoDetail) {
        self.cryptoDetail = cryptoDetail
    }
    
    var isFreshnessImageViewHidden: Bool {
        return !cryptoDetail.isNew
    }
    
    var cryptoImageName: String {
        
        if cryptoDetail.isActive {
            return CryptoType(rawValue: cryptoDetail.type)?.getImageName ?? "bitcoinsign.circle.fill"
        } else {
            return "InactiveCrypto"
        }
    }
    
    var cryptoName: String {
        cryptoDetail.name
    }
    
    var cryptoAcronyme: String {
        cryptoDetail.symbol
    }
}
