//
//  LastConditionCheckView.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 18..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class LastConditionCheckView: UIView {
    
    var myHeight:CGFloat = 0
    
    let allOfCheck = MaketingConditionCheck.instanceFromNib()
    let partitionView = UIView()
    let conditionOption1 = MaketingConditionCheck.instanceFromNib()
    let conditionOption2 = MaketingConditionCheck.instanceFromNib()
    let conditionOption3 = MaketingConditionCheck.instanceFromNib()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let myDefaultWidth = self.frame.width
        let myDefaultHeight:CGFloat = 50
        
        allOfCheck.frame = CGRect(x: 0, y: 10, width: myDefaultWidth, height: myDefaultHeight)
        allOfCheck.titleLabel.text = "전체 동의"
        allOfCheck.titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        allOfCheck.allOfButton.addTarget(self, action: #selector(LastConditionCheckView.allButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(allOfCheck)
        
        partitionView.frame = CGRect(x: 0, y: allOfCheck.frame.maxY + 10, width: myDefaultWidth, height: 1)
        partitionView.backgroundColor = UIColor(red: 0.9098, green: 0.9098, blue: 0.9098, alpha: 1)
        self.addSubview(partitionView)
        
        conditionOption1.frame = CGRect(x: 0, y: partitionView.frame.maxY + 5, width: myDefaultWidth, height: myDefaultHeight)
        conditionOption1.titleLabel.text = "이용약관에 동의합니다.(필수)"
        conditionOption1.detailButton.isHidden = false
        conditionOption1.detailButton.addTarget(self, action: #selector(LastConditionCheckView.aboutAgeCondition(_:)), for: UIControlEvents.touchUpInside)
        conditionOption1.allOfButton.addTarget(self, action: #selector(LastConditionCheckView.someButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(conditionOption1)
        
        conditionOption2.frame = CGRect(x: 0, y: conditionOption1.frame.maxY + 5, width: myDefaultWidth, height: myDefaultHeight)
        conditionOption2.titleLabel.text = "개인정보 수집 및 이용에 동의합니다.(필수)"
        conditionOption2.detailButton.isHidden = false
        conditionOption2.detailButton.addTarget(self, action: #selector(LastConditionCheckView.aboutAgeCondition(_:)), for: UIControlEvents.touchUpInside)
        conditionOption2.allOfButton.addTarget(self, action: #selector(LastConditionCheckView.someButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(conditionOption2)
        
        conditionOption3.frame = CGRect(x: 0, y: conditionOption2.frame.maxY, width: myDefaultWidth, height: myDefaultHeight + 5)
        conditionOption3.titleLabel.text = "개인정보 수집 및 이용에 동의합니다.(선택)"
        conditionOption3.detailButton.isHidden = false
        conditionOption3.detailButton.addTarget(self, action: #selector(LastConditionCheckView.aboutAgeCondition(_:)), for: UIControlEvents.touchUpInside)
        conditionOption3.allOfButton.addTarget(self, action: #selector(LastConditionCheckView.someButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(conditionOption3)
        myHeight = conditionOption3.frame.maxY
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
        conditionOption3.isItChecked = allOfCheck.isItChecked
    }
    
    @IBAction func someButtonClicked(_ sender: UIButton) {
        if !conditionOption1.isItChecked || !conditionOption2.isItChecked || !conditionOption3.isItChecked{
            allOfCheck.isItChecked = false
        }
        if conditionOption1.isItChecked, conditionOption2.isItChecked, conditionOption3.isItChecked{
            allOfCheck.isItChecked = true
        }
    }
    
    @IBAction func aboutAgeCondition(_ sender: UIButton) {
        let popup: DetailView = UINib(nibName: "DetailView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! DetailView
        popup.frame = (super.superview?.frame)!
        popup.titleLabel.text = "이용약관"
        let viewColor = UIColor.black
        popup.backgroundColor = viewColor.withAlphaComponent(0.3)
        super.superview?.superview?.addSubview(popup)
    }
    
}
