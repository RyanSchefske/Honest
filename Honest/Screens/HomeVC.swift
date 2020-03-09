//
//  ViewController.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeVC: HADataLoadingVC {
	
	enum Section { case main }
    
    var collectionView: UICollectionView!
	var refresher = UIRefreshControl()
	
	var isLoadingPosts = false
	var morePostsAvailable = true
	var signInNeeded = false
	weak var replyDelegate: ReplyDelegate!
	
	var posts: [Post] = [] {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		        
		//try! Auth.auth().signOut()
        configureViewController()
        configureCollectionView()
		configurePullToRefresh()
		checkSignedIn()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if Auth.auth().currentUser != nil {
			if signInNeeded {
				getPosts(date: Date())
				signInNeeded = false
			}
		}
	}
	
	private func checkSignedIn() {
		if Auth.auth().currentUser == nil {
			signInNeeded = true
			self.navigationController?.pushViewController(SignInVC(), animated: true)
		} else {
			getPosts(date: Date())
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
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
		collectionView.dataSource = self
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseID)
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
}

