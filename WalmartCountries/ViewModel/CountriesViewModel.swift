//
//  CountryViewModel.swift
//  WalmartCountries
//
//  Created by Sha'Marcus Walker on 3/14/25.
//

import Foundation

final class CountriesViewModel {
    private let countryManager: NetworkProtocol

    private var countriesList = [Country]()
    private(set) var filteredCountriesList = [Country]()
    weak var delegate: CountriesViewActions?
    
    init(countryManager: NetworkProtocol) {
        self.countryManager = countryManager
        fetchCountries()
    }

    func fetchCountries(){
        Task {
            do {
                let _countriesList = try await
                countryManager.fetchData(endpoint: CountryEndpoint.fetchCountries(), useCache: true)

                await MainActor.run {
                    countriesList = _countriesList
                    delegate?.refresh()
                }

            } catch let error {
                print("Error fetching data: \(error)")
                
                await MainActor.run {
                    delegate?.showError()
                }
            }
        }
    }
    
    func searchFilterData(with searchText: String) {
        filteredCountriesList = searchText == "" ? countriesList : countriesList.filter {
            ($0.name.lowercased().starts(with: searchText.lowercased()) || $0.capital.lowercased().starts(with: searchText.lowercased()))
        }
    }
    
}
