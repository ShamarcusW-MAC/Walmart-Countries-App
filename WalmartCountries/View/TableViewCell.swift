//
//  TableViewCell.swift
//  WalmartCountries
//
//  Created by Sha'Marcus Walker on 3/14/25.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var countryCapital: UILabel!
    
    func loadCellData(country: Country) {
        countryName.text = country.name + (country.region.rawValue != "" ? ", " : "") + country.region.rawValue
        countryCapital.text = country.capital
        countryCode.text = country.code
        addAccessibility(country: country)
    }
    
    func personalizeCell() {
        countryName.textColor = UIColor.white
        countryCode.textColor = UIColor.white
        countryCapital.textColor = UIColor.white
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 8.0
        self.backgroundColor = UIColor.blue
    }
    
    
    func addAccessibility(country: Country) {
        countryName.accessibilityLabel = "Country Name: \(country.name)"
        
        countryCode.accessibilityLabel = "Country Code: \(country.code)"
        countryCapital.accessibilityLabel = "Capital: \(country.capital)"
    }
    
}
