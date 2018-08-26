//
//  PickerTextField.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 18..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class PickerTextField: UITextField {
    
    let defaultColor = UIColor(red: 0.9098, green: 0.9098, blue: 0.9098, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.borderStyle = .none
        self.layer.borderWidth = 1
        self.layer.borderColor = defaultColor.cgColor
        self.selectedTextRange = nil
        self.font = UIFont.systemFont(ofSize: 15)
        
        //패딩 줘서 왼쪽 변과 거리 주기
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        let myImage = UIImageView()
        myImage.frame = CGRect(x: 0, y: 0, width: 30, height: 8)
        myImage.image = UIImage(named: "pickerImage")
        myImage.contentMode = .scaleAspectFit
        self.rightView = myImage
        self.rightViewMode = .always
        self.textColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
