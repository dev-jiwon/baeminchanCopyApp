//
//  DetailView.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 18..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    
    @IBAction func closeView(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
}
