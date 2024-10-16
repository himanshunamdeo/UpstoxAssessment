//
//  CryptoCoinsListViewController.swift
//  CryptoCoins
//
//  Created by MeTaLlOiD on 15/10/24.
//

import Foundation
import UIKit

class CryptoCoinsListViewController: UIViewController {
    
    private var cryptoTableView: UITableView = UITableView()
    private var viewModel: CryptoCoinsListViewViewModel
    private var searchBar: UISearchBar = UISearchBar()
    private var navigationTitleView: UILabel = {
            let label = UILabel()
        label.text = "COIN"
        label.textColor = .white
        label.textAlignment = .center
        return label
    } ()
    
    init(viewModel: CryptoCoinsListViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = .systemGray6
        setupNavigationBar()
        setupMainStackView()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await fetchCryptoData()
            cryptoTableView.reloadData()
        }
        
    }
    // MARK: - UI Setup
    // Initialize the navigation bar's properties and UI elements
    private func setupNavigationBar() {
        
        
        navigationItem.titleView = navigationTitleView
        
        // Search Button Item setup
        let searchButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        searchButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = searchButtonItem
        
        // Navigation Bar background color
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor.systemIndigo
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            
        }
    }
    
    private func setupMainStackView() {
        
        setupTableView()
        
        let filterView = setupFilterView()
        
        let stackView = UIStackView(arrangedSubviews: [cryptoTableView, filterView])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        // Add constraints with the super view
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        filterView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    private func setupTableView() {
        
        cryptoTableView.dataSource = self
        cryptoTableView.delegate = self
        cryptoTableView.register(CryptoCoinsTableViewCell.self, forCellReuseIdentifier: "CryptoCoinsTableViewCell")
        cryptoTableView.backgroundColor = .clear
        cryptoTableView.separatorStyle = .none
    }
    
    private func setupFilterView() -> UIView {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        let filterView = FilterView()
        filterView.delegate = self
        filterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterView)
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            filterView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    
        return view
    }
    
    private func setupSearchBar() {
        
        searchBar.placeholder = "Search..."
        searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        searchBar.delegate = self
        searchBar.alpha = 0
        customizeSearchBarAppearance()
        
    }
    
    private func customizeSearchBarAppearance() {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = UIColor.systemBlue
            textField.backgroundColor = .white
            textField.textColor = .black
        }
    }
    
    // MARK: - Action Methods
    @objc private func searchButtonTapped() {
        
        if searchBar.alpha == 0 {
            navigationItem.titleView = searchBar
            searchBar.alpha = 1
        } else {
            searchBar.alpha = 0
            navigationItem.titleView = navigationTitleView
        }
    }
    
    
}

// MARK: - Network call
extension CryptoCoinsListViewController {
    
    func fetchCryptoData() async {
        do {
            try await viewModel.fetchCryptoData()
        } catch {
            showFloatingPopup(title: "Error", message: error.localizedDescription)
        }
        
    }
}

// MARK: - Table view delegate methods
extension CryptoCoinsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//MARK: - Table View data source methods
extension CryptoCoinsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cryptoDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCoinsTableViewCell") as? CryptoCoinsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.updateCell(with: CryptoCoinsTableViewCellViewModel(cryptoDetail: viewModel.cryptoDetailsArray[indexPath.row]))
                        
        return cell
        
    }
}

// MARK: - Filter view delegate methods
extension CryptoCoinsListViewController: FilterViewDelegate {
    
    func didSelectedFilters(filters: [FilterType]) {
        viewModel.filterCryptoArray(with: filters)
        cryptoTableView.reloadData()
    }
}

// MARK: - Search Bar delegate methods
extension CryptoCoinsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCryptoArray(with: searchText)
        cryptoTableView.reloadData()
    }
}
