//
//  HABodyLabel.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class HABodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        
        self.textAlignment = textAlignment
    }
    
    private func configure() {
		textColor = .label
		numberOfLines = 0
		font = UIFont.preferredFont(forTextStyle: .body).withSize(14)
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }

}
