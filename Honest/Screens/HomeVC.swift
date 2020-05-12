//
//  ViewController.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleMobileAds

class HomeVC: HADataLoadingVC, GADUnifiedNativeAdLoaderDelegate {
	
	enum Section { case main }
    
    var collectionView: UICollectionView!
	var refresher = UIRefreshControl()
	
	var isLoadingPosts = false
	var morePostsAvailable = true
	var signInNeeded = false
	weak var replyDelegate: ReplyDelegate!
	
	var nativeAdView = GADUnifiedNativeAdView()
	var adLoader = GADAdLoader()
	
	var ads: [GADUnifiedNativeAd] = [] {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
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
		configurePullToRefresh()
		checkSignedIn()
		checkFirstLaunch()
		setupCustomBarButton()
		getAds()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if Auth.auth().currentUser != nil {
			NetworkManager.shared.updateToken()
			
			if signInNeeded {
				getPosts(date: Date())
				signInNeeded = false
			}
		} else {
			checkSignedIn()
		}
	}
	
	private func setupCustomBarButton() {
		let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
		rightBarButton.setImage(UIImage(named: "filter"), for: .normal)
		rightBarButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
		rightBarButton.tintColor = Colors.customBlue
		
		let menuButton = UIBarButtonItem(customView: rightBarButton)
		menuButton.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
		menuButton.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
		self.navigationItem.rightBarButtonItem = menuButton
	}
	
	private func checkSignedIn() {
		if Auth.auth().currentUser == nil {
			signInNeeded = true
			self.navigationController?.pushViewController(SignInVC(), animated: true)
		} else {
			getPosts(date: Date())
		}
	}
	
	private func checkFirstLaunch() {
		let launchedBefore = UserDefaults.standard.bool(forKey: "LaunchedBefore")
        if !launchedBefore  {
            presentHAAlertOnMainThread(title: "Terms of Use", message: "By using this app, you agree to the terms of use found in the app settings and on the company website.", buttonText: "Agree")
            UserDefaults.standard.set(true, forKey: "LaunchedBefore")
        }
	}

    private func configureViewController() {
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
		replyDelegate = self
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createCVFlowLayout(in: self.view))
        
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
		
		NetworkManager.shared.getPosts(date: newDate) { [weak self] (result) in
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
	
	func getAds() {
		let options = GADMultipleAdsAdLoaderOptions()
		options.numberOfAds = 5
        adLoader = GADAdLoader(adUnitID: "ca-app-pub-2392719817363402/4186174365",
            rootViewController: self,
            adTypes: [ GADAdLoaderAdType.unifiedNative ],
            options: [options])
        adLoader.delegate = self
		adLoader.load(GADRequest())
	}
	
	func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
		ads.append(nativeAd)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("Error: \(error)")
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
	
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts.count + ads.count
    }
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.item % 5 == 0 && ads.count > indexPath.item / 5 {
			let cellIndex = indexPath.item / 5
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NativeAdCell.reuseID, for: indexPath) as! NativeAdCell
			let ad = ads[cellIndex]
			cell.set(ad: ad)
			ad.rootViewController = self
			
			return cell
		} else if indexPath.item % 5 == 0 || (indexPath.item * 4 / 5) > posts.count - 1 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NativeAdCell.reuseID, for: indexPath) as! NativeAdCell
			return cell
		} else {
			let cellIndex = indexPath.item * 4 / 5
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseID, for: indexPath) as! PostCell
			cell.set(post: posts[cellIndex], delegate: self)
			return cell
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.item % 5 == 0 && ads.count > indexPath.item / 5 {
		} else if indexPath.item % 5 == 0 || (indexPath.item * 4 / 5) > posts.count - 1 {
		} else {
			let cellIndex = indexPath.item * 4 / 5
			let selectedPost = self.posts[cellIndex]
			let detailVC = DetailVC(post: selectedPost)
			navigationController?.pushViewController(detailVC, animated: true)
		}
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

