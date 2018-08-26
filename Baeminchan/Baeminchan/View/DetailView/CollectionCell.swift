//
//  CollectionCell.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 14..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {

    static let reusableIdentifier = "CollectionCell"
    
    @IBOutlet weak var detailImage:UIImageView!
    @IBOutlet weak var label1:UILabel!
    @IBOutlet weak var label2:UILabel!
    @IBOutlet weak var label3:UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
