//
//  FilterCollectionViewCell.swift
//  CryptoCoins
//
//  Created by MeTaLlOiD on 16/10/24.
//

import Foundation
import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    
    let selectionImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .black
        return imageView
        
    } ()
    
    let filterLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "Active Coins"
        label.textAlignment = .center
        return label
        
    } ()
    
    let containerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.backgroundColor = .systemGray4
        return view
        
    } ()
    
    let filterStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        setupStackView()
        setupContainerView()
        
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupStackView() {
        
        filterStackView.addArrangedSubview(selectionImageView)
        filterStackView.addArrangedSubview(filterLabel)
        
        selectionImageView.widthAnchor.constraint(equalToConstant: 11).isActive = true
    }
    
    private func setupContainerView() {
        
        containerView.addSubview(filterStackView)
        
        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            filterStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            filterStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            filterStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
    }
    
    // MARK: - Update UI
    func updateCell(with viewModel: FilterCollectionViewCellViewModel) {
        selectionImageView.isHidden = !viewModel.filterOption.isSelected
        filterLabel.text = viewModel.filterOption.name
    }
}
