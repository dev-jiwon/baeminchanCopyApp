//
//  ItemInfoCell.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 14..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit

class ItemInfoCell: UITableViewCell {

    static let reusableIdentifier = "ItemInfoCell"

    
    @IBOutlet weak var rawNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var salePriceLabel: UILabel!
    @IBOutlet weak var discountRateLabel: UILabel!
    @IBOutlet weak var deliveryDaysLabel: UILabel!
    @IBOutlet weak var deliveryTypeLabel: UILabel!
    @IBOutlet weak var eventLabel: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        NotificationCenter.default.addObserver(self, selector: #selector(notification(notification:)), name: Notification.Name("detailPageTopScrollNoti"), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
