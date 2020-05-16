//
//  ProfileVC.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ProfileVC: HADataLoadingVC {
	
	var collectionView: UICollectionView!
	var refresher = UIRefreshControl()
	var emptyStateLabel = UILabel()
	var bannerView: GADBannerView!
	
	var posts: [Post] = [] {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
		configureCollectionView()
		getUserPosts()
		configurePullToRefresh()
		configureBannerView()
    }
    
    private func configureViewController() {
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.settings, style: .plain, target: self, action: #selector(settingsClicked))
    }
	
	private func configureCollectionView() {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createCVFlowLayout(in: self.view))
		collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
		
		view.addSubview(collectionView)
		collectionView.backgroundColor = .secondarySystemBackground
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseID)
	}
	
	func getUserPosts() {
		showLoadingView()
		
		NetworkManager.shared.getUserPosts() { [weak self] (result) in
			guard let self = self else { return }
			self.dismissLoadingView()
			
			switch result {
			case .success(let posts):
				self.posts.append(contentsOf: posts)
			case .failure(let error):
				self.presentHAAlertOnMainThread(title: "Error", message: error.rawValue, buttonText: "Okay")
			}
		}
	}
	
	private func configurePullToRefresh() {
		refresher = UIRefreshControl()
        collectionView.alwaysBounceVertical = true
		refresher.tintColor = Colors.customBlue
        refresher.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        collectionView!.addSubview(refresher)
	}
	
	@objc func reloadData() {
        posts = []
        self.collectionView.reloadData()
        getUserPosts()
        self.refresher.endRefreshing()
    }
	
	@objc func settingsClicked() {
		navigationController?.pushViewController(SettingsVC(), animated: true)
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

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
	
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts.count
    }
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseID, for: indexPath) as! PostCell
		cell.set(post: posts[indexPath.item], delegate: self)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let selectedPost = self.posts[indexPath.item]
		let detailVC = DetailVC(post: selectedPost)
		navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ProfileVC: GADBannerViewDelegate {
	func adViewDidReceiveAd(_ bannerView: GADBannerView) {
		self.bannerView.alpha = 0
		UIView.animate(withDuration: 1) {
			self.bannerView.alpha = 1
		}
	}
}
