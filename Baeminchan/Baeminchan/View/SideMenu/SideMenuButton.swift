//
//  SideMenuButton.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 18..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class SideMenuButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 0.2
        print("hi")
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
}
