//
//  ProductListMoreCollectionViewCell.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 16..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class ProductListMoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var categoryName: UILabel!
    var aboutPageNum = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func moreButtonTouched(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let CategoryDetailViewController = storyboard.instantiateViewController(withIdentifier: "CategoryDetailViewController") as! CategoryDetailViewController
        CategoryDetailViewController.myPage = aboutPageNum
        self.window?.rootViewController?.show(CategoryDetailViewController, sender: nil)
    }
}
