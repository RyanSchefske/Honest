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
        
        view.backgroundColor = .secondarySystemBackground
        title = "Sign In"
        
		/*
        //FirebaseUI Sign In
        let authUI = FUIAuth.defaultAuthUI()
        var _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                if let token = Messaging.messaging().fcmToken {
                    self.db.collection("users").whereField("userId", isEqualTo: Auth.auth().currentUser!.uid).getDocuments(completion: { (querySnapshot, error) in
                        if error != nil {
                            print("Error: \(error!.localizedDescription)")
                        } else {
                            if querySnapshot?.documents.count != 0 {
                                print("Found")
								print(Auth.auth().currentUser)
                            } else {
                                self.db.collection("users").addDocument(data: [
                                    "userId": Auth.auth().currentUser!.uid,
                                    "email": Auth.auth().currentUser!.email ?? "N/A",
                                    "notificationToken": token
                                ]) { err in
                                    if let err = err {
                                        print("Error adding document: \(err)")
                                    }
                                }
                            }
                        }
                    })
                    print("Sign In Token: \(token)")
                } else {
                    print("No token found")
                }
                self.navigationController?.popViewController(animated: true)
            } else {
                authUI?.delegate = self
                authUI?.providers = self.providers
                
                let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
                self.present(authViewController, animated: true, completion: nil)
            }
        }
		*/
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
    
    func setupView() {
        let signInButton: UIButton = {
            let button = UIButton(frame: CGRect(x: view.center.x, y: view.frame.height / 3.5, width: view.frame.width / 2, height: 75))
            button.center.x = view.center.x
            button.layer.cornerRadius = 25
            button.backgroundColor = UIColor(red: 60/255, green: 197/255, blue: 1, alpha: 1)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.setTitle("Sign In", for: .normal)
            button.setTitleColor(.white, for: .normal)
            return button
        }()
        view.addSubview(signInButton)
        
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }
    
    @objc func signIn() {
		if Auth.auth().currentUser != nil {
			print("User signed in")
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
