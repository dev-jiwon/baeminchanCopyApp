//
//  AllSelectCell.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 16..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit

class AllSelectCell: UITableViewCell {

    static let reusableIdentifier = "AllSelectCell"
    
    var state = true

    @IBOutlet weak var checkButton: CheckBoxButton!
    
    @IBAction func tapedCheckButton( _ : UIButton){
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

    
    @IBAction func deleteButton(_ sender: Any) {
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
