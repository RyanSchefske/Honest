//
//  UIButton+Anim.swift
//  Honest
//
//  Created by Ryan Schefske on 3/14/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

extension UIButton {
	func pulse() {
		transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
		
		UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 4.0, options: .allowUserInteraction, animations: { [weak self] in
				guard let self = self else { return }
				self.transform = .identity
			}, completion: nil)
	}
}
