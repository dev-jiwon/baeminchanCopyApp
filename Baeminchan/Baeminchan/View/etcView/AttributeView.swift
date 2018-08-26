//
//  AttributeView.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 17..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//


import Foundation
import UIKit

@IBDesignable
final class AttributeView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor ?? UIColor.blue.cgColor) }
        set { layer.borderColor = newValue.cgColor }
    }
}
