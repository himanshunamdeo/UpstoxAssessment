//
//  FilterView.swift
//  CryptoCoins
//
//  Created by MeTaLlOiD on 15/10/24.
//

import Foundation
import UIKit

enum FilterType: CaseIterable {
    case onlyTokens
    case onlyCoins
    case newCoins
    case ActiveCoins
    case inactiveCoins
}

struct FilterOption {
    var name: String = "Default"
    var isSelected: Bool = false
}

protocol FilterViewDelegate {
    
    func didSelectedFilters(filters: [FilterType])
}

class FilterView: UIView {
    
    var selectedFilters = [FilterType]()
    
    // MARK: - UI Initialization
    let filterCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "FilterCollectionViewCell")
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
        
    } ()
    
    var delegate: FilterViewDelegate?
    var filterOptionsArray: [FilterOption] = {
        let filterStrings = ["Only Tokens", "Only Coins", "New Coins", "Active Coins", "Inactive Coins" ]
        var options = [FilterOption]()
        
        for string in filterStrings {
            var filterOption = FilterOption(name: string)
            options.append(filterOption)
        }
        
        return options
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        addSubview(filterCollectionView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            // Filter collection view is anchored with the super view with all 4 sides
            filterCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            filterCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            filterCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            filterCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
            
        ])
    }
    
    
}

extension FilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension FilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterOptionsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as? FilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let viewModel = FilterCollectionViewCellViewModel()
        viewModel.filterOption = filterOptionsArray[indexPath.row]
        cell.updateCell(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Toggle the hidden property of the Filter's imageView
        let toggle = filterOptionsArray[indexPath.row].isSelected
        filterOptionsArray[indexPath.row].isSelected = !toggle
        
        // Capture the currently selected filters
        let currentFilterType = FilterType.allCases[indexPath.row]
        if selectedFilters.contains(currentFilterType) {
            selectedFilters.removeAll { $0 == currentFilterType }
        } else {
            selectedFilters.append(currentFilterType)
        }
        
        // Send the selected filters to conforming view to filterout the list
        delegate?.didSelectedFilters(filters: selectedFilters)
        
        filterCollectionView.reloadData()
    }
    
}
