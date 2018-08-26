//
//  DetailMenubarCell.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 14..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit



protocol ListReloadDelegate: class { //프로토콜 aa는 func b()를 꼭 구현해야한다.
    func ListReload(prameter : String)
}

class DetailMenubarCell: UITableViewCell {
    
    weak var delegate: ListReloadDelegate?
    
    
    static let reusableIdentifier = "DetailMenubarCell"
    var buttonSelected: Bool = false
    
    @IBOutlet weak var button1:UIButton!
    @IBOutlet weak var button2:UIButton!
    @IBOutlet weak var button3:UIButton!
    @IBOutlet weak var button4:UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        button1.layer.borderColor = UIColor(displayP3Red: 0.894, green: 0.894, blue: 0.894, alpha: 1).cgColor
        button1.layer.borderWidth = 1
        button2.layer.borderColor = UIColor(displayP3Red: 0.894, green: 0.894, blue: 0.894, alpha: 1).cgColor
        button2.layer.borderWidth = 1
        button3.layer.borderColor = UIColor(displayP3Red: 0.894, green: 0.894, blue: 0.894, alpha: 1).cgColor
        button3.layer.borderWidth = 1
        button4.layer.borderColor = UIColor(displayP3Red: 0.894, green: 0.894, blue: 0.894, alpha: 1).cgColor
        button4.layer.borderWidth = 1
        button1.backgroundColor = UIColor(displayP3Red: 0.208, green: 0.757, blue: 0.733, alpha: 1)
    }
    
    
    //뷰가할일 버튼이할일.
    @IBAction private func tapedButton1(_ sender: UIButton){
        print("taped1")
        delegate?.ListReload(prameter: "상세정보")
        if buttonSelected {
            buttonSelected = false
        }else{
            buttonSelected = true
            button1.backgroundColor = UIColor(displayP3Red: 0.208, green: 0.757, blue: 0.733, alpha: 1)
            button2.backgroundColor = UIColor.white
            button3.backgroundColor = UIColor.white
            button4.backgroundColor = UIColor.white
            button1.setTitleColor(UIColor.white, for: UIControlState.normal)

        }
        
    }
    @IBAction private func tapedButton2(_ sender: UIButton){
        print("taped2")
        delegate?.ListReload(prameter: "후기")
        if buttonSelected {
            buttonSelected = false
        }else{
            buttonSelected = true
            button2.backgroundColor = UIColor(displayP3Red: 0.208, green: 0.757, blue: 0.733, alpha: 1)
            button1.backgroundColor = UIColor.white
            button3.backgroundColor = UIColor.white
            button4.backgroundColor = UIColor.white
        }
        
    }
    @IBAction private func tapedButton3(_ sender: UIButton){
        print("taped3")
        delegate?.ListReload(prameter: "문의")
        if buttonSelected {
            buttonSelected = false
        }else{
            buttonSelected = true
            button3.backgroundColor = UIColor(displayP3Red: 0.208, green: 0.757, blue: 0.733, alpha: 1)
            button1.backgroundColor = UIColor.white
            button4.backgroundColor = UIColor.white
            button2.backgroundColor = UIColor.white
        }
        
    }
    @IBAction private func tapedButton4(_ sender: UIButton){
        print("taped4")
        delegate?.ListReload(prameter: "배송/교환")
        if buttonSelected {
            buttonSelected = false
        }else{
            buttonSelected = true
            button4.backgroundColor = UIColor(displayP3Red: 0.208, green: 0.757, blue: 0.733, alpha: 1)
            button1.backgroundColor = UIColor.white
            button3.backgroundColor = UIColor.white
            button2.backgroundColor = UIColor.white
        }
        
        
    }
    
    
}




