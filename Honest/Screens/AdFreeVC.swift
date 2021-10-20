//
//  AdFreeVC.swift
//  Honest
//
//  Created by Ryan Schefske on 7/27/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import StoreKit

class AdFreeVC: HADataLoadingVC {
	
	var didClickAlert: Bool = false
	var productsArray: [SKProduct?] = []

    override func viewDidLoad() {
        super.viewDidLoad()

		configure()
		configureView()
		
		showLoadingView()
		IAPHandler.shared.setProductIds(ids: ["com.ryanschefske.Honest.adfree"])
		IAPHandler.shared.fetchAvailableProducts { [weak self] (products) in
			guard let self = self else { return }
			self.productsArray = products
			self.dismissLoadingView()
			
			if self.didClickAlert {
				self.buyIAP()
			}
		}
    }
	
	private func configure() {
		view.backgroundColor = .secondarySystemBackground
	}
	
	private func configureView() {
		let titleLabel: UILabel = {
			let lbl = UILabel()
			lbl.translatesAutoresizingMaskIntoConstraints = false
			lbl.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
			lbl.text = "Remove Ads!"
			lbl.textAlignment = .center
			return lbl
		}()
		
		let messageLabel: UILabel = {
			let lbl = UILabel()
			lbl.translatesAutoresizingMaskIntoConstraints = false
			lbl.numberOfLines = 0
			lbl.text = "Get rid of those annoying ads. Upgrade to Honest - Ad Free today!"
			lbl.textAlignment = .center
			return lbl
		}()
		
		let promotionImage: UIImageView = {
			let iv = UIImageView()
			iv.translatesAutoresizingMaskIntoConstraints = false
			iv.image = UIImage(named: "adFree")
			iv.contentMode = .scaleAspectFit
			return iv
		}()
		
		let purchaseButton: UIButton = {
			let btn = UIButton()
			btn.translatesAutoresizingMaskIntoConstraints = false
			btn.setTitle("Buy now!", for: .normal)
			btn.setTitleColor(.white, for: .normal)
			btn.addTarget(self, action: #selector(buyIAP), for: .touchUpInside)
			btn.backgroundColor = Colors.customBlue
			btn.layer.cornerRadius = 10
			btn.layer.shadowColor = UIColor.lightGray.cgColor
			btn.layer.shadowRadius = 10
			return btn
		}()
		
		let restoreButton: UIButton = {
			let btn = UIButton()
			btn.translatesAutoresizingMaskIntoConstraints = false
			
			let attrs: [NSAttributedString.Key : Any] = [
				.font : UIFont.systemFont(ofSize: 15.0),
				.foregroundColor : UIColor.lightGray,
				.underlineStyle : 1]
			let buttonTitleStr = NSMutableAttributedString(string: "Already Purchased? Restore now", attributes: attrs)
			btn.setAttributedTitle(buttonTitleStr, for: .normal)
			
			btn.addTarget(self, action: #selector(restoreIAP), for: .touchUpInside)
			return btn
		}()
		
		view.addSubviews(titleLabel, messageLabel, promotionImage, purchaseButton, restoreButton)
		
		NSLayoutConstraint.activate([
			restoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
			restoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			restoreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			restoreButton.heightAnchor.constraint(equalToConstant: 20),
			
			purchaseButton.bottomAnchor.constraint(equalTo: restoreButton.topAnchor, constant: -15),
			purchaseButton.leadingAnchor.constraint(equalTo: restoreButton.leadingAnchor),
			purchaseButton.trailingAnchor.constraint(equalTo: restoreButton.trailingAnchor),
			purchaseButton.heightAnchor.constraint(equalToConstant: 45),
			
			titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
			titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			titleLabel.heightAnchor.constraint(equalToConstant: 50),
			
			messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
			messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			messageLabel.heightAnchor.constraint(equalToConstant: 55),
			
			promotionImage.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 15),
			promotionImage.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -15),
			promotionImage.leadingAnchor.constraint(equalTo: restoreButton.leadingAnchor),
			promotionImage.trailingAnchor.constraint(equalTo: restoreButton.trailingAnchor)
		])
	}
	
	@objc func buyIAP() {
		guard let product = productsArray[0] else { return }
		
		if !PersistenceManager.shared.fetchAdFreeVersion() {
			IAPHandler.shared.purchase(product: product) { (alert, product, transaction) in
				print(alert.message)
			}
		} else {
			let alertController = UIAlertController(title: "Oops!", message: "You're already a pro member!", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alertController, animated: true, completion: nil)
		}
	}
	
	@objc func restoreIAP() {
		if !PersistenceManager.shared.fetchAdFreeVersion() {
			IAPHandler.shared.restorePurchase()
		} else {
			let alertController = UIAlertController(title: "Oops!", message: "You're already a pro member!", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alertController, animated: true, completion: nil)
		}
	}
}
