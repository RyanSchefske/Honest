//
//  UIViewController+Ext.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentHAAlertOnMainThread(title: String, message: String, buttonText: String) {
        DispatchQueue.main.async {
            let alertVC = HAAlertVC(title: title, message: message, buttonText: buttonText)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
	
	func presentAdFreeAlert() {
		DispatchQueue.main.async {
			let adFreeAlert = HAAdFreeVC(title: "Ad Free!", message: "Try out the ad free version of Honest!")
			adFreeAlert.modalPresentationStyle = .overFullScreen
			adFreeAlert.modalTransitionStyle = .crossDissolve
			self.present(adFreeAlert, animated: true)
		}
	}
}
