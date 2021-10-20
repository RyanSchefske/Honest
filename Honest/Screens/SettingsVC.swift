//
//  SettingsVC.swift
//  Honest
//
//  Created by Ryan Schefske on 3/15/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import FirebaseAuth
import StoreKit

class SettingsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		configureVC()
    }
	
	private func configureVC() {
		title = "Settings"
		tableView = UITableView(frame: .zero, style: .insetGrouped)
		tableView.backgroundColor = .secondarySystemBackground
		tableView.separatorStyle = .singleLine
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 5
		}
		return 4
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Support"
		} else if section == 1 {
			return "Privacy"
		}
		return nil
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.backgroundColor = .tertiarySystemBackground
		
		if indexPath.section == 0 {
			if indexPath.row == 0 {
				cell.textLabel?.text = "Remove Ads!"
				cell.imageView?.image = SFSymbols.adFree
			} else if indexPath.row == 1 {
				cell.textLabel?.text = "Our Apps"
				cell.imageView?.image = SFSymbols.app
			} else if indexPath.row == 2 {
				cell.textLabel?.text = "Rate Honest"
				cell.imageView?.image = SFSymbols.heart
			} else if indexPath.row == 3 {
				cell.textLabel?.text = "Share Honest"
				cell.imageView?.image = SFSymbols.share
			} else if indexPath.row == 4 {
				cell.textLabel?.text = "Leave Tip"
				cell.imageView?.image = SFSymbols.money
			}
		} else if indexPath.section == 1 {
			if indexPath.row == 0 {
				cell.textLabel?.text = "Secure Profile"
				cell.imageView?.image = SFSymbols.faceId
				
				let secureSwitch = UISwitch()
				secureSwitch.setOn(PersistenceManager.shared.fetchSecureProfile(), animated: true)
				secureSwitch.addTarget(self, action: #selector(didSwitchSecurity), for: .valueChanged)
				cell.accessoryView = secureSwitch
			} else if indexPath.row == 1 {
				cell.textLabel?.text = "Privacy Policy/Terms of Use"
				cell.imageView?.image = SFSymbols.privacy
			} else if indexPath.row == 2 {
				cell.textLabel?.text = "Sign Out"
				cell.imageView?.image = SFSymbols.signOut
			} else if indexPath.row == 3 {
				cell.textLabel?.text = "Delete Account"
				cell.imageView?.image = SFSymbols.delete
			}
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if indexPath.section == 0 {
			if indexPath.row == 0 {
				navigationController?.present(AdFreeVC(), animated: true, completion: nil)
			} else if indexPath.row == 1 {
				if let url = URL(string: "itms-apps://apps.apple.com/kw/developer/ryan-schefske/id1359871123") {
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
				}
			} else if indexPath.row == 2 {
				SKStoreReviewController.requestReview()
			} else if indexPath.row == 3 {
				let items: [Any] = ["Check out this cool app! You can anonymously receive and give advice!", URL(string: "https://apps.apple.com/us/app/id1473636568")!]
				let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
				activityVC.popoverPresentationController?.sourceView = self.view
				self.present(activityVC, animated: true, completion: nil)
			} else if indexPath.row == 4 {
				navigationController?.pushViewController(TipVC(), animated: true)
			}
		} else if indexPath.section == 1 {
			if indexPath.row == 0 {
				
			} else if indexPath.row == 1 {
				guard let url = URL(string: "https://ryanschefske.wixsite.com/home/blank-page") else { return }
				UIApplication.shared.open(url)
			} else if indexPath.row == 2 {
				try! Auth.auth().signOut()
				self.tabBarController?.selectedIndex = 0
			} else if indexPath.row == 3 {
				let alertController = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
				
				let action1 = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
					let user = Auth.auth().currentUser
					
					user?.delete { error in
						if error == nil {
							self.navigationController?.pushViewController(SignInVC(), animated: true)
						}
					}
				}

				let action2 = UIAlertAction(title: "Cancel", style: .default)

				alertController.addAction(action1)
				alertController.addAction(action2)
				self.present(alertController, animated: true, completion: nil)
			}
		}
	}
	
	@objc func didSwitchSecurity() {
		var secureProfile = PersistenceManager.shared.fetchSecureProfile()
		secureProfile.toggle()
		PersistenceManager.shared.setSecureProfile(secureProfile)
	}
}
