//
//  SearchTextFieldTableViewCell.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 20..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class SearchTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setTextField()
        self.textField.delegate = self
        asdasd()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTextField() {
        textField.layer.borderColor = UIColor.red.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NotificationCenter.default.post(name: Notification.Name("searchValueNoti"), object: nil, userInfo: ["textValue": textField.text ?? ""])
        return true
    }
    
    func asdasd() {
        let myImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        myImage.contentMode = .center
        myImage.image = UIImage(named: "black_search")
        textField.leftView = myImage
        textField.leftViewMode = .always
        textField.layer.borderColor = UIColor(red: 0.2431, green: 0.7569, blue: 0.7294, alpha: 1).cgColor
        textField.layer.borderWidth = 0.5
        
//        textField.leftView =
    }

}
