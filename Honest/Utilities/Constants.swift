//
//  Constants.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

enum SFSymbols {
	//Tab bar images
    static let home = UIImage(systemName: "house")
    static let homeFilled = UIImage(systemName: "house.fill")
	
	static let add = UIImage(systemName: "plus.app")
	static let addFilled = UIImage(systemName: "plus.app.fill")
    
    static let profile = UIImage(systemName: "person")
    static let profileFilled = UIImage(systemName: "person.fill")
    
	//Post images
    static let avatarImage = UIImage(systemName: "person.crop.circle.fill")
	
	static let reply = UIImage(systemName: "arrowshape.turn.up.left.fill")
	static let thumbsUp = UIImage(systemName: "hand.thumbsup")
	static let thumbsUpFilled = UIImage(systemName: "hand.thumbsup.fill")
	static let thumbsDown = UIImage(systemName: "hand.thumbsdown")
	static let thumbsDownFilled = UIImage(systemName: "hand.thumbsdown.fill")
	static let report = UIImage(systemName: "exclamationmark.octagon.fill")
	static let ellipsis = UIImage(systemName: "ellipsis")
	
	//Settings image
	static let settings = UIImage(systemName: "gear")
	static let adFree = UIImage(systemName: "gift.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.customBlue)
	static let privacy = UIImage(systemName: "lock.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemYellow)
	static let signOut = UIImage(systemName: "stop.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed)
	static let app = UIImage(systemName: "app.badge.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemPurple)
	static let money = UIImage(systemName: "dollarsign.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemGreen)
	static let share = UIImage(systemName: "square.and.arrow.up.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemGray)
	static let heart = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemPink)
	static let delete = UIImage(systemName: "delete.right.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed)
	static let faceId = UIImage(systemName: "faceid")?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.customBlue)
}

enum FilterImages {
	static let lifeFilter = UIImage(named: "flower")
	static let relationshipFilter = UIImage(named: "relationship")
	static let workFilter = UIImage(named: "work")
	static let schoolFilter = UIImage(named: "school")
	static let sportsFilter = UIImage(named: "sports")
	static let moneyFilter = UIImage(named: "money")
	static let travelFilter = UIImage(named: "travel")
	static let healthFilter = UIImage(named: "health")
	static let otherFilter = UIImage(named: "other")
	static let lightbulb = UIImage(named: "lightbulb")
	static let female = UIImage(named: "female")
	static let male = UIImage(named: "male")
	static let friendship = UIImage(named: "friends")
	static let adulting = UIImage(named: "adulting")
	static let beauty = UIImage(named: "beauty")
	static let mentalHealth = UIImage(named: "mentalHealth")
}

enum Colors {
    static let customBlue = UIColor(red: 112/255, green: 213/255, blue: 1, alpha: 1)
	static let customGreen = UIColor(red: 0, green: 200/255, blue: 17/255, alpha: 1)
}

enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale
    
    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad                   = idiom == .pad && ScreenSize.maxLength >= 1024.0
    
    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}

enum TipHelper {
	static let thankYou = "Thank you for using Honest!\n\nI hope that you are enjoying the app, and any feedback is always welcome.\n\nAs an independent developer with a full time job, all development for this app is done in my free time.\n\nTherefore, if you're enjoying the app and would like to continue to see new updates and features, I would greatly appreciate it!\n\nThank you!"
}
