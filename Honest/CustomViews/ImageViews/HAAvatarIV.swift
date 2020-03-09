//
//  HAAvatarIV.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class HAAvatarIV: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 75 / 2
        clipsToBounds = true
        image = SFSymbols.avatarImage
        tintColor = Colors.customBlue
        translatesAutoresizingMaskIntoConstraints = false
    }
}
