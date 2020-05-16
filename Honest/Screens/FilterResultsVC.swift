//
//  FilterResultsVC.swift
//  Honest
//
//  Created by Ryan Schefske on 5/13/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleMobileAds

class FilterResultsVC: HADataLoadingVC {
	
	enum Section { case main }
    
    var collectionView: UICollectionView!
	var refresher = UIRefreshControl()
	
	var filter = ""
	var isLoadingPosts = false
	var morePostsAvailable = true
	var signInNeeded = false
	weak var replyDelegate: ReplyDelegate!
	
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
		getPosts(date: Date())
		configurePullToRefresh()
		configureBannerView()
    }

    private func configureViewController() {
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
		title = filter
		replyDelegate = self
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createCVFlowLayout(in: self.view))
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
		
        view.addSubview(collectionView)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.delegate = self
		collectionView.dataSource = self
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseID)
		collectionView.register(NativeAdCell.self, forCellWithReuseIdentifier: NativeAdCell.reuseID)
    }
	
	func getPosts(date: Date) {
		showLoadingView()
		isLoadingPosts = true
		
		let newDate = date.addingTimeInterval(-1 * 60)
		
		NetworkManager.shared.getFilteredPosts(date: newDate, filter: filter) { [weak self] (result) in
			guard let self = self else { return }
			self.dismissLoadingView()
			
			switch result {
			case .success(let posts):
				if posts.count > 10 { self.morePostsAvailable = false }
				self.posts.append(contentsOf: posts)
			case .failure(let error):
				self.presentHAAlertOnMainThread(title: "Error", message: error.rawValue, buttonText: "Okay")
			}
			self.isLoadingPosts = false
		}
	}
	
	private func configurePullToRefresh() {
		refresher = UIRefreshControl()
        collectionView.alwaysBounceVertical = true
		refresher.tintColor = Colors.customBlue
        refresher.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        collectionView!.addSubview(refresher)
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
	
	@objc func reloadData() {
        posts = []
        self.collectionView.reloadData()
        getPosts(date: Date())
        self.refresher.endRefreshing()
    }
	
	func removeBlockedHiddenContent() {
		let blockedUsers = PersistenceManager().fetchBlockedUsers()
		let hiddenPosts = PersistenceManager().fetchHiddenPosts()
		
		posts = posts.filter { !blockedUsers.contains($0.userId) }
		posts = posts.filter { !hiddenPosts.contains($0.postId) }
	}
	
	@objc func filterTapped() {
		navigationController?.pushViewController(FilterVC(), animated: true)
	}
}

extension FilterResultsVC: UICollectionViewDelegate, UICollectionViewDataSource {
	
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
	
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard morePostsAvailable, !isLoadingPosts else { return }
			getPosts(date: self.posts.last!.date)
        }
    }
}

extension FilterResultsVC: GADBannerViewDelegate {
	func adViewDidReceiveAd(_ bannerView: GADBannerView) {
		self.bannerView.alpha = 0
		UIView.animate(withDuration: 1) {
			self.bannerView.alpha = 1
		}
	}
}
