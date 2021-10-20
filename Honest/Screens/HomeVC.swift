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
import StoreKit

class HomeVC: HADataLoadingVC {
	
	enum Section { case main }
    
    var collectionView: UICollectionView!
	var refresher = UIRefreshControl()
	
	var isLoadingPosts = false
	var morePostsAvailable = true
	var signInNeeded = false
	
	var scrollOffset: CGFloat = 0
	var scrollingDown = true // Start true so initial cells animate
	
	weak var replyDelegate: ReplyDelegate!
	var bannerView = GADBannerView()
	
	var adFreeUser: Bool = false
	
	var posts: [Post] = [] {
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
		checkSignedIn()
		checkFirstLaunch()
		setupCustomBarButton()
		configureBannerView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		adFreeUser = PersistenceManager.shared.fetchAdFreeVersion()
		if adFreeUser {
			bannerView.isHidden = true
		}
		
		if PersistenceManager().shouldRequestReview() {
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
				SKStoreReviewController.requestReview()
			}
		}
		
		if PersistenceManager().shouldRequestPro() {
			presentAdFreeAlert()
		}
		
		NotificationCenter.default.addObserver(self, selector: #selector(onDidPostNew(_:)), name: .didPostNew, object: nil)
		
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
	
	@objc func onDidPostNew(_ notification: Notification) {
		reloadData()
	}
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
	
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
			cell.alpha = 0.5
			cell.transform = CGAffineTransform(translationX: 0, y: 30)

			UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
				cell.alpha = 1
				cell.transform = CGAffineTransform(translationX: 0, y: 0)
			})
		}
	}
}

extension HomeVC: GADBannerViewDelegate {
	func adViewDidReceiveAd(_ bannerView: GADBannerView) {
		self.bannerView.alpha = 0
		UIView.animate(withDuration: 1) {
			self.bannerView.alpha = 1
		}
	}
}

