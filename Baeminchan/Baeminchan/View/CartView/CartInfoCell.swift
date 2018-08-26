//
//  CartInfoCell.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 16..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit

protocol dissmissbuttonDelegate {
    func dismissCartItem()
    func changeAmountCartItem( count:Int)
}

class CartInfoCell: UITableViewCell {

    var delegate:dissmissbuttonDelegate?
    static let reusableIdentifier = "CartInfoCell"
    var state = true
    var count = -1
    @IBOutlet weak var checkButton: CheckBoxButton!
    
    @IBAction func checkButton(_ sender: Any) {
        if state{
            checkButton.backgroundColor = UIColor(displayP3Red: 0.369, green: 0.745, blue: 0.733, alpha: 1.0)
            checkButton.setBackgroundImage(UIImage(named: "ico-chk-on"), for: UIControlState.selected)
            state = false
        }else{
            checkButton.backgroundColor = UIColor.white
            checkButton.setBackgroundImage(UIImage(named: "ico-chk-off"), for: UIControlState.normal)
            state = true
        }
    }
    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var Label: UILabel!
    
    @IBOutlet weak var dismissbutton: CheckBoxButton!
    
    
    @IBAction func dissmissbutton(_ sender: Any) {
        delegate?.dismissCartItem()
    }
    
    @IBOutlet weak var price: UILabel! //itemtotalprice
    @IBOutlet weak var itemTotalPrice: UILabel!
    
    
    @IBAction func plusButton(_ sender: Any) {
        count += 1
        amountLabel.text = "\(count)"
    }
    @IBOutlet weak var amountLabel: UILabel!
    @IBAction func minusButton(_ sender: Any) {
        count -= 1
        amountLabel.text = "\(count)"
    }
    @IBAction func changeButton(_ sender: Any) {
        delegate?.changeAmountCartItem(count: count)
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
