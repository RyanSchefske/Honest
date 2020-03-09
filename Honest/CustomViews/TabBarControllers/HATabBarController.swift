//
//  HATabBarController.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class HATabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = Colors.customBlue
        viewControllers = [createHomeVC(), createNewPostVC(), createProfileVC()]
    }
    
    func createHomeVC() -> UINavigationController {
        let homeVC = HomeVC()
        homeVC.title = "Home"
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: SFSymbols.home, selectedImage: SFSymbols.homeFilled)
        return UINavigationController(rootViewController: homeVC)
    }
    
    func createNewPostVC() -> UINavigationController {
        let newPostVC = NewPostVC()
        newPostVC.title = "New Post"
		newPostVC.tabBarItem = UITabBarItem(title: "New", image: SFSymbols.add, selectedImage: SFSymbols.addFilled)
        return UINavigationController(rootViewController: newPostVC)
    }
    
    func createProfileVC() -> UINavigationController {
        let profileVC = ProfileVC()
        profileVC.title = "Profile"
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: SFSymbols.profile, selectedImage: SFSymbols.profileFilled)
        return UINavigationController(rootViewController: profileVC)
    }

}
