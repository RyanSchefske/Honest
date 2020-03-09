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
		backgroundColor = .systemBackground
		font = UIFont.preferredFont(forTextStyle: .body).withSize(14)
        translatesAutoresizingMaskIntoConstraints = false
    }
	
	private func customizeUI() {
		layer.cornerRadius = 10
		
		layer.shadowColor = UIColor.systemGray.cgColor
		layer.shadowOpacity = 0.5
		layer.shadowRadius = 10
		clipsToBounds = false
	}
}
