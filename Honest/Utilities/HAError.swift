//
//  HAError.swift
//  Honest
//
//  Created by Ryan Schefske on 2/23/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import Foundation

enum HAError: String, Error {
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case unableToLike = "There was an error liking this post. Please try again."
	case alreadyInLikes = "This post has already been liked by you."
}
