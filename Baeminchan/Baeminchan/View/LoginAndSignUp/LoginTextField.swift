//
//  LoginTextField.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 18..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

@IBDesignable
final class LoginTextField: UITextField {
    let defaultColor = UIColor(red: 0.7922, green: 0.7922, blue: 0.7922, alpha: 1)
    let changedColor = UIColor(red: 0.1843, green: 0.7255, blue: 0.7020, alpha: 1)
    
    @IBInspectable var rightClearButton: UIImage? {
        get { return (rightView as? UIButton)?.backgroundImage(for: .normal) }
        set {
            let origImage = newValue?.withRenderingMode(.alwaysTemplate)
            let rightImageButton = UIButton()
            rightImageButton.setImage(origImage, for: .normal)
            rightImageButton.frame.size = CGSize(width: 40, height: 40)
            rightImageButton.tintColor = UIColor(red: 0.1843, green: 0.7255, blue: 0.7020, alpha: 1)
            rightImageButton.addTarget(self, action: #selector(LoginTextField.clearClicked(_:)), for: UIControlEvents.touchUpInside)
            rightView = rightImageButton
            rightViewMode = .whileEditing
        }
    }
    
    var underlineLayer: CALayer?
    @IBInspectable var underlindeColor: UIColor {
        get { return UIColor(cgColor: underlineLayer?.borderColor ?? UIColor.lightGray.cgColor) }
        set {
            let underlineLayer = CALayer()
            underlineLayer.borderWidth = 1
            underlineLayer.borderColor = newValue.cgColor
            underlineLayer.frame = CGRect(x: 0, y: frame.height + 13, width: frame.width, height: 1)
            self.underlineLayer = underlineLayer
            layer.addSublayer(underlineLayer)
            addTarget(self, action: #selector(LoginTextField.edittingDidBeginAction(_:)), for: UIControlEvents.editingDidBegin)
            addTarget(self, action: #selector(LoginTextField.editingDidEndAction(_:)), for: UIControlEvents.editingDidEnd)
        }
    }
    
    //텍스트필드 오른쪽 X터치시 모든 이멘트 삭제
    @IBAction func clearClicked(_ sender:UIButton)
    {
        text = ""
    }
    
    @IBAction func edittingDidBeginAction(_ sender: UITextField)
    {
        underlindeColor = changedColor
    }
    
    @IBAction func editingDidEndAction(_ sender: UITextField)
    {
        underlindeColor = defaultColor
    }
}
