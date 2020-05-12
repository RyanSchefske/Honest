//
//  HAPostButtonView.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import AudioToolbox

protocol ReplyDelegate: class {
	func didTapReply(origPostId: String, userId: String)
	func didTapReport(origPost: Post, sender: UIButton)
}

class HAPostButtonView: UIView {
	
	let stackView = UIStackView()
	
	var post: Post? = nil
	weak var replyDelegate: ReplyDelegate?
	
	let replyButton = HAPostActionButton(image: SFSymbols.reply!, tintColor: .systemGray4)
	let thumbsUpButton = HAPostActionButton(image: SFSymbols.thumbsUpFilled!, tintColor: .systemGray4)
	let thumbsDownButton = HAPostActionButton(image: SFSymbols.thumbsDownFilled!, tintColor: .systemGray4)
	let reportButton = HAPostActionButton(image: SFSymbols.ellipsis!, tintColor: .systemGray4)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configure()
		configureStackView()
		addButtonTargets()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		backgroundColor = Colors.customBlue
		layer.cornerRadius = 25
		translatesAutoresizingMaskIntoConstraints = false
		
		reportButton.setTitle("", for: .normal)
	}
	
	func configureStackView() {
		stackView.axis = .horizontal
		stackView.distribution = .fillProportionally
				
		stackView.addArrangedSubview(replyButton)
		stackView.addArrangedSubview(thumbsUpButton)
		stackView.addArrangedSubview(thumbsDownButton)
		stackView.addArrangedSubview(reportButton)
		
		addSubview(stackView)
		stackView.pinToEdges(of: self)
	}
	
	func addButtonTargets() {
		replyButton.addTarget(self, action: #selector(replyClicked), for: .touchUpInside)
		thumbsUpButton.addTarget(self, action: #selector(thumbsUpClicked), for: .touchUpInside)
		thumbsDownButton.addTarget(self, action: #selector(thumbsDownClicked), for: .touchUpInside)
		reportButton.addTarget(self, action: #selector(reportClicked), for: .touchUpInside)
	}
	
	@objc func replyClicked() {
		guard let post = post, let delegate = replyDelegate else { return }
		delegate.didTapReply(origPostId: post.postId, userId: post.userId)
	}
	
	@objc func thumbsUpClicked() {
		guard var post = post else { return }
		
		if post.liked {
			post.likes -= 1
			thumbsUpButton.tintColor = .systemGray4
			PersistenceManager().unlikePost(post: post.postId)
		} else {
			AudioServicesPlaySystemSound(1519)
			thumbsUpButton.pulse()
			sendLikeNotification(to: post.userId)
			post.likes += 1
			thumbsUpButton.tintColor = Colors.customGreen
			PersistenceManager().likePost(post: post.postId)
		}
		self.post!.liked.toggle()
		self.post!.likes = post.likes
		NetworkManager.shared.updateLikes(for: post.postId, likes: post.likes)
		thumbsUpButton.setTitle(String(post.likes), for: .normal)
	}
	
	@objc func thumbsDownClicked() {
		guard var post = post else { return }
		
		if post.disliked {
			post.dislikes += 1
			thumbsDownButton.tintColor = .systemGray4
			PersistenceManager().undislikePost(post: post.postId)
		} else {
			AudioServicesPlaySystemSound(1519)
			thumbsDownButton.pulse() 
			post.dislikes -= 1
			thumbsDownButton.tintColor = .systemRed
			PersistenceManager().dislikePost(post: post.postId)
		}
		self.post!.disliked.toggle()
		self.post!.dislikes = post.dislikes
		NetworkManager.shared.updateDislikes(for: post.postId, dislikes: post.dislikes)
		thumbsDownButton.setTitle(String(post.dislikes), for: .normal)
	}
	
	@objc func reportClicked(_ sender: UIButton) {
		guard let post = post, let delegate = replyDelegate else { return }
		delegate.didTapReport(origPost: post, sender: sender)
	}
}

