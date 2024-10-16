//
//  CryptoCoinsListViewViewModel.swift
//  CryptoCoins
//
//  Created by MeTaLlOiD on 16/10/24.
//

import Foundation

class CryptoCoinsListViewViewModel {
    
    private var service: CryptoDataService
    var cryptoDetailsArray: [CryptoDetail] {
        Array(cryptoDetailsSet)
    }
    private var cryptoDetailsSet = Set<CryptoDetail>()
    private var unfilteredSet = Set<CryptoDetail>()
    private var filteredSet = Set<CryptoDetail>()
    private var searchableSet: Set<CryptoDetail> {
        return filteredSet
    }
    
    init(service: CryptoDataService) {
        self.service = service
    }
    
    func fetchCryptoData() async throws {
        do {
            cryptoDetailsSet = Set(try await service.fetchCryptoData())
            unfilteredSet = cryptoDetailsSet
            filteredSet = cryptoDetailsSet
        } catch {
            throw error
        }
    }
    
    func filterCryptoArray(with subString: String) {
        if subString == "" {
            // Display All the data when search text field is empty that means nothing is searched
            cryptoDetailsSet = searchableSet
        } else {
            cryptoDetailsSet = searchableSet.filter { element in
                element.name.contains(subString)
            }
        }
    }
    
    func filterCryptoArray(with filters: [FilterType]) {
        
        if filters.isEmpty {
            cryptoDetailsSet = unfilteredSet
        } else {
            cryptoDetailsSet.removeAll()
            
            for filter in filters {
                print(filter)
                switch filter {
                case .ActiveCoins:
                    cryptoDetailsSet.formUnion(unfilteredSet.filter { $0.isActive == true && $0.type == CryptoType.activeCoin.rawValue })
                case .inactiveCoins:
                    cryptoDetailsSet.formUnion(unfilteredSet.filter { $0.isActive == false && $0.type == CryptoType.activeCoin.rawValue})
                case .onlyCoins:
                    cryptoDetailsSet.formUnion(unfilteredSet.filter { $0.type == CryptoType.activeCoin.rawValue })
                case .onlyTokens:
                    cryptoDetailsSet.formUnion(unfilteredSet.filter { $0.type == CryptoType.activeToken.rawValue })
                case .newCoins:
                    cryptoDetailsSet.formUnion(unfilteredSet.filter { $0.isNew == true && $0.type == CryptoType.activeCoin.rawValue})
                }
            }
        }
        
        filteredSet = cryptoDetailsSet
        
    }
}
