//
//  CustomURLError.swift
//  CryptoCoins
//
//  Created by MeTaLlOiD on 16/10/24.
//

import Foundation

enum CustomURLError: Error {
    case responseUnsuccessful
}

extension CustomURLError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .responseUnsuccessful:
            return "Response was unsuccessful."
        }
    }
}
