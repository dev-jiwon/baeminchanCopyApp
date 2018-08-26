//
//  MainHeaderView.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 16..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class MainHeaderView: UITableViewHeaderFooterView {
    
    let baeminColor = UIColor(red: 0.1843, green: 0.7255, blue: 0.7020, alpha: 1)
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var firstTitle: UILabel!
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var secondTitle: UILabel!
    
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var thirdTitle: UILabel!
    
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var fourthImageView: UIImageView!
    @IBOutlet weak var fourthTitle: UILabel!
    
    @IBOutlet weak var fifthView: UIView!
    @IBOutlet weak var fifthImageView: UIImageView!
    @IBOutlet weak var fifthTitle: UILabel!
    
    var firstViewArr: [UIView] = []
    var secondViewArr: [UIView] = []
    var thirdViewArr: [UIView] = []
    var fourthViewArr: [UIView] = []
    var fifthViewArr: [UIView] = []
    var allOfViewArr: [[UIView]] = []
    
    var whiteImageNameArr = ["category_best_white", "category_side_dish_white", "category_main_dish_white", "category_soup_white", "category_snack_white"]
    var blackImageNameArr = ["category_best_black", "category_side_dish_black", "category_main_dish_black", "category_soup_black", "category_snack_black"]
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeButtonBorder()
        setViewArr()
    }
    
    func makeButtonBorder() {
        for view in [firstView, secondView, thirdView, fourthView, fifthView] {
            view?.layer.borderWidth = 0.2
            view?.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    func setViewArr() {
        firstViewArr = [firstView, firstImageView, firstTitle]
        secondViewArr = [secondView, secondImageView, secondTitle]
        thirdViewArr = [thirdView, thirdImageView, thirdTitle]
        fourthViewArr = [fourthView, fourthImageView, fourthTitle]
        fifthViewArr = [fifthView, fifthImageView, fifthTitle]
        allOfViewArr = [firstViewArr, secondViewArr, thirdViewArr, fourthViewArr, fifthViewArr]
    }
    
    @IBAction func someButtonClicked(_ sender: UIButton) {
        //기본 색으로 초기화
        for index in 0..<allOfViewArr.count{
            allOfViewArr[index][0].backgroundColor = .white
            (allOfViewArr[index][1] as! UIImageView).image = UIImage(named: blackImageNameArr[index])
            (allOfViewArr[index][2] as! UILabel).textColor = .black
        }
        //tag를 이용해서 색 효과 주기
        let numberOfItem = sender.tag
        allOfViewArr[numberOfItem][0].backgroundColor = backgroundColor
        (allOfViewArr[numberOfItem][1] as! UIImageView).image = UIImage(named: whiteImageNameArr[numberOfItem])
        (allOfViewArr[numberOfItem][2] as! UILabel).textColor = .white
        
        NotificationCenter.default.post(name: Notification.Name("notiWhatPageIsThis"), object: sender, userInfo: ["numberOfItem": numberOfItem]) //noti1
    }
    
    
    
}
