//
//  SignUpNotiUILabel.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 18..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class SignUpNotiUILabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .red
        font = UIFont.systemFont(ofSize: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
