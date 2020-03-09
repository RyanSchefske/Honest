//
//  NewReplyVC.swift
//  Honest
//
//  Created by Ryan Schefske on 3/8/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class NewReplyVC: HADataLoadingVC {
	
	let categoryTextField = HATextField(frame: .zero)
	let contentTextView = HATextView(frame: .zero, textContainer: nil)
	var originalPostId: String!

    override func viewDidLoad() {
        super.viewDidLoad()

		configureViewController()
		setupCustomBarButton()
		layoutConstraints()
		setupToolbar()
    }
	
	init(origPostId: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.originalPostId = origPostId
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
		let profileButton = UIButton()
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
		
		//TODO: Animations for failed cases
		if contentTextView.text.isEmpty {
			contentTextView.layer.borderColor = UIColor.red.cgColor
		} else {
			let content = ProfanityFilter.cleanUp(contentTextView.text)
			contentTextView.layer.borderColor = UIColor.lightGray.cgColor
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
}