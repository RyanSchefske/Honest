//
//  DetailVC.swift
//  Honest
//
//  Created by Ryan Schefske on 3/6/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DetailVC: HADataLoadingVC {
	
	var collectionView: UICollectionView!
	var refresher = UIRefreshControl()
	var bannerView: GADBannerView!
	
	var scrollOffset: CGFloat = 0
	var scrollingDown = true
	
	var post: Post!
	var replies: [Reply] = [] {
		didSet {
			DispatchQueue.main.async {
				self.scrollingDown = true
				self.collectionView.reloadData()
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		configureViewController()
		configureCollectionView()
		configurePullToRefresh()
		getReplies(postId: post.postId)
		configureBannerView()
    }
	
	init(post: Post) {
        super.init(nibName: nil, bundle: nil)
        
        self.post = post
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	private func configureViewController() {
		title = "Details"
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
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseID)
		collectionView.register(ReplyCell.self, forCellWithReuseIdentifier: ReplyCell.reuseID)
	}
	
	func getReplies(postId: String) {
		showLoadingView()
		
		NetworkManager.shared.getReplies(for: post.postId) { [weak self] (result) in
			guard let self = self else { return }
			self.dismissLoadingView()
			
			switch result {
			case .success(let replies):
				self.replies.append(contentsOf: replies)
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
        replies = []
        self.collectionView.reloadData()
		getReplies(postId: post.postId)
        self.refresher.endRefreshing()
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

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return replies.count + 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.item == 0 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseID, for: indexPath) as! PostCell
			cell.set(post: post, delegate: self)
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReplyCell.reuseID, for: indexPath) as! ReplyCell
			cell.set(reply: replies[indexPath.item - 1])
			return cell
		}
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollOffset < scrollView.contentOffset.y {
			scrollingDown = true
		} else {
			scrollingDown = false
		}
		scrollOffset = scrollView.contentOffset.y
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if scrollingDown {
			cell.alpha = 0
			cell.transform = CGAffineTransform(translationX: collectionView.frame.width / 1.5, y: 0)
			
			UIView.animate(withDuration: 1.3, delay: 0.2 * Double(indexPath.row), options: .curveEaseInOut, animations: {
				cell.transform = .identity
				cell.alpha = 1
			})
		}
	}
}

extension DetailVC: GADBannerViewDelegate {
	func adViewDidReceiveAd(_ bannerView: GADBannerView) {
		self.bannerView.alpha = 0
		UIView.animate(withDuration: 1) {
			self.bannerView.alpha = 1
		}
	}
}
