//
//  SettingsVC.swift
//  Honest
//
//  Created by Ryan Schefske on 3/15/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		configureVC()
    }
	
	private func configureVC() {
		title = "Settings"
		tableView.backgroundColor = .secondarySystemBackground
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.backgroundColor = .secondarySystemBackground
		
		if indexPath.row == 0 {
			cell.textLabel?.text = "Privacy Policy/Terms of Use"
		} else if indexPath.row == 1 {
			cell.textLabel?.text = "Sign Out"
			cell.textLabel?.textColor = .systemRed
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			guard let url = URL(string: "https://ryanschefske.wixsite.com/home/blank-page") else { return }
			UIApplication.shared.open(url)
		} else if indexPath.row == 1 {
			try! Auth.auth().signOut()
			self.tabBarController?.selectedIndex = 0
		}
	}
}
