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

class NewPostVC: HADataLoadingVC, GADInterstitialDelegate {
	
	let contentTextView = HATextView(frame: .zero, textContainer: nil)
	let categoryTextField = HATextField(frame: .zero)
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
    
    private func configureViewController() {
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
		
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
        categoryTextField.inputAccessoryView = toolBar
		contentTextView.inputAccessoryView = toolBar
	}
	
	@objc func postAdvice() {
		view.endEditing(true)
        showLoadingView()
		profileButton.isUserInteractionEnabled = false
		
		if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
		
		//TODO: Animations for failed cases
		if categoryTextField.text!.isEmpty {
            categoryTextField.layer.borderColor = UIColor.red.cgColor
        } else {
            categoryTextField.layer.borderColor = UIColor.lightGray.cgColor
			guard let category = categoryTextField.text else { return }
			
			if contentTextView.text.isEmpty {
                contentTextView.layer.borderColor = UIColor.red.cgColor
            } else {
                let content = ProfanityFilter.cleanUp(contentTextView.text)
                contentTextView.layer.borderColor = UIColor.lightGray.cgColor
				NetworkManager.shared.postAdvice(content: content, category: category) { (result) in
					
					self.dismissLoadingView()
					
					switch result {
					case .success:
						self.tabBarController?.selectedIndex = 0
						
					case .failure(let error):
						self.presentHAAlertOnMainThread(title: "Uh-oh", message: error.rawValue, buttonText: "Okay")
					}
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
