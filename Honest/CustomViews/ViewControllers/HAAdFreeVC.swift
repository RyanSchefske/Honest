//
//  HAAdFreeVC.swift
//  Honest
//
//  Created by Ryan Schefske on 7/26/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class HAAdFreeVC: UIViewController {
    
    let containerView = HAAlertContainerView()
    let titleLabel = HATitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = HABodyLabel(textAlignment: .center)
    let actionButton = HAButton(backgroundColor: Colors.customBlue, title: "Purchase")
	let dismissButton = HAButton(backgroundColor: .systemGray3, title: "No, I like ads")
	var adImageView = UIImageView()
    
    var alertTitle: String?
    var message: String?
	var adFreeUser = false
    
    let padding: CGFloat = 20
    
    init(title: String, message: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.alertTitle = title
        self.message = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubviews(containerView, titleLabel, actionButton, messageLabel, dismissButton, adImageView)
        
        configureContainerView()
        configureTitleLabel()
        configureActionButtons()
        configureMessageLabel()
		configureImageView()
    }
    
    func configureContainerView() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 320)
        ])
    }
    
    func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "Something went wrong"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureActionButtons() {
        actionButton.setTitle("Purchase", for: .normal)
        actionButton.addTarget(self, action: #selector(purchaseIAP), for: .touchUpInside)
		
		dismissButton.setTitle("No, I like ads", for: .normal)
		dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
			dismissButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
			dismissButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
			dismissButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
			dismissButton.heightAnchor.constraint(equalToConstant: 30),
			
            actionButton.bottomAnchor.constraint(equalTo: dismissButton.topAnchor, constant: -10),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    func configureMessageLabel() {
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
			messageLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
	
	func configureImageView() {
		adImageView.translatesAutoresizingMaskIntoConstraints = false
		adImageView.image = UIImage(named: "adFree")
		adImageView.contentMode = .scaleAspectFit
		adImageView.layer.cornerRadius = 10
		adImageView.clipsToBounds = true
		
		NSLayoutConstraint.activate([
			adImageView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
			adImageView.leadingAnchor.constraint(equalTo: dismissButton.leadingAnchor),
			adImageView.trailingAnchor.constraint(equalTo: dismissButton.trailingAnchor),
			adImageView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -20)
		])
	}
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
	
	@objc func purchaseIAP() {
		let vc = AdFreeVC()
		vc.didClickAlert = true
		self.present(vc, animated: true, completion: nil)
	}
}

