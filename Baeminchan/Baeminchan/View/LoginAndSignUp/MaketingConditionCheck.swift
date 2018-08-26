//
//  MaketingConditionCheck.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 18..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class MaketingConditionCheck: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBox: UIImageView!
    
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var allOfButton: UIButton!
    var isItChecked = false{
        didSet{
            switch isItChecked {
            case true:
                checkBox.layer.borderWidth = 0
                checkBox.backgroundColor = UIColor(red: 0.1843, green: 0.7255, blue: 0.7020, alpha: 1)
                checkBox.image = UIImage(named: "checkOn")
            case false:
                checkBox.layer.borderWidth = 1
                checkBox.backgroundColor = .white
                checkBox.image = UIImage(named: "checkOff")
            }
        }
    }
    
    class func instanceFromNib() -> MaketingConditionCheck {
        return UINib(nibName: "MaketingConditionCheck", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MaketingConditionCheck
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDefault()
    }
    
    func setDefault() {
        let attributedString = NSMutableAttributedString(string: "내용보기")
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length))
        detailButton.setAttributedTitle(attributedString, for: .normal)
        detailButton.titleLabel?.textColor = .lightGray
        checkBox.layer.borderWidth = 1
        checkBox.layer.borderColor = UIColor(red: 0.9098, green: 0.9098, blue: 0.9098, alpha: 1).cgColor
        //        self.backgroundColor = .white
        detailButton.isHidden = true
    }
    @IBAction func checkAndCheckOut(_ sender: UIButton) {
        isItChecked = !isItChecked
    }
    
}
