//
//  HACharactersLabel.swift
//  Honest
//
//  Created by Ryan Schefske on 9/29/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class HACharactersLabel: UILabel {
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		textColor = .secondaryLabel
		numberOfLines = 1
		font = UIFont.preferredFont(forTextStyle: .subheadline)
		lineBreakMode = .byWordWrapping
		translatesAutoresizingMaskIntoConstraints = false
	}
}
