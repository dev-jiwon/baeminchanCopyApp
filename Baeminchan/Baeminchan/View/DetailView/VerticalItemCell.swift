//
//  VerticalItemCell.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 22..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit
import Kingfisher

class VerticalItemCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var relatedProducts: [String] = []     //나지원
    
    var otherProducts: [Products.ProductImageSet] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "DeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DeCollectionViewCell.reusableIdentifier)
        collectionView.isScrollEnabled = false
        //        self.collectionView.reloadData()
    }
    
    func sendRalatedProducts() {
        self.collectionView.reloadData()
    }
    
}

extension VerticalItemCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeCollectionViewCell.reusableIdentifier, for: indexPath) as! DeCollectionViewCell
        
        guard relatedProducts.count > 0 else {return cell}
        let arr = relatedProducts[indexPath.row]
        let url = URL(string: arr)
        cell.Imageview.kf.setImage(with: url)
       
        return cell
    }
}


extension VerticalItemCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 370, height: 600)
    }
    

}
