//
//  HAPostActionButton.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class HAPostActionButton: UIButton {

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		setTitle("0", for: .normal)
		imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
		titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
	}
	
	convenience init(image: UIImage, tintColor: UIColor) {
        self.init(frame: .zero)
        
		setImage(image, for: .normal)
		self.tintColor = tintColor
    }
	
	func set(image: UIImage, tintColor: UIColor) {
		setImage(image, for: .normal)
		self.tintColor = tintColor
	}

}
