//
//  PageControlLabel.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 16..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class PageControlLabel: UILabel {
    
    var numOfPages = 0 {
        didSet{
            setText()
        }
    }
    
    var nowPage = 1 {
        didSet{
            setText()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0, alpha: 0.3)
        self.textColor = .white
        self.textAlignment = .center
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor.white.cgColor
        self.font = UIFont.boldSystemFont(ofSize: 11)
        self.layer.cornerRadius = frame.width/4
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setText() {
        self.text = "\(nowPage)/\(numOfPages)"
    }
    
}
