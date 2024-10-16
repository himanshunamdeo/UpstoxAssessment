//
//  CryptoDataService.swift
//  CryptoCoins
//
//  Created by MeTaLlOiD on 16/10/24.
//

import Foundation

class CryptoDataService {
    
    private var request: URLRequest
    
    init(with request: URLRequest) {
        self.request = request
    }
    
    private static func getURLString() -> String {
        return NetworkingUtility.baseURL
    }
    
    func fetchCryptoData() async throws -> [CryptoDetail] {
        
        do {
            let cryptoData = try await HTTPClient<[CryptoDetail]>().getData(for: request)
            return cryptoData
            
        } catch {
            throw error
        }
    }
    
    static func createRequest() throws -> URLRequest {
        if let url = URL(string: getURLString()) {
            let request = URLRequest(url: url)
            return request
        } else {
            throw URLError(.badURL)
        }
    }
}

class MockCryptoDataService: CryptoDataService {
    
    var mockCryptoData: [CryptoDetail] = []
    
    override func fetchCryptoData() async throws -> [CryptoDetail] {
        return mockCryptoData
    }
    
    static func mockURLRequest() -> URLRequest {
        let url = URL(string: "http://www.google.com")!
        return URLRequest(url: url)
    }
}
