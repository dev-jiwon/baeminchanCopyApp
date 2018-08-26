//
//  SignUpTextField.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 18..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class SignUpTextField: UITextField, UITextFieldDelegate {
    let defaultColor = UIColor(red: 0.9098, green: 0.9098, blue: 0.9098, alpha: 1)
    let changedColor = UIColor(red: 0.1843, green: 0.7255, blue: 0.7020, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.borderStyle = .none
        self.layer.borderWidth = 1
        self.layer.borderColor = defaultColor.cgColor
        
        self.addTarget(self, action: #selector(SignUpTextField.textFieldDidBeginEditing(_:)), for: UIControlEvents.editingDidBegin)
        self.addTarget(self, action: #selector(SignUpTextField.textFieldDidEndEditing(_:)), for: UIControlEvents.editingDidEnd)
        
        self.font = UIFont.systemFont(ofSize: 15)
        
        //패딩 줘서 왼쪽 변과 거리 주기
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
        
        
        //약간의 그림자로 잇어보이게
        //        self.layer.masksToBounds = false
        //        self.layer.shadowColor = UIColor.black.cgColor
        //        self.layer.shadowOffset = CGSize(width: 0.1, height: 0.1)
        //        self.layer.shadowOpacity = 0.1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //    func createBorder(){
    //        let border = CALayer()
    //        let width = CGFloat(2.0)
    //        border.borderColor = UIColor(red: 55/255, green: 78/255, blue: 95/255, alpha: 1.0).cgColor
    //        border.frame = CGRect(x: 0, y: self.frame.size.height-width, width: self.frame.size.width, height: self.frame.size.height)
    //        border.borderWidth = width
    //        self.layer.addSublayer(border)
    //        self.layer.masksToBounds = true
    //        //print("border created")
    //    }
    @IBAction func textFieldDidBeginEditing(_ sender: UITextField) {
        self.layer.borderColor = changedColor.cgColor
    }
    @IBAction func textFieldDidEndEditing(_ sender: UITextField) {
        self.layer.borderColor = defaultColor.cgColor
    }
}
