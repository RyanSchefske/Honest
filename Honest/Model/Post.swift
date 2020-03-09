//
//  Post.swift
//  Honest
//
//  Created by Ryan Schefske on 2/23/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import Foundation

struct Post: Codable, Hashable {
    var userId: String
    var postId: String
    var content: String
    var category: String
    var date: Date
    var likes: Int
    var dislikes: Int
    var replies: Int
    var reports: Int
	var liked: Bool
	var disliked: Bool
}
