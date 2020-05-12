//
//  SignInVC.swift
//  Honest
//
//  Created by Ryan Schefske on 3/6/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging

class SignInVC: UIViewController {
    
    fileprivate var authHandle: AuthStateDidChangeListenerHandle!
    let db = Firestore.firestore()
    
    let providers: [FUIAuthProvider] = [
        FUIEmailAuth()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
		setupView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(true, animated: true)
		tabBarController?.tabBar.isHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: true)
		tabBarController?.tabBar.isHidden = false
	}
	
	private func configureVC() {
		view.backgroundColor = .secondarySystemBackground
        title = "Sign In"
	}
    
    func setupView() {
		let imageView: UIImageView = {
			let iv = UIImageView()
			iv.image = UIImage(named: "Honest")
			iv.layer.cornerRadius = 10
			iv.clipsToBounds = true
			iv.translatesAutoresizingMaskIntoConstraints = false
			return iv
		}()
		
		let titleLabel: HATitleLabel = {
			let lbl = HATitleLabel(textAlignment: .left, fontSize: 30)
			lbl.text = "Honest"
			return lbl
		}()
		
		let subtitleLabel: HABodyLabel = {
			let lbl = HABodyLabel(textAlignment: .left)
			lbl.text = "Get anonymous advice quickly! Click below to get started!"
			lbl.textColor = .secondaryLabel
			lbl.font = UIFont.systemFont(ofSize: 18, weight: .medium)
			return lbl
		}()
		
        let signInButton: UIButton = {
            let button = UIButton()
            button.center.x = view.center.x
            button.layer.cornerRadius = 10
			button.backgroundColor = Colors.customBlue
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.setTitle("Sign In", for: .normal)
            button.setTitleColor(.white, for: .normal)
			button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
			button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
		
        view.addSubviews(imageView, titleLabel, subtitleLabel, signInButton)
		
		let padding: CGFloat = 40
		let imageHW: CGFloat = 100
		
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
			imageView.heightAnchor.constraint(equalToConstant: imageHW),
			imageView.widthAnchor.constraint(equalToConstant: imageHW),
			
			titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0),
			titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
			titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
			titleLabel.heightAnchor.constraint(equalToConstant: 35),
			
			subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
			subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
			subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
			subtitleLabel.heightAnchor.constraint(equalToConstant: 65),
			
			signInButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: padding),
			signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
			signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
			signInButton.heightAnchor.constraint(equalToConstant: 55)
		])
    }
    
    @objc func signIn() {
		if Auth.auth().currentUser != nil {
			navigationController?.popViewController(animated: true)
		} else {
			let authUI = FUIAuth.defaultAuthUI()
			authUI?.delegate = self
			authUI?.providers = self.providers
			
			let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
			self.present(authViewController, animated: true, completion: nil)
		}
    }
}

extension SignInVC: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil {
            print(error)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension FUIAuthBaseViewController{
    open override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.leftBarButtonItem = nil
    }
}
