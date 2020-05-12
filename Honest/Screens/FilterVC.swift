//
//  FilterVC.swift
//  Honest
//
//  Created by Ryan Schefske on 5/9/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {
	
	var collectionView: UICollectionView!
	let categories = ["Life", "Relationship", "Work", "School", "Sports", "Money", "Travel", "Health", "Other"]
	let symbols: [UIImage?] = [SFSymbols.lifeFilter, SFSymbols.relationshipFilter, SFSymbols.workFilter, SFSymbols.schoolFilter, SFSymbols.sportsFilter, SFSymbols.moneyFilter, SFSymbols.travelFilter, SFSymbols.healthFilter, SFSymbols.otherFilter]

    override func viewDidLoad() {
        super.viewDidLoad()

		configureViewController()
		configureCollectionView()
    }
	
	private func configureViewController() {
		title = "Filters"
		view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	private func configureCollectionView() {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createCVFlowLayout(in: self.view))
		
		view.addSubview(collectionView)
		collectionView.backgroundColor = .secondarySystemBackground
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.reuseID)
	}
}

extension FilterVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return categories.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.reuseID, for: indexPath) as! FilterCell
		
		cell.filterName.text = categories[indexPath.item]
		cell.symbolImage.image = symbols[indexPath.item]
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = collectionView.frame.width / 2 - 15
		let height = width * 1.15
		return CGSize(width: width, height: height)
	}
}
