//
//  HATextField.swift
//  Honest
//
//  Created by Ryan Schefske on 3/6/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class HATextField: UITextField {
	
	let categories = ["Life", "Relationship", "Friendship", "For the Girls", "For the Boys", "Beauty", "Work", "Adulting", "School", "Sports", "Money", "Travel", "Health", "Mental Health", "Other"]
	let bottomLine = UIView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configure()
		customizeUI()
		setupPicker()
	}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
		placeholder = "Select Category"
		textColor = .label
		textAlignment = .center
		font = UIFont.preferredFont(forTextStyle: .title1).withSize(20)
		
		tintColor = .clear
		backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
	
	private func customizeUI() {
		bottomLine.backgroundColor = Colors.customBlue
		bottomLine.translatesAutoresizingMaskIntoConstraints = false
		addSubview(bottomLine)
		
		NSLayoutConstraint.activate([
			bottomLine.topAnchor.constraint(equalTo: bottomAnchor, constant: -2),
			bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
			bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
			bottomLine.heightAnchor.constraint(equalToConstant: 2)
		])
	}
	
	func animate() {
		bottomLine.transform = CGAffineTransform(scaleX: 0, y: 0)
		self.alpha = 0
		
		UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
			self.alpha = 1
			self.bottomLine.transform = CGAffineTransform(scaleX: 1, y: 1)
		}, completion: nil)
	}
	
	private func setupPicker() {
		let categoryPicker = UIPickerView()
        categoryPicker.backgroundColor = .systemBackground
        categoryPicker.delegate = self
        inputView = categoryPicker
	}
}

extension HATextField: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.text = categories[row]
    }
}
