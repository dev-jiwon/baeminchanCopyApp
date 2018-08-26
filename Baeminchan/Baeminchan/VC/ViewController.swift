//
//  ViewController.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 16..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import XLPagerTabStrip

class ViewController: ButtonBarPagerTabStripViewController {
    
    let sideMenuView = SideMenuView.instanceFromNib()

    @IBOutlet weak var shadowView: UIView!
    let baeminColor = UIColor(red: 0.2431, green: 0.7569, blue: 0.7294, alpha: 1)
    var userName:String = ""
    static var userToken: String? = nil
    var userCartListArr: [CartItem] = []
    static var numOfCartItems = 0
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(showNavigationBar(notification:)), name: Notification.Name("unHideNavigationBar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeSideMenu(notification:)), name: Notification.Name("logoutNoti"), object: nil)
        setButtonBar()
        super.viewDidLoad()
        setNavigation()
        setSideMenuView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
       changeSideMenu(notification: nil)
    }
    
    @objc func changeSideMenu(notification: Notification?) {
        if UserDefaults.standard.object(forKey: "userToken") != nil {   //로그인이 된 상태임
            ViewController.userToken = UserDefaults.standard.string(forKey: "userToken")
            sideMenuView.topView.backgroundColor = baeminColor
            getUserData()
        } else {    //로그아웃이 된 상태임
            ViewController.userToken = nil
            sideMenuView.topView.backgroundColor = UIColor(red: 0.4039, green: 0.4078, blue: 0.4118, alpha: 1)
            sideMenuView.nameOrLoginLabel.text = "로그인 해주세요 "
            print("로그아웃 되어있음")
        }
    }
    
    // MARK: - PagerTabStripDataSource
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = storyboard.instantiateViewController(withIdentifier: "MainView")
        let discountView = storyboard.instantiateViewController(withIdentifier: "DiscountViewController")
        let brandView = storyboard.instantiateViewController(withIdentifier: "BrandViewController")
//        let child_1 = ChildExampleViewController(itemInfo: "홈")
        return [mainView, discountView, brandView]
    }
    
    @objc private func menuButtonTouched(_ sender: UIButton) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIView.animate(withDuration: 0.5) {
            self.sideMenuView.frame.origin = CGPoint.zero
        }
        print("menu")
    }
    
    @objc private func serchButtonTouched(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") //Storyboard ID를 설정해줘야 한다.
        show(secondViewController, sender: nil)
        print("serch")
    }
    
    @objc private func cartButtonTouched(_ sender: UIButton) {
        print("cart")
    }
}

//navigation이랑 위에 뷰 관련
extension ViewController {
    func setButtonBar() {
        settings.style.buttonBarHeight = 30
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = self.baeminColor
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarOriginY = self.navigationController?.navigationBar.frame.maxY
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.baeminColor
        }
    }
    
    func setNavigation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let logo = UIImage(named: "navigationLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        let menuImage = UIImage(named: "black_menu")!
        let searchImage = UIImage(named: "black_search")!
        
        let menuBtn: UIButton = UIButton(type: .custom)
        menuBtn.setImage(menuImage, for: .normal)
        menuBtn.addTarget(self, action: #selector(menuButtonTouched(_:)), for: UIControlEvents.touchUpInside)
        menuBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let menuBarBtn = UIBarButtonItem(customView: menuBtn)
        
        let searchBtn: UIButton = UIButton(type: .custom)
        searchBtn.setImage(searchImage, for: .normal)
        searchBtn.addTarget(self, action: #selector(serchButtonTouched(_:)), for: UIControlEvents.touchUpInside)
        searchBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let searchBarBtn = UIBarButtonItem(customView: searchBtn)
        
        let cartBtn = CartButton.instanceFromNib()
        cartBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let cartBarBtn = UIBarButtonItem(customView: cartBtn)
        
        self.navigationItem.setLeftBarButton(menuBarBtn, animated: false)
        self.navigationItem.setRightBarButtonItems([cartBarBtn, searchBarBtn], animated: false)
    }
}

//sideMenu 관련
extension ViewController {
    func setSideMenuView() {
        let viewWidth = view.frame.width
        let viewHeight = view.frame.height
        print(viewWidth, viewHeight)
        sideMenuView.frame = CGRect(x: -viewWidth, y: 0, width: viewWidth, height: viewHeight)
        let rightImage = UIImage(named: "right")?.withRenderingMode(.alwaysTemplate)
        sideMenuView.loginRightImageView.image = rightImage
        sideMenuView.loginRightImageView.tintColor = .white
        for index in 0...sideMenuView.imageViews.count-1 {
            let myImage = UIImage(named: "side-menu-under\(index+1)")?.withRenderingMode(.alwaysTemplate)
            sideMenuView.imageViews[index]?.image = myImage
            sideMenuView.imageViews[index]?.tintColor = .black
        }
        self.view.addSubview(sideMenuView)
    }
    
    @objc func showNavigationBar(notification: Notification) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func getUserData() {
//        let url = "https://server.yeojin.me/api/users/detail/"      //지금 pk값을 이용해서 우선 할당해놓음
        let url = "https://server.yeojin.me/api/carts/usercart/"
        let header: HTTPHeaders = ["Authorization":"token \(ViewController.userToken!)"]
        Alamofire
            .request(url, method: .get, parameters: nil, headers: header)
            .validate(statusCode: 200..<400)
            .responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let userJson = json["user"]
                    self.userName = userJson["fullname"].stringValue
                    self.sideMenuView.nameOrLoginLabel.attributedText = self.getUserNameForThisStyle(name: self.userName)
                    let cartJson = json["cart_items"]
                    let myCartArr = cartJson.arrayValue
                    self.userCartListArr = []
                    for cartItem in myCartArr {
                        let myCartItem = CartItem(pk: cartItem["pk"].intValue,
                                                  productId: cartItem["product"].intValue,
                                                  amount: cartItem["amount"].intValue,
                                                  itemTotalPrice: cartItem["item_total_price"].intValue)
                        self.userCartListArr.append(myCartItem)
                    }
                    NotificationCenter.default.post(name: Notification.Name("changeCartData"), object: nil, userInfo: ["numOfItems": self.userCartListArr.count])
                    ViewController.numOfCartItems = self.userCartListArr.count
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    func getUserNameForThisStyle(name: String) -> NSMutableAttributedString {
        let userName = name + " 님  "
        let font = UIFont.systemFont(ofSize: 17)
        let attributedString = NSMutableAttributedString(string: userName)
        let range = (userName as NSString).range(of: " 님  ")
        attributedString.addAttribute(NSAttributedStringKey.font, value: font, range: range)
        return attributedString
    }
}
