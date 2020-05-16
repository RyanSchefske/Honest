//
//  NewReplyVC.swift
//  Honest
//
//  Created by Ryan Schefske on 3/8/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NewReplyVC: HADataLoadingVC, GADInterstitialDelegate {
	
	let categoryTextField = HATextField(frame: .zero)
	let contentTextView = HATextView(frame: .zero, textContainer: nil)
	var originalPostId: String!
	var userId: String!
	let profileButton = UIButton()
	
	var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()

		configureViewController()
		setupCustomBarButton()
		layoutConstraints()
		setupToolbar()
		interstitial = createAndLoadInterstitial()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		profileButton.isUserInteractionEnabled = true
	}
	
	init(origPostId: String, userId: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.originalPostId = origPostId
		self.userId = userId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	private func configureViewController() {
		title = "New Reply"
		view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
		
		categoryTextField.isUserInteractionEnabled = false
		categoryTextField.text = "Reply"
	}
	
	private func setupCustomBarButton() {
		profileButton.frame = CGRect(x: 0, y: 0, width: 65, height: 30)
		profileButton.setTitle("Post", for: .normal)
		profileButton.backgroundColor = Colors.customBlue
		profileButton.layer.cornerRadius = 15
		profileButton.addTarget(self, action: #selector(postReply), for: .touchUpInside)

		let rightBarButton = UIBarButtonItem(customView: profileButton)
		self.navigationItem.rightBarButtonItem = rightBarButton
	}
	
	@objc func dismissKeyboard() { view.endEditing(true) }
	
	func layoutConstraints() {
		view.addSubviews(categoryTextField, contentTextView)
		
		NSLayoutConstraint.activate([
			categoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
			categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
			categoryTextField.heightAnchor.constraint(equalToConstant: 40),
			
			contentTextView.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 15),
			contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
			contentTextView.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
		])
	}
	
	func setupToolbar() {
		let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
		doneButton.tintColor = Colors.customBlue
        toolBar.setItems([doneButton], animated: false)
		toolBar.backgroundColor = .systemBackground
        toolBar.isUserInteractionEnabled = true
		contentTextView.inputAccessoryView = toolBar
	}
	
	@objc func postReply() {
		view.endEditing(true)
		showLoadingView()
		sendReplyNotification(to: userId)
		profileButton.isUserInteractionEnabled = false
		
		if contentTextView.text.isEmpty {
			dismissLoadingView()
			profileButton.shake()
			contentTextView.shake()
			profileButton.isUserInteractionEnabled = true
		} else {
			if interstitial.isReady { interstitial.present(fromRootViewController: self) }
			
			let content = ProfanityFilter.cleanUp(contentTextView.text)
			NetworkManager.shared.postReply(origPostId: originalPostId, content: content) { (result) in
				
				self.dismissLoadingView()
				
				switch result {
				case .success:
					self.navigationController?.popViewController(animated: true)
					
				case .failure(let error):
					self.presentHAAlertOnMainThread(title: "Uh-oh", message: error.rawValue, buttonText: "Okay")
				}
			}
		}
	}
	
	func createAndLoadInterstitial() -> GADInterstitial {
		let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2392719817363402/3370573728")
		interstitial.delegate = self
		interstitial.load(GADRequest())
		return interstitial
	}
	
	func interstitialDidDismissScreen(_ ad: GADInterstitial) {
		interstitial = createAndLoadInterstitial()
	}
}
