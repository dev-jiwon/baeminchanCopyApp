//
//  SideMenuView.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 18..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SideMenuView: UIView {

    private let xibName = "SideMenuView"
    
    @IBOutlet var topView: UIView!
    @IBOutlet var nameOrLoginLabel: UILabel!
    //아래쪽 버튼들
    @IBOutlet var underImageView1: UIImageView!
    @IBOutlet var underImageView2: UIImageView!
    @IBOutlet var underImageView3: UIImageView!
    @IBOutlet var underImageView4: UIImageView!
    @IBOutlet var underImageView5: UIImageView!
    @IBOutlet var underImageView6: UIImageView!
    lazy var imageViews = [underImageView1, underImageView2, underImageView3, underImageView4, underImageView5, underImageView6]
    
    
    @IBOutlet var loginRightImageView: UIImageView!
    
    class func instanceFromNib() -> SideMenuView {
        return UINib(nibName: "SideMenuView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SideMenuView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        if isItLogined() {
            postAlert()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") //Storyboard ID를 설정해줘야 한다.
            self.window?.rootViewController?.show(loginViewController, sender: nil)
        }
    }
    
    @IBAction func someCategoryButtonTouched(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        UIView.animate(withDuration: 0.5) {
            self.frame.origin = CGPoint(x: -self.frame.width, y: 0)
        }
        NotificationCenter.default.post(name: Notification.Name("unHideNavigationBar"), object: nil, userInfo: nil)
        let CategoryDetailViewController = storyboard.instantiateViewController(withIdentifier: "CategoryDetailViewController") as! CategoryDetailViewController
        CategoryDetailViewController.myPage = sender.tag
        self.window?.rootViewController?.show(CategoryDetailViewController, sender: nil)
        print(sender.tag)
    }
    
    
    @IBAction func closeThisView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.frame.origin = CGPoint(x: -self.frame.width, y: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            NotificationCenter.default.post(name: Notification.Name("unHideNavigationBar"), object: nil, userInfo: nil)
        })
    }
    
    func isItLogined() -> Bool {
        if UserDefaults.standard.object(forKey: "userToken") != nil {   //로그인이 된 상태임
            return true
        } else {    //로그아웃이 된 상태임
            return false
        }
    }
    
    func postAlert() {
        let alertController = UIAlertController(title: "로그아웃하시겠습니까?",message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "예", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
            self.logout()
            
        }
        
        let cancelButton = UIAlertAction(title: "아니오", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(cancelButton)
        alertController.addAction(okAction)
        
        self.window?.rootViewController?.present(alertController,animated: true,completion: nil)
    }
    
    func logout() {
        let url = "https://server.yeojin.me/api/users/logout/"
        let myToken = "Token \(UserDefaults.standard.string(forKey: "userToken")!)"
        let header: HTTPHeaders = ["Authorization":myToken]
        Alamofire
            .request(url, method: .get, parameters: nil, headers: header)
            .validate(statusCode: 200..<400)
            .responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    UserDefaults.standard.removeObject(forKey: "userToken")
                    self.window?.rootViewController?.viewWillAppear(false)
                    NotificationCenter.default.post(name: Notification.Name("logoutNoti"), object: nil, userInfo: nil)
                    NotificationCenter.default.post(name: Notification.Name("changeCartData"), object: nil, userInfo: ["numOfItems": 0])
                case .failure(let error):
                    print(error)
                }
                
            })
        
    }

}
