//
//  OrderPriceCell.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 16..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit

protocol CalenderButtonDelegate: class { //프로토콜 aa는 func b()를 꼭 구현해야한다.
    func CalenderButton()
}

class OrderPriceCell: UITableViewCell {

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var sumPrice: UILabel!
    @IBOutlet weak var deliveryPrice: UILabel!
    @IBOutlet weak var sumPoint: UILabel!
    
    static let reusableIdentifier = "OrderPriceCell"
    
    weak var delegate:CalenderButtonDelegate?
    
    @IBAction private func CalenderButton(_ sender: UIButton){
        delegate?.CalenderButton()
    }
    
    @IBAction func retrunButtonTouched(_ sender: UIButton) {
        self.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
