//
//  PostCell.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    static let reuseID = "PostCell"
	
	let postContentView = HAPostContentView(frame: .zero)
	let postButtonView = HAPostButtonView(frame: .zero)
	
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	func set(post: Post, delegate: ReplyDelegate) {
		postContentView.dateLabel.text = post.date.convertToMonthDayYearFormat()
		postContentView.bodyLabel.text = post.content
		postContentView.categoryLabel.text = post.category
		postButtonView.replyButton.setTitle(String(post.replies), for: .normal)
		postButtonView.thumbsUpButton.setTitle(String(post.likes), for: .normal)
		postButtonView.thumbsDownButton.setTitle(String(post.dislikes), for: .normal)
		postButtonView.post = post
		postButtonView.replyDelegate = delegate
		
		if post.category == "Life" {
			postContentView.avatarIV.image = FilterImages.lifeFilter
		} else if post.category == "Relationship" {
			postContentView.avatarIV.image = FilterImages.relationshipFilter
		} else if post.category == "Work" {
			postContentView.avatarIV.image = FilterImages.workFilter
		} else if post.category == "School" {
			postContentView.avatarIV.image = FilterImages.schoolFilter
		} else if post.category == "Sports" {
			postContentView.avatarIV.image = FilterImages.sportsFilter
		} else if post.category == "Money" {
			postContentView.avatarIV.image = FilterImages.moneyFilter
		} else if post.category == "Travel" {
			postContentView.avatarIV.image = FilterImages.travelFilter
		} else if post.category == "Health" {
			postContentView.avatarIV.image = FilterImages.healthFilter
		} else if post.category == "Other" {
			postContentView.avatarIV.image = FilterImages.otherFilter
		} else if post.category == "Adulting" {
			postContentView.avatarIV.image = FilterImages.adulting
		} else if post.category == "Mental Health" {
			postContentView.avatarIV.image = FilterImages.mentalHealth
		} else if post.category == "For the Boys" {
			postContentView.avatarIV.image = FilterImages.male
		} else if post.category == "For the Girls" {
			postContentView.avatarIV.image = FilterImages.female
		} else if post.category == "Friendship" {
			postContentView.avatarIV.image = FilterImages.friendship
		} else if post.category == "Beauty" {
			postContentView.avatarIV.image = FilterImages.beauty
		} else {
			postContentView.avatarIV.image = FilterImages.lightbulb
		}
		
		if post.liked {
			postButtonView.thumbsUpButton.tintColor = Colors.customGreen
		} else {
			postButtonView.thumbsUpButton.tintColor = .systemGray4
		}
		
		if post.disliked {
			postButtonView.thumbsDownButton.tintColor = .systemRed
		} else {
			postButtonView.thumbsDownButton.tintColor = .systemGray4
		}
	}
    
    private func configure() {
		addSubviews(postContentView, postButtonView)
		
		NSLayoutConstraint.activate([
			postContentView.topAnchor.constraint(equalTo: topAnchor),
			postContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
			postContentView.trailingAnchor.constraint(equalTo: trailingAnchor),
			postContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
			
			postButtonView.centerYAnchor.constraint(equalTo: postContentView.bottomAnchor),
			postButtonView.leadingAnchor.constraint(equalTo: postContentView.leadingAnchor, constant: 30),
			postButtonView.trailingAnchor.constraint(equalTo: postContentView.trailingAnchor, constant: -30),
			postButtonView.heightAnchor.constraint(equalToConstant: 50)
		])
    }
}
