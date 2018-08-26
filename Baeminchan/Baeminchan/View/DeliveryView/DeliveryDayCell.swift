//
//  DeliveryDayCell.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 16..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit



class DeliveryDayCell: UITableViewCell {

    

    static let reusableIdentifier = "DeliveryDayCell"

    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var deliveryPrice: UILabel!
    @IBOutlet weak var payPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
