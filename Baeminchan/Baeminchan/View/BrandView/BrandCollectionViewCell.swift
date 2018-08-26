//
//  BrandCollectionViewCell.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 16..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class BrandCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var subTitleLabel1: UILabel!
    @IBOutlet var subTitleLabel2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(imageName: String, mainTitle: String, subTitle1: String, subTitle2: String) {
        self.imageView.image = UIImage(named: imageName)
        self.mainTitleLabel.text = mainTitle
        self.subTitleLabel1.text = subTitle1
        self.subTitleLabel2.text = subTitle2
    }
    
}
