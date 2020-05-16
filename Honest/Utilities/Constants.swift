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
