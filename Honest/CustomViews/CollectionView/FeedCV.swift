//
//  FeedCollectionVC.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit

class FeedCollectionVC: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        self.collectionView!.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseID)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseID, for: indexPath) as! PostCell
    
        return cell
    }

}
