//
//  TipVC.swift
//  Honest
//
//  Created by Ryan Schefske on 8/17/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import StoreKit

class TipVC: HADataLoadingVC {
	
	var productsArray: [SKProduct?] = []
	
	var messageLabel = HABodyLabel()
	var smallTipLabel = HABodyLabel()
	var mediumTipLabel = HABodyLabel()
	var bigTipLabel = HABodyLabel()
	var hugeTipLabel = HABodyLabel()
	
	var smallTipButton = HAButton()
	var mediumTipButton = HAButton()
	var bigTipButton = HAButton()
	var hugeTipButton = HAButton()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		configure()
		configureView()
		
		showLoadingView()
		IAPHandler.shared.setProductIds(ids: ["com.ryanschefske.Honest.SmallTip", "com.ryanschefske.Honest.MediumTip", "com.ryanschefske.Honest.BigTip", "com.ryanschefske.Honest.HugeTip"])
		IAPHandler.shared.fetchAvailableProducts { [weak self] (products) in
			guard let self = self else { return }
			self.productsArray = products
			self.dismissLoadingView()
		}
    }
    
	private func configure() {
		title = "Leave Tip"
		view.backgroundColor = .secondarySystemBackground
	}
	
	private func configureView() {
		messageLabel.text = TipHelper.thankYou
		smallTipLabel.text = "Small Tip 😊"
		mediumTipLabel.text = "Medium Tip 🤗"
		bigTipLabel.text = "Big Tip 😯"
		hugeTipLabel.text = "Huge Tip 😳"
		
		smallTipLabel.textAlignment = .center
		mediumTipLabel.textAlignment = .center
		bigTipLabel.textAlignment = .center
		hugeTipLabel.textAlignment = .center
		
		smallTipButton.set(backgroundColor: Colors.customBlue, title: "$0.99")
		mediumTipButton.set(backgroundColor: Colors.customBlue, title: "$2.99")
		bigTipButton.set(backgroundColor: Colors.customBlue, title: "$6.99")
		hugeTipButton.set(backgroundColor: Colors.customBlue, title: "$10.99")
		
		smallTipButton.addTarget(self, action: #selector(smallTipClicked), for: .touchUpInside)
		mediumTipButton.addTarget(self, action: #selector(mediumTipClicked), for: .touchUpInside)
		bigTipButton.addTarget(self, action: #selector(bigTipClicked), for: .touchUpInside)
		hugeTipButton.addTarget(self, action: #selector(hugeTipClicked), for: .touchUpInside)
		
		view.addSubviews(messageLabel, smallTipLabel, smallTipButton, mediumTipLabel, mediumTipButton, bigTipLabel, bigTipButton, hugeTipLabel, hugeTipButton)
		
		NSLayoutConstraint.activate([
			messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
			messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			messageLabel.heightAnchor.constraint(equalToConstant: view.frame.height / 2.75),
			
			smallTipLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
			smallTipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			smallTipLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
			smallTipLabel.heightAnchor.constraint(equalToConstant: 25),
			
			smallTipButton.leadingAnchor.constraint(equalTo: smallTipLabel.trailingAnchor, constant: 10),
			smallTipButton.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
			smallTipButton.heightAnchor.constraint(equalToConstant: 30),
			smallTipButton.centerYAnchor.constraint(equalTo: smallTipLabel.centerYAnchor),
			
			mediumTipLabel.topAnchor.constraint(equalTo: smallTipLabel.bottomAnchor, constant: 20),
			mediumTipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			mediumTipLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
			mediumTipLabel.heightAnchor.constraint(equalToConstant: 25),
			
			mediumTipButton.leadingAnchor.constraint(equalTo: mediumTipLabel.trailingAnchor, constant: 10),
			mediumTipButton.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
			mediumTipButton.heightAnchor.constraint(equalToConstant: 30),
			mediumTipButton.centerYAnchor.constraint(equalTo: mediumTipLabel.centerYAnchor),
			
			bigTipLabel.topAnchor.constraint(equalTo: mediumTipLabel.bottomAnchor, constant: 20),
			bigTipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			bigTipLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
			bigTipLabel.heightAnchor.constraint(equalToConstant: 25),
			
			bigTipButton.leadingAnchor.constraint(equalTo: bigTipLabel.trailingAnchor, constant: 10),
			bigTipButton.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
			bigTipButton.heightAnchor.constraint(equalToConstant: 30),
			bigTipButton.centerYAnchor.constraint(equalTo: bigTipLabel.centerYAnchor),
			
			hugeTipLabel.topAnchor.constraint(equalTo: bigTipLabel.bottomAnchor, constant: 20),
			hugeTipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			hugeTipLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
			hugeTipLabel.heightAnchor.constraint(equalToConstant: 25),
			
			hugeTipButton.leadingAnchor.constraint(equalTo: hugeTipLabel.trailingAnchor, constant: 10),
			hugeTipButton.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
			hugeTipButton.heightAnchor.constraint(equalToConstant: 30),
			hugeTipButton.centerYAnchor.constraint(equalTo: hugeTipLabel.centerYAnchor),
		])
	}
	
	@objc func smallTipClicked() {
		guard let product = productsArray.first(where: { $0?.productIdentifier == "com.ryanschefske.Honest.SmallTip" }) else { return }

		IAPHandler.shared.purchase(product: product!) { (alert, product, transaction) in
			print(alert.message)
		}
	}
	
	@objc func mediumTipClicked() {
		guard let product = productsArray.first(where: { $0?.productIdentifier == "com.ryanschefske.Honest.MediumTip" }) else { return }
		
		IAPHandler.shared.purchase(product: product!) { (alert, product, transaction) in
			print(alert.message)
		}
	}
	
	@objc func bigTipClicked() {
		guard let product = productsArray.first(where: { $0?.productIdentifier == "com.ryanschefske.Honest.BigTip" }) else { return }
		
		IAPHandler.shared.purchase(product: product!) { (alert, product, transaction) in
			print(alert.message)
		}
	}
	
	@objc func hugeTipClicked() {
		guard let product = productsArray.first(where: { $0?.productIdentifier == "com.ryanschefske.Honest.HugeTip" }) else { return }
		
		IAPHandler.shared.purchase(product: product!) { (alert, product, transaction) in
			print(alert.message)
		}
	}
}
