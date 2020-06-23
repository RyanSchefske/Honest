//
//  HATextView.swift
//  Honest
//
//  Created by Ryan Schefske on 3/6/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class HATextView: UITextView {
	
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		
		configure()
		customizeUI()
	}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
		textColor = .label
		backgroundColor = .tertiarySystemBackground
		font = UIFont.preferredFont(forTextStyle: .body).withSize(14)
        translatesAutoresizingMaskIntoConstraints = false
    }
	
	private func customizeUI() {
		layer.cornerRadius = 10
	}
	
	func animate() {
		alpha = 0
		transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
		
		UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
			self.alpha = 1
			self.transform = CGAffineTransform(scaleX: 1, y: 1)
		}, completion: nil)
	}
}
