//
//  Reply.swift
//  Honest
//
//  Created by Ryan Schefske on 2/23/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import Foundation

struct Reply: Hashable {
	var userId: String
	var replyId: String
    var content: String
    var date: Date
    var adviceId: String
    var likes: Int
    var dislikes: Int
    var reports: Int
}
