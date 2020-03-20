//
//  HAPostContentView.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class HAPostContentView: UIView {
	
    let avatarIV = HAAvatarIV(frame: .zero)
	let usernameLabel = HATitleLabel(textAlignment: .left, fontSize: 20)
	let dateLabel = HASubtitleLabel(fontSize: 14, textAlignment: .right)
	let categoryLabel = HASubtitleLabel(fontSize: 14, textAlignment: .left)
	let bodyLabel = HABodyLabel(textAlignment: .natural)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
		backgroundColor = .tertiarySystemBackground
		layer.cornerRadius = 15
		
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOpacity = 0.2
		layer.shadowRadius = 15
		
		translatesAutoresizingMaskIntoConstraints = false
		
		addSubviews(avatarIV, usernameLabel, dateLabel, categoryLabel, bodyLabel)
		
		let labelHeight: CGFloat = 24
		let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            avatarIV.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarIV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarIV.heightAnchor.constraint(equalToConstant: 75),
            avatarIV.widthAnchor.constraint(equalToConstant: 75),
			
			usernameLabel.topAnchor.constraint(equalTo: avatarIV.topAnchor, constant: padding),
			usernameLabel.leadingAnchor.constraint(equalTo: avatarIV.trailingAnchor, constant: 5),
			usernameLabel.widthAnchor.constraint(equalToConstant: 110),
			usernameLabel.heightAnchor.constraint(equalToConstant: labelHeight),
			
			dateLabel.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor),
			dateLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: padding),
			dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
			dateLabel.heightAnchor.constraint(equalToConstant: labelHeight),
			
			categoryLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor),
			categoryLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
			categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
			categoryLabel.heightAnchor.constraint(equalToConstant: labelHeight),
			
			bodyLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor),
			bodyLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
			bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
			bodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40)
        ])
    }
}
