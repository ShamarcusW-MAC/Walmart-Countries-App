//
//  CountriesViewController.swift
//  WalmartCountries
//
//  Created by Sha'Marcus Walker on 3/14/25.
//

import UIKit

protocol CountriesViewActions: AnyObject {
    func showError()
    func refresh()
}
final class CountriesViewController: UIViewController {
    
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var countriesViewModel = CountriesViewModel(countryManager: CountryManager())
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("navigationbar_title", comment: "")
        navigationItem.searchController = searchController
        countriesViewModel.delegate = self
        countryTableView.delegate = self
        countryTableView.dataSource = self
        countryTableView.backgroundColor = UIColor.black
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
                
        initializeWelcome()
        initializeNoResults()
    }
    
    
    private func initializeWelcome() {
        welcomeLabel.font = UIFont.systemFont(ofSize: 24.0)
        welcomeLabel.textColor = UIColor.blue
        welcomeLabel.text = NSLocalizedString("welcome_message", comment: "")
        welcomeLabel.accessibilityLabel = NSLocalizedString("welcome_message", comment: "")
    }
    
   private func initializeNoResults() {
        noResultsLabel.isHidden = true
        noResultsLabel.font = UIFont.systemFont(ofSize: 24.0)
        noResultsLabel.text = NSLocalizedString("noresults_message", comment: "")
       noResultsLabel.accessibilityLabel = NSLocalizedString("noresults_message", comment: "")
    }
}

extension CountriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesViewModel.filteredCountriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countryTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let country = countriesViewModel.filteredCountriesList[indexPath.row]
        cell.personalizeCell()
        cell.loadCellData(country: country)
        return cell
    }
}

extension CountriesViewController: UITableViewDelegate {

}

extension CountriesViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        welcomeLabel.isHidden = true
    }
}

extension CountriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        countriesViewModel.searchFilterData(with: searchText)
        noResultsLabel.isHidden = !countriesViewModel.filteredCountriesList.isEmpty
        self.countryTableView.reloadData()
    }
}

extension CountriesViewController: CountriesViewActions {
    func showError() {
        let alertController = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message: NSLocalizedString("error_message", comment: ""), preferredStyle: .alert)
        let retryAction = UIAlertAction(title: NSLocalizedString("error_retry", comment: ""), style: .destructive) { [weak self] _ in
            self?.countriesViewModel.fetchCountries() // Retry the API fetch
        }
        alertController.addAction(retryAction)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("error_ok", comment: ""), style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    func refresh() {
        countryTableView.reloadData()
    }
}
