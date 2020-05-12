//
//  FilterCell.swift
//  Honest
//
//  Created by Ryan Schefske on 5/9/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
	
	static let reuseID = "filterCell"
	let colors: [UIColor] = [.blue, .red, .cyan, .green]
	
	let filterName = HATitleLabel(textAlignment: .left, fontSize: 22)
	let symbolImage = UIImageView()
    
	override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	private func configure() {
		backgroundColor = Colors.customBlue
		layer.cornerRadius = 10
		
		addSubviews(filterName, symbolImage)
		
		symbolImage.translatesAutoresizingMaskIntoConstraints = false
		symbolImage.contentMode = .scaleAspectFit
		symbolImage.tintColor = .label
		
		NSLayoutConstraint.activate([
			filterName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
			filterName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
			filterName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
			filterName.heightAnchor.constraint(equalToConstant: 26),
			
			symbolImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
			symbolImage.bottomAnchor.constraint(equalTo: filterName.topAnchor, constant: -10),
			symbolImage.heightAnchor.constraint(equalToConstant: 55),
			symbolImage.widthAnchor.constraint(equalToConstant: 55)
		])
	}
}
