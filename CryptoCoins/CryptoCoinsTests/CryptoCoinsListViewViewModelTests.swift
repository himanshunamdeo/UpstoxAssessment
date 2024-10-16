//
//  CryptoCoinsListViewViewModelTests.swift
//  CryptoCoinsTests
//
//  Created by MeTaLlOiD on 16/10/24.
//

import Foundation
import XCTest
@testable import CryptoCoins

class CryptoCoinsListViewViewModelTests: XCTestCase {
    
    var viewModel: CryptoCoinsListViewViewModel!
    var mockService: MockCryptoDataService!
    
    override func setUp() {
        super.setUp()
        mockService = MockCryptoDataService(with: MockCryptoDataService.mockURLRequest())
        viewModel = CryptoCoinsListViewViewModel(service: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    // Test case for fetchCryptoData()
    func testFetchCryptoDataSuccess() async throws {
        // Arrange
        let mockData = [
            CryptoDetail(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: "coin"),
            CryptoDetail(name: "Ethereum", symbol: "ETH", isNew: true, isActive: true, type: "coin"),
            CryptoDetail(name: "Litecoin", symbol: "LTC", isNew: false, isActive: false, type: "coin")
        ]
        mockService.mockCryptoData = mockData
        
        // Act
        try await viewModel.fetchCryptoData()
        
        // Assert
        XCTAssertEqual(viewModel.cryptoDetailsArray.count, 3, "Expected 3 elements in cryptoDetailsArray")
    }
    
    
    
    // Test case for filterCryptoArray(with filters)
    func testFilterCryptoArrayWithFilters() async throws {
        // Arrange
        let mockData = [
            CryptoDetail(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: "coin"),
            CryptoDetail(name: "Ethereum", symbol: "ETH", isNew: true, isActive: true, type: "coin"),
            CryptoDetail(name: "Litecoin", symbol: "LTC", isNew: false, isActive: false, type: "coin"),
            CryptoDetail(name: "TokenX", symbol: "TKX", isNew: true, isActive: true, type: "token")
        ]
        
        mockService.mockCryptoData = mockData
        try await viewModel.fetchCryptoData()
        
        // Act - Applying filter for active coins only
        viewModel.filterCryptoArray(with: [.ActiveCoins])
        
        // Assert
        XCTAssertEqual(viewModel.cryptoDetailsArray.count, 2, "Expected 2 active coins")
        XCTAssertTrue(viewModel.cryptoDetailsArray.contains { $0.name == "Bitcoin" }, "Expected 'Bitcoin' in active coins")
        XCTAssertTrue(viewModel.cryptoDetailsArray.contains { $0.name == "Ethereum" }, "Expected 'Ethereum' in active coins")
        
        // Act - Filtering only for tokens
        viewModel.filterCryptoArray(with: [.onlyTokens])
        
        // Assert
        XCTAssertEqual(viewModel.cryptoDetailsArray.count, 1, "Expected 1 token")
        XCTAssertEqual(viewModel.cryptoDetailsArray.first?.name, "TokenX", "Expected 'TokenX' to be the only token")
    }
    
    // Test case for empty search filter
    func testFilterCryptoArrayWithEmptyString() async throws {
        // Arrange
        let mockData = [
            CryptoDetail(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: "coin"),
            CryptoDetail(name: "Ethereum", symbol: "ETH", isNew: true, isActive: true, type: "coin"),
            CryptoDetail(name: "Litecoin", symbol: "LTC", isNew: false, isActive: false, type: "coin")
        ]
        mockService.mockCryptoData = mockData
        try await viewModel.fetchCryptoData()
        
        // Act
        viewModel.filterCryptoArray(with: "")
        
        // Assert
        XCTAssertEqual(viewModel.cryptoDetailsArray.count, 3, "Expected all elements when filter is empty")
    }
    
    // Test case for filterCryptoArray(with substring)
    func testFilterCryptoArrayWithSubstring() async throws {
        // Arrange
        let mockData = [
            CryptoDetail(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: "coin"),
            CryptoDetail(name: "Ethereum", symbol: "ETH", isNew: true, isActive: true, type: "coin"),
            CryptoDetail(name: "Litecoin", symbol: "LTC", isNew: false, isActive: false, type: "coin")
        ]
        
        mockService.mockCryptoData = mockData
        try await viewModel.fetchCryptoData()
        
        // Act
        viewModel.filterCryptoArray(with: "Lite")
        
        // Assert
        XCTAssertEqual(viewModel.cryptoDetailsArray.count, 1, "Expected 1 element matching the substring 'Lite'")
        XCTAssertEqual(viewModel.cryptoDetailsArray.first?.name, "Litecoin", "Expected 'Litecoin' to be the only result")
    }
}
