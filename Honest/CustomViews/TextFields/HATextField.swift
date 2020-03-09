//
//  HATextField.swift
//  Honest
//
//  Created by Ryan Schefske on 3/6/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class HATextField: UITextField {
	
	let categories = ["Life", "Relationship", "Work", "School", "Sports", "Money", "Travel", "Health", "Other"]

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
		/*
		layer.cornerRadius = 10
		
		layer.shadowColor = UIColor.systemGray.cgColor
		layer.shadowOpacity = 0.5
		layer.shadowRadius = 10
		clipsToBounds = false */
		let bottomLine = UIView()
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