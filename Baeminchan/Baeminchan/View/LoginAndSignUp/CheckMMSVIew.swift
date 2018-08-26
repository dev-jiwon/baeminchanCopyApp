//
//  CheckMMSVIew.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 21..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CheckMMSVIew: UIView {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    var myKey:String = ""
    var phoneNum = ""
    
    @IBAction func checkMMSAction(_ sender: UIButton) {
        print("checkIt")
        checkUseAlamofire()
        
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    func checkUseAlamofire() {
        let url = "https://server.yeojin.me/api/users/phone/auth/"
        let parameters: Parameters = [
            "contact_phone": phoneNum,
            "auth_key": myKey
            ]
        
        Alamofire
            .request(url, method: .post, parameters: parameters)
            .validate(statusCode: 200..<400)
            .responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    print("폰될각이다")
                    self.isItOk(value: true)
                    NotificationCenter.default.post(name: Notification.Name("isPhoneNumCheckOK"), object: nil, userInfo: ["isPhoneNumCheckOK": true])
                    print(value)
                case .failure(let error):
                    self.isItOk(value: false)
                    print(error)
                }
            })
    }
    
    func isItOk(value: Bool) {
        if value {
            resultLabel.textColor = UIColor(red: 0.1843, green: 0.7255, blue: 0.7020, alpha: 1)
            resultLabel.text = "인증 성공"
            resultLabel.isHidden = false
        } else {
            resultLabel.textColor = UIColor(red: 0.9373, green: 0.5216, blue: 0.4902, alpha: 1)
            resultLabel.text = "인증 실패"
            resultLabel.isHidden = false
        }
    }
    
}
