//
//  CountriesViewModelTests.swift
//  WalmartCountriesTests
//
//  Created by Sha'Marcus Walker  on 3/14/25.
//

import XCTest
@testable import WalmartCountries

protocol NetworkProtocol {
    func fetchData<Response>(endpoint: CountryEndpoints<Response>, useCache: Bool) async throws -> Response where Response : Decodable
}

class CountriesViewModelTests: XCTestCase {
    // !!!: - Mock NetworkProtocol implementation
    class MockCountryManager: NetworkProtocol {
        func fetchData<Response>(endpoint: CountryEndpoints<Response>, useCache: Bool) async throws -> Response where Response: Decodable {
            let countries = [
                Country(
                    capital: "Capital 1",
                    code: "Code 1",
                    currency: Currency(code: "Currency Code 1", name: "Currency Name 1", symbol: "Currency Symbol 1"),
                    flag: "Flag 1",
                    language: Language(code: "Language Code 1", name: "Language Name 1", iso6392: "ISO Code 1", nativeName: "Native Name 1"),
                    name: "Country 1",
                    region: .af,
                    demonym: "Demonym 1"
                ),
                Country(
                    capital: "Capital 2",
                    code: "Code 2",
                    currency: Currency(code: "Currency Code 2", name: "Currency Name 2", symbol: "Currency Symbol 2"),
                    flag: "Flag 2",
                    language: Language(code: "Language Code 2", name: "Language Name 2", iso6392: "ISO Code 2", nativeName: "Native Name 2"),
                    name: "Country 2",
                    region: .americas,
                    demonym: "Demonym 2"
                )
            ]
            
            guard let response = countries as? Response else {
                throw NSError(domain: "", code: 0, userInfo: nil) // Handle the casting error
            }
            
            return response
        }
    }
    
    var viewModel: CountriesViewModel!
    
    override func setUp() {
        super.setUp()
        let countryManager = CountryManager(jsonDecoder: JSONDecoder(), urlCache: URLCache.shared)
        viewModel = CountriesViewModel(countryManager: countryManager)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchCountries() async throws {
        await viewModel.fetchCountries()

        // Add a small delay to allow the data to be fetched
        try await Task.sleep(nanoseconds: 1 * 3_000_000_000) // Wait for 1 second

        // Assert that the countriesList is not empty after fetching
        XCTAssertFalse(viewModel.countriesList.isEmpty)
    }
    
    func testSearchFilterData() {
        // Set up some dummy data for testing
        viewModel.countriesList = [
            Country(
                capital: "Capital 1",
                code: "Code 1",
                currency: Currency(code: "Currency Code 1", name: "Currency Name 1", symbol: "Currency Symbol 1"),
                flag: "Flag 1",
                language: Language(code: "Language Code 1", name: "Language Name 1", iso6392: "ISO Code 1", nativeName: "Native Name 1"),
                name: "Country 1",
                region: .af,
                demonym: "Demonym 1"
            ),
            Country(
                capital: "Capital 2",
                code: "Code 2",
                currency: Currency(code: "Currency Code 2", name: "Currency Name 2", symbol: "Currency Symbol 2"),
                flag: "Flag 2",
                language: Language(code: "Language Code 2", name: "Language Name 2", iso6392: "ISO Code 2", nativeName: "Native Name 2"),
                name: "Country 2",
                region: .americas,
                demonym: "Demonym 2"
            ),
            Country(
                capital: "Capital 3",
                code: "Code 3",
                currency: Currency(code: "Currency Code 3", name: "Currency Name 3", symbol: "Currency Symbol 3"),
                flag: "Flag 3",
                language: Language(code: "Language Code 3", name: "Language Name 3", iso6392: "ISO Code 3", nativeName: "Native Name 3"),
                name: "Another Country",
                region: .eu,
                demonym: "Demonym 3"
            )
        ]
        
        // Test with empty search text
        viewModel.searchFilterData(with: "")
        XCTAssertEqual(viewModel.filteredCountriesList, viewModel.countriesList)
        
        // Test with specific search text
        viewModel.searchFilterData(with: "Country")
        XCTAssertEqual(viewModel.filteredCountriesList.count, 2)
        
        viewModel.searchFilterData(with: "Another")
        XCTAssertEqual(viewModel.filteredCountriesList.count, 1)
        
        viewModel.searchFilterData(with: "Invalid")
        XCTAssertTrue(viewModel.filteredCountriesList.isEmpty)
    }
}
