//
//  AnotherItemCell.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 14..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit
import Kingfisher

class AnotherItemCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var relatedProducts: [relatedProductModel] = []     //나지원
    var otherProducts: [Products.RelatedProducts] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: CollectionCell.reusableIdentifier)
    }
    
    func sendRalatedProducts() {
        self.collectionView.reloadData()
    }
    
}

extension AnotherItemCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reusableIdentifier, for: indexPath) as! CollectionCell
        
        guard relatedProducts.count > 0 else {return cell}
        let arr = relatedProducts[indexPath.row]
        let url = URL(string: arr.thumbnailUrl)
        cell.detailImage.kf.setImage(with: url)
        cell.label1.text = arr.rawName
        cell.label2.text = "\(arr.salePrice)" + "원"
        cell.label3.text = "\(arr.price)" + "원"
        return cell
        
    }
}


extension AnotherItemCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 200)
    }
    
}

