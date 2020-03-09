//
//  ReplyCell.swift
//  Honest
//
//  Created by Ryan Schefske on 3/8/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class ReplyCell: UICollectionViewCell {
    
	static let reuseID = "ReplyCell"
	let postContentView = HAPostContentView(frame: .zero)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func set(reply: Reply) {
		postContentView.dateLabel.text = reply.date.convertToMonthDayYearFormat()
		postContentView.bodyLabel.text = reply.content
		postContentView.categoryLabel.text = "Reply"
		postContentView.backgroundColor = .systemGray4
	}
	
	private func configure() {
		addSubviews(postContentView)
		
		NSLayoutConstraint.activate([
			postContentView.topAnchor.constraint(equalTo: topAnchor),
			postContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
			postContentView.trailingAnchor.constraint(equalTo: trailingAnchor),
			postContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
		])
	}
	
}
