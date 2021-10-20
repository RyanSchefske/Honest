//
//  NewReplyVC.swift
//  Honest
//
//  Created by Ryan Schefske on 3/8/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NewReplyVC: HADataLoadingVC, UITextViewDelegate, GADInterstitialDelegate {
	
	let categoryTextField = HATextField(frame: .zero)
	let contentTextView = HATextView(frame: .zero, textContainer: nil)
	var originalPostId: String!
	var userId: String!
	let profileButton = UIButton()
	let charactersRemainingLabel = HACharactersLabel()
	
	var charactersRemaining: Int = 1350 {
		didSet {
			DispatchQueue.main.async { [self] in
				self.charactersRemainingLabel.text = "\(self.charactersRemaining)"
				if self.charactersRemaining >= 0 { self.charactersRemainingLabel.textColor = .secondaryLabel }
				else { self.charactersRemainingLabel.textColor = .systemRed }
			}
		}
	}
	
	var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()

		configureViewController()
		setupCustomBarButton()
		layoutConstraints()
		setupToolbar()
		interstitial = createAndLoadInterstitial()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		profileButton.isUserInteractionEnabled = true
		runAnimations()
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
		contentTextView.delegate = self
		
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
		view.addSubviews(categoryTextField, contentTextView, charactersRemainingLabel)
		
		charactersRemainingLabel.text = "\(charactersRemaining)"
		
		NSLayoutConstraint.activate([
			categoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
			categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
			categoryTextField.heightAnchor.constraint(equalToConstant: 40),
			
			contentTextView.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 15),
			contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
			contentTextView.heightAnchor.constraint(equalToConstant: view.frame.height / 3),
			
			charactersRemainingLabel.bottomAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 0),
			charactersRemainingLabel.trailingAnchor.constraint(equalTo: contentTextView.trailingAnchor, constant: -10)
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
		
		defer {
			dismissLoadingView()
			profileButton.isUserInteractionEnabled = true
		}
		
		if contentTextView.text.isEmpty {
			profileButton.shake()
			contentTextView.shake()
		} else {
			guard charactersRemaining <= 1350 else {
				contentTextView.shake()
				return
			}
			
			if interstitial.isReady && !PersistenceManager.shared.fetchAdFreeVersion() {
				interstitial.present(fromRootViewController: self)
			}
			
			let content = ProfanityFilter.cleanUp(contentTextView.text)
			NetworkManager.shared.postReply(origPostId: originalPostId, content: content) { (result) in
				switch result {
				case .success:
					NotificationCenter.default.post(name: .didPostReply, object: nil)
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
	
	func runAnimations() {
		categoryTextField.animate()
		contentTextView.animate()
		
		profileButton.alpha = 0
		charactersRemainingLabel.alpha = 0
		UIView.animate(withDuration: 1) {
			self.profileButton.alpha = 1
		} completion: { completed in
			UIView.animate(withDuration: 1) {
				self.charactersRemainingLabel.alpha = 1
			}
		}
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
		let numberOfChars = newText.count
		charactersRemaining = 1350 - numberOfChars
		return numberOfChars < 1350
	}
}
