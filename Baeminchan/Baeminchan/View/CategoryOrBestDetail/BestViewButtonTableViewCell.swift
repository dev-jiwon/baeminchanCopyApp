//
//  BestViewButtonTableViewCell.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 16..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class BestViewButtonTableViewCell: UITableViewCell {
    var numOfItem = 0
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    @IBOutlet var button6: UIButton!
    lazy var buttons = [button1, button2, button3, button4, button5, button6]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setButtons()
        button1.isEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func someButtonTouches(_ sender: UIButton) {
        setAllUnselected()
        sender.isEnabled = false
        NotificationCenter.default.post(name: Notification.Name("subCategoryNoti"), object: nil, userInfo: ["tagNum": sender.tag])
    }
    
    func setButtons() {
        for button in buttons {
            button?.layer.borderWidth = 0.2
            button?.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    func setAllUnselected() {
        for button in buttons {
            button?.isEnabled = true
        }
    }
}
