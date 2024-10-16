//
//  HTTPClient.swift
//  CryptoCoins
//
//  Created by MeTaLlOiD on 16/10/24.
//

import Foundation

class HTTPClient<T: Decodable> {
    
    func getData(for request: URLRequest) async throws -> T {
        
        do {
            let (data, httpResponse) = try await URLSession.shared.data(for: request)
            try validateResponse(response: httpResponse)
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            throw error
        }
    }
    
    private func validateResponse(response: URLResponse?) throws {
        guard let urlResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(urlResponse.statusCode) else {
            throw CustomURLError.responseUnsuccessful
        }
    }
}
