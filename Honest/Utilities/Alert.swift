//
//  Alert.swift
//  Honest
//
//  Created by Ryan Schefske on 3/11/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

struct Alert {
	static func showAlert(on vc: UIViewController, for post: Post, sender: UIButton, completed: @escaping (Bool) -> Void) {
		let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
		
		alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (action) in
			NetworkManager.shared.updateReports(for: post.postId)
			completed(true)
		}))
		
		alert.addAction(UIAlertAction(title: "Hide Post", style: .destructive, handler: { (action) in
			let hideAlert = UIAlertController(title: "Hide Post", message: "Are you sure you want to hide this post? You will never be able to see this post again", preferredStyle: .alert)
			
            hideAlert.addAction(UIAlertAction(title: "Hide", style: .destructive, handler: { (action) in
				PersistenceManager().hidePost(post: post.postId)
				completed(true)
            }))
			
            hideAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            vc.present(hideAlert, animated: true, completion: nil)
		}))
		
		alert.addAction(UIAlertAction(title: "Block User", style: .destructive, handler: { (action) in
			let blockAlert = UIAlertController(title: "Block User", message: "Are you sure you want to block this user? Posts from them will no longer appear on your feed", preferredStyle: .alert)
			
            blockAlert.addAction(UIAlertAction(title: "Block", style: .destructive, handler: { (action) in
				PersistenceManager().blockUser(user: post.userId)
				completed(true)
            }))
            
            blockAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
			vc.present(blockAlert, animated: true, completion: nil)
		}))
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
		
		DispatchQueue.main.async {
			vc.present(alert, animated: true, completion: nil)
		}
		completed(false)
	}
	
	static func showDeleteAlert(on vc: UIViewController, for postId: String, sender: UIButton, completed: @escaping (Bool) -> Void) {
		let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
		
		alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
			let deleteAlert = UIAlertController(title: "Delete Post", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
			
            deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
				NetworkManager.shared.deletePost(for: postId)
				completed(true)
            }))
            
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
			vc.present(deleteAlert, animated: true, completion: nil)
		}))
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
		
		DispatchQueue.main.async {
			vc.present(alert, animated: true, completion: nil)
		}
		completed(false)
	}
}
