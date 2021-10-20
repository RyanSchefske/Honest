//
//  AddVC.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import GoogleMobileAds

class NewPostVC: HADataLoadingVC, UITextViewDelegate, GADInterstitialDelegate {
	let contentTextView = HATextView(frame: .zero, textContainer: nil)
	let categoryTextField = HATextField(frame: .zero)
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
    
    private func configureViewController() {
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
		contentTextView.delegate = self
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
	
	private func setupCustomBarButton() {
		profileButton.frame = CGRect(x: 0, y: 0, width: 65, height: 30)
		profileButton.setTitle("Post", for: .normal)
		profileButton.backgroundColor = Colors.customBlue
		profileButton.layer.cornerRadius = 15
		profileButton.addTarget(self, action: #selector(postAdvice), for: .touchUpInside)

		let rightBarButton = UIBarButtonItem(customView: profileButton)
		self.navigationItem.rightBarButtonItem = rightBarButton
	}
	
	@objc func dismissKeyboard() { view.endEditing(true) }
	
	func layoutConstraints() {
		view.addSubview(categoryTextField)
		view.addSubview(contentTextView)
		view.addSubview(charactersRemainingLabel)
		
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
        categoryTextField.inputAccessoryView = toolBar
		contentTextView.inputAccessoryView = toolBar
	}
	
	@objc func postAdvice() {
		view.endEditing(true)
        showLoadingView()
		profileButton.isUserInteractionEnabled = false
		
		defer {
			self.dismissLoadingView()
			profileButton.isUserInteractionEnabled = true
		}
		
		if categoryTextField.text!.isEmpty {
			categoryTextField.shake()
        } else {
			guard let category = categoryTextField.text else { return }
			
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
				contentTextView.layer.borderColor = UIColor.lightGray.cgColor
				NetworkManager.shared.postAdvice(content: content, category: category) { (result) in
					switch result {
						case .success:
							self.contentTextView.text = ""
							self.categoryTextField.text = nil
							NotificationCenter.default.post(name: .didPostNew, object: nil)
							self.tabBarController?.selectedIndex = 0
							
						case .failure(let error):
							self.presentHAAlertOnMainThread(title: "Uh-oh", message: error.rawValue, buttonText: "Okay")
					}
				}
			}
		}
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
	
	func createAndLoadInterstitial() -> GADInterstitial {
		let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2392719817363402/3370573728")
		interstitial.delegate = self
		interstitial.load(GADRequest())
		return interstitial
	}
	
	func interstitialDidDismissScreen(_ ad: GADInterstitial) {
		interstitial = createAndLoadInterstitial()
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
		let numberOfChars = newText.count
		charactersRemaining = 1350 - numberOfChars
		return numberOfChars < 1350
	}
}
 
