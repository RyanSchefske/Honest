//
//  PersistenceManager.swift
//  Honest
//
//  Created by Ryan Schefske on 2/23/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import Foundation

class PersistenceManager {
	
	static private let defaults = UserDefaults.standard
	
	enum Keys {
		static let likedPosts = "LikedPosts"
		static let dislikedPosts = "DislikedPosts"
		static let blockedUsers = "BlockedUsers"
		static let hiddenPosts = "HiddenPosts"
	}
	
	func blockUser(user: String) {
		if var blockedUsers = UserDefaults.standard.stringArray(forKey: Keys.blockedUsers) {
            blockedUsers.append(user)
			UserDefaults.standard.set(blockedUsers, forKey: Keys.blockedUsers)
        } else {
			UserDefaults.standard.set([user], forKey: Keys.blockedUsers)
        }
    }
    
    func likePost(post: String) {
		if var likedPosts = UserDefaults.standard.stringArray(forKey: Keys.likedPosts) {
            likedPosts.append(post)
			UserDefaults.standard.set(likedPosts, forKey: Keys.likedPosts)
        } else {
			UserDefaults.standard.set([post], forKey: Keys.likedPosts)
        }
    }
    
    func dislikePost(post: String) {
		if var dislikedPosts = UserDefaults.standard.stringArray(forKey: Keys.dislikedPosts) {
            dislikedPosts.append(post)
			UserDefaults.standard.set(dislikedPosts, forKey: Keys.dislikedPosts)
        } else {
			UserDefaults.standard.set([post], forKey: Keys.dislikedPosts)
        }
    }
    
    func unlikePost(post: String) {
		if var likedPosts = UserDefaults.standard.stringArray(forKey: Keys.likedPosts) {
            for post in likedPosts {
                if likedPosts.contains(post) {
                    if let index = likedPosts.firstIndex(of: post) {
                        likedPosts.remove(at: index)
                    }
                }
            }
			UserDefaults.standard.set(likedPosts, forKey: Keys.likedPosts)
        } else {
            print("Error: Couldn't find document")
        }
    }
    
    func undislikePost(post: String) {
		if var dislikedPosts = UserDefaults.standard.stringArray(forKey: Keys.dislikedPosts) {
            for post in dislikedPosts {
                if dislikedPosts.contains(post) {
                    if let index = dislikedPosts.firstIndex(of: post) {
                        dislikedPosts.remove(at: index)
                    }
                }
            }
			UserDefaults.standard.set(dislikedPosts, forKey: Keys.dislikedPosts)
        } else {
            print("Error: Couldn't find document")
        }
    }
    
    func hidePost(post: String) {
		if var hiddenPosts = UserDefaults.standard.stringArray(forKey: Keys.hiddenPosts) {
            hiddenPosts.append(post)
			UserDefaults.standard.set(hiddenPosts, forKey: Keys.hiddenPosts)
        } else {
			UserDefaults.standard.set([post], forKey: Keys.hiddenPosts)
        }
    }
    
    func fetchBlockedUsers() -> [String] {
		if let blockedUsers = UserDefaults.standard.stringArray(forKey: Keys.blockedUsers) {
            return blockedUsers
        }
        return []
    }
    
    func fetchHiddenPosts() -> [String] {
		if let hiddenPosts = UserDefaults.standard.stringArray(forKey: Keys.hiddenPosts) {
            return hiddenPosts
        }
        return []
    }
    
    func fetchLikedPosts() -> [String] {
		if let posts = UserDefaults.standard.stringArray(forKey: Keys.likedPosts) {
            return posts
        }
        return []
    }
    
    func fetchDislikedPosts() -> [String] {
		if let posts = UserDefaults.standard.stringArray(forKey: Keys.dislikedPosts) {
            return posts
        }
        return []
    }
}
