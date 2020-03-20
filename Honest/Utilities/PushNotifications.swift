//
//  PushNotifications.swift
//  Honest
//
//  Created by Ryan Schefske on 3/17/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFunctions

extension UIView {
    func sendLikeNotification(to user: String) {
        let db = Firestore.firestore()
        let functions = Functions.functions()
        
        db.collection("users").whereField("userId", isEqualTo: user).getDocuments(completion: { (querySnapshot, error) in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            } else {
                if querySnapshot?.documents.count == 0 {
                    print("None found")
                } else {
                    for document in querySnapshot!.documents {
                        if let token = document.data()["notificationToken"] {
                            functions.httpsCallable("sendNewLikeNotification").call(["text": token]) { (result, error) in
                                if let error = error as NSError? {
                                    if error.domain == FunctionsErrorDomain {
                                        _ = FunctionsErrorCode(rawValue: error.code)
                                        _ = error.localizedDescription
                                        _ = error.userInfo[FunctionsErrorDetailsKey]
                                    }
                                }
                                if let message = (result?.data as? [String: Any])?["text"] as? String {
                                    print(message)
                                }
                            }
                        }
                    }
                }
            }
        })
    }
}

extension UIViewController {
    func sendReplyNotification(to user: String) {
        let db = Firestore.firestore()
        let functions = Functions.functions()
        
        db.collection("users").whereField("userId", isEqualTo: user).getDocuments(completion: { (querySnapshot, error) in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            } else {
                if querySnapshot?.documents.count == 0 {
                    print("None found")
                } else {
                    for document in querySnapshot!.documents {
                        if let token = document.data()["notificationToken"] {
                            functions.httpsCallable("sendNewReplyNotification").call(["text": token]) { (result, error) in
                                if let error = error as NSError? {
                                    if error.domain == FunctionsErrorDomain {
                                        _ = FunctionsErrorCode(rawValue: error.code)
                                        _ = error.localizedDescription
                                        _ = error.userInfo[FunctionsErrorDetailsKey]
                                    }
                                }
                                if let message = (result?.data as? [String: Any])?["text"] as? String {
                                    print(message)
                                }
                            }
                        }
                    }
                }
            }
        })
    }
}
