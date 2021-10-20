//
//  FilterVC.swift
//  Honest
//
//  Created by Ryan Schefske on 5/9/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FilterVC: UIViewController {
	
	var animatedOnce = false
	var adFreeUser: Bool = false
	var bannerView = GADBannerView()
	var collectionView: UICollectionView!
	let categories = ["Life", "Relationship", "Friendship", "For the Girls", "For the Boys", "Beauty", "Work", "Adulting", "School", "Sports", "Money", "Travel", "Health", "Mental Health", "Other"]
	let symbols: [UIImage?] = [FilterImages.lifeFilter, FilterImages.relationshipFilter, FilterImages.friendship, FilterImages.female, FilterImages.male, FilterImages.beauty, FilterImages.workFilter, FilterImages.adulting, FilterImages.schoolFilter, FilterImages.sportsFilter, FilterImages.moneyFilter, FilterImages.travelFilter, FilterImages.healthFilter, FilterImages.mentalHealth, FilterImages.otherFilter]

    override func viewDidLoad() {
        super.viewDidLoad()

		configureViewController()
		configureCollectionView()
		configureBannerView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		adFreeUser = PersistenceManager.shared.fetchAdFreeVersion()
		if adFreeUser { bannerView.isHidden = true }
	}
	
	private func configureViewController() {
		title = "Filters"
		view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	private func configureCollectionView() {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createCVFlowLayout(in: self.view))
		collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
		
		view.addSubview(collectionView)
		collectionView.backgroundColor = .secondarySystemBackground
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.reuseID)
	}
	
	private func configureBannerView() {
		bannerView = GADBannerView(adSize: kGADAdSizeBanner)
		bannerView.translatesAutoresizingMaskIntoConstraints = false
		bannerView.adUnitID = "ca-app-pub-2392719817363402/9066254542"
		bannerView.rootViewController = self
		bannerView.delegate = self
		bannerView.load(GADRequest())
		view.addSubview(bannerView)
		
		NSLayoutConstraint.activate([
			bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
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
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let filter = categories[indexPath.item]
		let vc = FilterResultsVC()
		vc.filter = filter
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		
		if !animatedOnce {
			cell.alpha = 0
			cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
			
			UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				cell.alpha = 1
				cell.transform = CGAffineTransform(scaleX: 1, y: 1)
			}, completion: { (completed) in
				self.animatedOnce = true
			})
		}
	}
}

extension FilterVC: GADBannerViewDelegate {
	func adViewDidReceiveAd(_ bannerView: GADBannerView) {
		self.bannerView.alpha = 0
		UIView.animate(withDuration: 1) {
			self.bannerView.alpha = 1
		}
	}
}
