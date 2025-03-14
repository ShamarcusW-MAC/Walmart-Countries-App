//
//  CountryEndpoint.swift
//  WalmartCountries
//
//  Created by Sha'Marcus Walker on 3/14/25.
//

import Foundation

struct CountryEndpoints<Reponse: Decodable> {
    let url: URL
    let responseType: Reponse.Type
}

struct CountryEndpoint {
    
    static var countriesURL: URL {
        guard let url = URL(string: "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json") else {
            fatalError("Invalid URL for endpoint.")
        }
        return url
    }
    
    static func fetchCountries() -> CountryEndpoints<[Country]> {
        CountryEndpoints(url: countriesURL, responseType: [Country].self)
    }
}
