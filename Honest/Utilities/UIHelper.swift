//
//  UIHelper.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

enum UIHelper {
    static func createCVFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 8
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if let post = posts[indexPath.item] as? Post {
            let approximateWidthOfText = collectionView.frame.width - 105
            let size = CGSize(width: approximateWidthOfText, height: 1000)
			let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body).withSize(14)]
            
			let estimatedFrame = NSString(string: post.content).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return CGSize(width: collectionView.frame.width - 20, height: estimatedFrame.height + 200)
		} else {
			return CGSize(width: collectionView.frame.width - 20, height: 200)
		}
	}
}

extension DetailVC: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		if indexPath.item == 0 {
			let approximateWidthOfText = collectionView.frame.width - 105
            let size = CGSize(width: approximateWidthOfText, height: 1000)
			let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body).withSize(14)]
			let estimatedFrame = NSString(string: post.content).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
			
			return CGSize(width: collectionView.frame.width - 20, height: estimatedFrame.height + 200)
		} else {
			let reply = replies[indexPath.item - 1]
            let approximateWidthOfText = collectionView.frame.width - 105
            let size = CGSize(width: approximateWidthOfText, height: 1000)
			let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body).withSize(14)]
            
			let estimatedFrame = NSString(string: reply.content).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return CGSize(width: collectionView.frame.width - 20, height: estimatedFrame.height + 150)
		}
	}
}

extension ProfileVC: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if let post = posts[indexPath.item] as? Post {
            let approximateWidthOfText = collectionView.frame.width - 105
            let size = CGSize(width: approximateWidthOfText, height: 1000)
			let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body).withSize(14)]
            
			let estimatedFrame = NSString(string: post.content).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return CGSize(width: collectionView.frame.width - 20, height: estimatedFrame.height + 200)
		} else {
			return CGSize(width: collectionView.frame.width - 20, height: 200)
		}
	}
}
