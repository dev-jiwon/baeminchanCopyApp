//
//  PayInfoCell.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 16..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit

class ProductInfoCell: UITableViewCell {

    
    static let reusableIdentifier = "ProductInfoCell"

    @IBOutlet weak var Imageview: UIImageView!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
