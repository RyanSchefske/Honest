//
//  ReportActionSheet.swift
//  Honest
//
//  Created by Ryan Schefske on 3/11/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import FirebaseAuth

extension HomeVC: ReplyDelegate {
	func didTapReport(origPost: Post, sender: UIButton) {
		if Auth.auth().currentUser!.uid == origPost.userId {
			self.presentHAAlertOnMainThread(title: "Error", message: HAError.unableToReport.rawValue, buttonText: "Okay")
		} else {
			Alert.showAlert(on: self, for: origPost, sender: sender) { (action) in
				switch action {
				case true:
					self.removeBlockedHiddenContent()
				case false:
					print("Do nothing")
				}
			}
		}
	}
	
	func didTapReply(origPostId: String, userId: String) {
		navigationController?.pushViewController(NewReplyVC(origPostId: origPostId, userId: userId), animated: true)
	}
}

extension FilterResultsVC: ReplyDelegate {
	func didTapReport(origPost: Post, sender: UIButton) {
		if Auth.auth().currentUser!.uid == origPost.userId {
			self.presentHAAlertOnMainThread(title: "Error", message: HAError.unableToReport.rawValue, buttonText: "Okay")
		} else {
			Alert.showAlert(on: self, for: origPost, sender: sender) { (action) in
				switch action {
				case true:
					self.removeBlockedHiddenContent()
				case false:
					print("Do nothing")
				}
			}
		}
	}
	
	func didTapReply(origPostId: String, userId: String) {
		navigationController?.pushViewController(NewReplyVC(origPostId: origPostId, userId: userId), animated: true)
	}
}

extension DetailVC: ReplyDelegate {
	func didTapReport(origPost: Post, sender: UIButton) {
		if Auth.auth().currentUser!.uid == origPost.userId {
			self.presentHAAlertOnMainThread(title: "Error", message: HAError.unableToReport.rawValue, buttonText: "Okay")
		} else {
			Alert.showAlert(on: self, for: origPost, sender: sender) { (action) in
				switch action {
				case true:
					self.navigationController?.popViewController(animated: true)
				case false:
					print("Do nothing")
				}
			}
		}
	}
	
	func didTapReply(origPostId: String, userId: String) {
		navigationController?.pushViewController(NewReplyVC(origPostId: origPostId, userId: userId), animated: true)
	}
}

extension ProfileVC: ReplyDelegate {
	func didTapReport(origPost: Post, sender: UIButton) {
		Alert.showDeleteAlert(on: self, for: origPost.postId, sender: sender) { (action) in
			switch action {
			case true:
				self.reloadData()
			case false:
				print("Do Nothing")
			}
		}
	}
	
	func didTapReply(origPostId: String, userId: String) {
		navigationController?.pushViewController(NewReplyVC(origPostId: origPostId, userId: userId), animated: true)
	}
}
