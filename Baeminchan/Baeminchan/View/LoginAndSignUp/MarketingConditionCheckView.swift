//
//  MarketingConditionCheckView.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 18..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class MarketingConditionCheckView: UIView {
    var myHeight:CGFloat = 0
    
    let allOfCheck = MaketingConditionCheck.instanceFromNib()
    let partitionView = UIView()
    let conditionOption1 = MaketingConditionCheck.instanceFromNib()
    let conditionOption2 = MaketingConditionCheck.instanceFromNib()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let myDefaultWidth = self.frame.width
        let myDefaultHeight:CGFloat = 30
        self.backgroundColor = .white
        allOfCheck.frame = CGRect(x: 0, y: 10, width: myDefaultWidth, height: myDefaultHeight)
        allOfCheck.titleLabel.text = "전체 동의"
        allOfCheck.titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        allOfCheck.allOfButton.addTarget(self, action: #selector(MarketingConditionCheckView.allButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(allOfCheck)
        
        partitionView.frame = CGRect(x: 0, y: allOfCheck.frame.maxY + 10, width: myDefaultWidth, height: 1)
        partitionView.backgroundColor = UIColor(red: 0.9098, green: 0.9098, blue: 0.9098, alpha: 1)
        self.addSubview(partitionView)
        
        conditionOption1.frame = CGRect(x: 0, y: partitionView.frame.maxY + 5, width: myDefaultWidth, height: myDefaultHeight)
        conditionOption1.titleLabel.text = "이메일"
        conditionOption1.allOfButton.addTarget(self, action: #selector(MarketingConditionCheckView.someButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(conditionOption1)
        
        conditionOption2.frame = CGRect(x: 0, y: conditionOption1.frame.maxY, width: myDefaultWidth, height: myDefaultHeight + 5)
        conditionOption2.titleLabel.text = "휴대폰 문자 메시지"
        conditionOption2.allOfButton.addTarget(self, action: #selector(MarketingConditionCheckView.someButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(conditionOption2)
        
        myHeight = conditionOption2.frame.maxY
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func allButtonClicked(_ sender: UIButton) {
        conditionOption1.isItChecked = allOfCheck.isItChecked
        conditionOption2.isItChecked = allOfCheck.isItChecked
        
    }
    
    @IBAction func someButtonClicked(_ sender: UIButton) {
        if !conditionOption1.isItChecked || !conditionOption2.isItChecked{
            allOfCheck.isItChecked = false
        }
        if conditionOption1.isItChecked, conditionOption2.isItChecked{
            allOfCheck.isItChecked = true
        }
    }
}
