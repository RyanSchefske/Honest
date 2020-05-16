//
//  NetworkManager.swift
//  Honest
//
//  Created by Ryan Schefske on 2/23/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseMessaging

class NetworkManager {
	
	static let shared = NetworkManager()
	let db = Firestore.firestore()
	
	private init() {}
	
	func getPosts(date: Date, completed: @escaping (Result<[Post], HAError>) -> Void) {
		var posts: [Post] = []
		
		let likes = PersistenceManager().fetchLikedPosts()
		let dislikes = PersistenceManager().fetchDislikedPosts()
		let hiddenPosts = PersistenceManager().fetchHiddenPosts()
		let blockedUsers = PersistenceManager().fetchBlockedUsers()
		
		var liked = false
		var disliked = false
        
		db.collection("posts").order(by: "date", descending: true).whereField("date", isLessThan: date).limit(to: 10).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
				completed(.failure(.unableToComplete))
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let timestamp: Timestamp = data["date"] as! Timestamp
                    let date: Date = timestamp.dateValue()
					
					guard let postId = data["questionId"] as? String else { return }
					if likes.contains(postId) { liked = true } else { liked = false }
					if dislikes.contains(postId) { disliked = true } else { disliked = false }
					
					if hiddenPosts.contains(postId) { continue }
					if blockedUsers.contains(postId) { continue }
					
					posts.append(Post(userId: data["userId"] as! String, postId: data["questionId"] as! String, content: data["question"] as! String, category: data["category"] as! String, date: date, likes: data["likes"] as! Int, dislikes: data["dislikes"] as! Int, replies: data["replies"] as! Int, reports: data["reports"] as! Int, liked: liked, disliked: disliked))
                }
                posts = posts.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
				completed(.success(posts))
            }
        }
    }
	
	func getFilteredPosts(date: Date, filter: String, completed: @escaping (Result<[Post], HAError>) -> Void) {
		var posts: [Post] = []
		
		let likes = PersistenceManager().fetchLikedPosts()
		let dislikes = PersistenceManager().fetchDislikedPosts()
		let hiddenPosts = PersistenceManager().fetchHiddenPosts()
		let blockedUsers = PersistenceManager().fetchBlockedUsers()
		
		var liked = false
		var disliked = false
        
		db.collection("posts").order(by: "date", descending: true).whereField("category", isEqualTo: filter).whereField("date", isLessThan: date).limit(to: 10).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
				completed(.failure(.unableToComplete))
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let timestamp: Timestamp = data["date"] as! Timestamp
                    let date: Date = timestamp.dateValue()
					
					guard let postId = data["questionId"] as? String else { return }
					if likes.contains(postId) { liked = true } else { liked = false }
					if dislikes.contains(postId) { disliked = true } else { disliked = false }
					
					if hiddenPosts.contains(postId) { continue }
					if blockedUsers.contains(postId) { continue }
					
					posts.append(Post(userId: data["userId"] as! String, postId: data["questionId"] as! String, content: data["question"] as! String, category: data["category"] as! String, date: date, likes: data["likes"] as! Int, dislikes: data["dislikes"] as! Int, replies: data["replies"] as! Int, reports: data["reports"] as! Int, liked: liked, disliked: disliked))
                }
                posts = posts.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
				completed(.success(posts))
            }
        }
    }
	
	func postAdvice(content: String, category: String, completed: @escaping (Result<Bool, HAError>) -> Void) {
		guard let user = Auth.auth().currentUser else { return }
		let newDate = Date().addingTimeInterval(-1 * 60)
			
		_ = db.collection("posts").addDocument(data: [
			"userId": user.uid,
			"questionId": UUID().uuidString,
			"question": content,
			"category": category,
			"date": newDate,
			"likes": 0,
			"dislikes": 0,
			"replies": 0,
			"reports": 0
		]) { error in
			if error != nil {
				completed(.failure(.unableToComplete))
			} else {
				completed(.success(true))
			}
		}
	}
	
	func getReplies(for postId: String, completed: @escaping (Result<[Reply], HAError>) -> Void) {
		var replies: [Reply] = []
		
        _ = db.collection("replies").whereField("origPostId", isEqualTo: postId).getDocuments { (querySnapshot, error) in
            if error != nil {
				completed(.failure(.unableToComplete))
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let timestamp: Timestamp = data["date"] as! Timestamp
                    let date: Date = timestamp.dateValue()
					replies.append(Reply(userId: data["userId"] as! String, replyId: data["replyId"] as! String, content: data["reply"] as! String, date: date, adviceId: data["replyId"] as! String, likes: data["likes"] as! Int, dislikes: data["dislikes"] as! Int, reports: data["reports"] as! Int))
                }
				
                replies = replies.sorted(by: {
                    $0.date.compare($1.date) == .orderedAscending
                })
				
				completed(.success(replies))
            }
        }
	}
	
	func postReply(origPostId: String, content: String, completed: @escaping (Result<Bool, HAError>) -> Void) {
		guard let user = Auth.auth().currentUser else { return }
		
		_ = db.collection("replies").addDocument(data: [
			"userId": user.uid,
			"origPostId": origPostId,
			"replyId": UUID().uuidString,
			"reply": content,
			"date": Date(),
			"likes": 0,
			"dislikes": 0,
			"reports": 0
		]) { error in
			if error != nil {
				completed(.failure(.unableToComplete))
			} else {
				_ = self.db.collection("posts").whereField("questionId", isEqualTo: origPostId).getDocuments { (querySnapshot, error) in
					if error != nil {
						print("Error")
					} else if querySnapshot!.documents.count != 1 {
						print("Error finding document")
					} else {
						let document = querySnapshot?.documents.first
						if var replies = document?.data()["replies"] as? Int {
							replies += 1
							document?.reference.updateData(["replies": replies])
						}
					}
				}
				completed(.success(true))
			}
		}
	}
	
	func getUserPosts(completed: @escaping (Result<[Post], HAError>) -> Void) {
		guard let user = Auth.auth().currentUser else { return }
		var posts: [Post] = []
		
		let likes = PersistenceManager().fetchLikedPosts()
		let dislikes = PersistenceManager().fetchDislikedPosts()
		var liked = false
		var disliked = false
        
		db.collection("posts").whereField("userId", isEqualTo: user.uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
				completed(.failure(.unableToComplete))
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let timestamp: Timestamp = data["date"] as! Timestamp
                    let date: Date = timestamp.dateValue()
					
					guard let postId = data["questionId"] as? String else { return }
					if likes.contains(postId) { liked = true } else { liked = false }
					if dislikes.contains(postId) { disliked = true } else { disliked = false }
					
					posts.append(Post(userId: data["userId"] as! String, postId: data["questionId"] as! String, content: data["question"] as! String, category: data["category"] as! String, date: date, likes: data["likes"] as! Int, dislikes: data["dislikes"] as! Int, replies: data["replies"] as! Int, reports: data["reports"] as! Int, liked: liked, disliked: disliked))
                }
                posts = posts.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
				completed(.success(posts))
            }
        }
    }
	
	func updateLikes(for postId: String, likes: Int) {
		_ = db.collection("posts").whereField("questionId", isEqualTo: postId).getDocuments { (querySnapshot, error) in
            if error != nil {
                print("Error")
            } else if querySnapshot!.documents.count != 1 {
                print("Error finding document")
            } else {
                let document = querySnapshot?.documents.first
                document?.reference.updateData(["likes": likes])
            }
        }
	}
	
	func updateDislikes(for postId: String, dislikes: Int) {
		_ = db.collection("posts").whereField("questionId", isEqualTo: postId).getDocuments { (querySnapshot, error) in
            if error != nil {
                print("Error")
            } else if querySnapshot!.documents.count != 1 {
                print("Error finding document")
            } else {
                let document = querySnapshot?.documents.first
                document?.reference.updateData(["dislikes": dislikes])
            }
        }
	}
	
	func updateReports(for postId: String) {
		_ = self.db.collection("posts")
		.whereField("questionId", isEqualTo: postId)
		.getDocuments(completion: { (querySnapshot, error) in
			if error != nil {
				print("Error")
			} else if querySnapshot!.documents.count != 1 {
				print("Error finding document")
			} else {
				let document = querySnapshot!.documents.first
				if var reports = document!.data()["reports"] as? Int {
					reports += 1
					if reports >= 3 {
						document?.reference.delete(completion: { (error) in
							if error != nil { print(error!.localizedDescription) }
						})
					} else {
						document?.reference.updateData(["reports": reports])
					}
				}
			}
		})
	}
	
	func deletePost(for postId: String) {
		_ = self.db.collection("posts")
		.whereField("questionId", isEqualTo: postId)
		.getDocuments(completion: { (querySnapshot, error) in
			if error != nil {
				print("Error")
			} else if querySnapshot!.documents.count != 1 {
				print("Error finding document")
			} else {
				let document = querySnapshot!.documents.first
				document?.reference.delete(completion: {
					(error) in
					if error != nil {
						print("Error: ", error!.localizedDescription)
					}
				})
			}
		})
	}
	
	func updateToken() {
		if let token = Messaging.messaging().fcmToken {
			self.db.collection("users").whereField("userId", isEqualTo: Auth.auth().currentUser!.uid).getDocuments(completion: { (querySnapshot, error) in
				if error != nil {
					print("Error: \(error!.localizedDescription)")
				} else {
					if querySnapshot?.documents.count != 0 {
						let document = querySnapshot?.documents.first
						if document?.data()["notificationToken"] as? String != token {
							document?.reference.updateData(["notificationToken": token])
						}
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
		}
	}
}
