//
//  Country.swift
//  WalmartCountries
//
//  Created by Sha'Marcus Walker on 3/14/25.
//

import Foundation

struct Country: Decodable, Equatable {
    let capital, code: String
    let currency: Currency
    let flag: String
    let language: Language
    let name: String
    let region: Region
    let demonym: String?

    static func ==(lhs: Country, rhs: Country) -> Bool {
        return lhs.capital == rhs.capital &&
               lhs.code == rhs.code &&
               lhs.currency == rhs.currency &&
               lhs.flag == rhs.flag &&
               lhs.language == rhs.language &&
               lhs.name == rhs.name &&
               lhs.region == rhs.region &&
               lhs.demonym == rhs.demonym
    }
}

struct Currency: Decodable, Equatable {
    let code, name: String
    let symbol: String?

    static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.code == rhs.code &&
               lhs.name == rhs.name &&
               lhs.symbol == rhs.symbol
    }
}

struct Language: Decodable, Equatable {
    let code: String?
    let name: String
    let iso6392, nativeName: String?

    enum CodingKeys: String, CodingKey {
        case code, name
        case iso6392 = "iso639_2"
        case nativeName
    }

    static func ==(lhs: Language, rhs: Language) -> Bool {
        return lhs.code == rhs.code &&
               lhs.name == rhs.name &&
               lhs.iso6392 == rhs.iso6392 &&
               lhs.nativeName == rhs.nativeName
    }
}

enum Region: String, Decodable, Equatable {
    case af = "AF"
    case americas = "Americas"
    case an = "AN"
    case empty = ""
    case eu = "EU"
    case na = "NA"
    case oc = "OC"
    case regionAS = "AS"
    case sa = "SA"
}
