//
//  ProfileVC.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import GoogleMobileAds
import LocalAuthentication

class ProfileVC: HADataLoadingVC {
	
	var collectionView: UICollectionView!
	var refresher = UIRefreshControl()
	var emptyStateLabel = UILabel()
	var bannerView = GADBannerView()
	var bgView = UIView()
	
	var scrollOffset: CGFloat = 0
	var scrollingDown: Bool = true
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
		getUserPosts()
		configurePullToRefresh()
		configureBannerView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		adFreeUser = PersistenceManager.shared.fetchAdFreeVersion()
		if PersistenceManager.shared.fetchSecureProfile() { self.authenticate() }
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
	
	@objc private func authenticate() {
		bgView = {
			let view = UIView()
			view.translatesAutoresizingMaskIntoConstraints = false
			view.backgroundColor = Colors.customBlue
			view.alpha = 0
			return view
		}()
		
		view.addSubview(bgView)
		bgView.pinToEdges(of: view)
		
		UIView.animate(withDuration: 0.25) {
			self.bgView.alpha = 1
		}
		
		let loginFailedLbl: UILabel = {
			let lbl = UILabel()
			lbl.translatesAutoresizingMaskIntoConstraints = false
			lbl.text = "Login Failed"
			lbl.textColor = .white
			lbl.textAlignment = .center
			lbl.font = UIFont.systemFont(ofSize: 24, weight: .bold)
			return lbl
		}()
		
		let loginButton: UIButton = {
			let btn = UIButton()
			btn.translatesAutoresizingMaskIntoConstraints = false
			btn.addTarget(self, action: #selector(requestBiometrics), for: .touchUpInside)
			btn.setTitle("See Profile", for: .normal)
			btn.setTitleColor(Colors.customBlue, for: .normal)
			btn.backgroundColor = .white
			btn.layer.cornerRadius = 10
			return btn
		}()
		
		bgView.addSubviews(loginFailedLbl, loginButton)
		
		NSLayoutConstraint.activate([
			loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			loginButton.heightAnchor.constraint(equalToConstant: 35),
			loginButton.widthAnchor.constraint(equalToConstant: view.frame.width / 1.5),
			
			loginFailedLbl.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -10),
			loginFailedLbl.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 10),
			loginFailedLbl.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -10),
			loginFailedLbl.heightAnchor.constraint(equalToConstant: 30)
		])
		
		requestBiometrics()
	}
	
	@objc private func requestBiometrics() {
		let context = LAContext()
		var authError: NSError?
		
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To protect your posts") { (success, error) in
				DispatchQueue.main.async {
					if success {
						UIView.animate(withDuration: 1) {
							self.bgView.alpha = 0
						}
					}
				}
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

extension ProfileVC: GADBannerViewDelegate {
	func adViewDidReceiveAd(_ bannerView: GADBannerView) {
		self.bannerView.alpha = 0
		if !adFreeUser {
			UIView.animate(withDuration: 1) {
				self.bannerView.alpha = 1
			}
		}
	}
}
