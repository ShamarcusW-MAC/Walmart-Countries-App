//
//  CountriesDynamicFontTest.swift
//  WalmartCountriesTests
//
//  Created by Sha'Marcus Walker on 3/14/25.
//

import XCTest
@testable import WalmartCountries

final class CountriesDynamicFontTest: XCTestCase {
    
    var countriesViewController: CountriesViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace with your storyboard name
        countriesViewController = storyboard.instantiateViewController(withIdentifier: "CountriesViewController") as? CountriesViewController
        countriesViewController.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        countriesViewController = nil
        super.tearDown()
    }
    
    func testDynamicFont() {
        
        let label = countriesViewController.welcomeLabel
        let expectedFontName = ".SFUI-Regular"
        let expectedFontSize: CGFloat = 24.0 
        let expectedText = "Welcome to the Countries App! Feel free to search any of the countries we have listed!"

        
        // When
        let actualFontName = label?.font.fontName
        let actualFontSize = label?.font.pointSize
        let actualText = label?.text

        
        // Then
        XCTAssertEqual(actualFontName, expectedFontName)
        XCTAssertEqual(actualFontSize, expectedFontSize)
        XCTAssertEqual(actualText, expectedText)
    }

}
