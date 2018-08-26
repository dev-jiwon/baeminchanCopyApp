//
//  CategoryDetailViewController.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 16..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CategoryDetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let url = "https://server.yeojin.me/api/products/"
    var numOfCell = 0
    var productArr: [ListProductModel] = []
    var myPage = 0                              //지금 이걸로 카테고리 분리받아 사용하고 있지만 나중에 메인 메뉴 생기면 바꿔야할듯
    var mySubPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("subCategoryNoti"), object: nil)
        let buttonCell = UINib(nibName: "BestViewButtonTableViewCell", bundle: nil)
        tableView.register(buttonCell, forCellReuseIdentifier: "BestViewButtonTableViewCell")
        setBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navigationItem.title = categoryNameArr[myPage]
        getCartData()
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CategoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard myPage == 0 else { return 3 }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var numForCase1 = 0; var numForCase2 = 0
        if myPage == 0 { numForCase1 = 100; numForCase2 = 1 }
        let viewWidth = view.frame.width
        switch indexPath.section{
        case 0:
            let height = 144 * viewWidth / 374
            return height
        case 1 + numForCase1:
            return 100
        case 2 - numForCase2:
            return (ProductCollectionViewCellInTableView().singleContentHeight + ProductCollectionViewCellInTableView().betweenTwoContent) * CGFloat(numOfCell)
        default:
            return (ProductCollectionViewCellInTableView().singleContentHeight + ProductCollectionViewCellInTableView().betweenTwoContent) * CGFloat(numOfCell)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var numForCase1 = 0; var numForCase2 = 0
        if myPage == 0 { numForCase1 = 100; numForCase2 = 1 }
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "bennerCell", for: indexPath) as! CategoryBannerTableViewCell
            //            cell.imageView?.image = UIImage(named: "categoryBannerNum\(myPage)")
            cell.myImageView.image = UIImage(named: "categoryBannerNum\(myPage)")
            return cell
        case 1 + numForCase1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BestViewButtonTableViewCell", for: indexPath) as! BestViewButtonTableViewCell
            var mymyPage = myPage
            if myPage == 0 { mymyPage = 4 }
            cell.numOfItem = myPage
            var numOfItemInCategory = categoryStringDic[parentCategoryArr[mymyPage]]!.count
            if numOfItemInCategory > 6 {
                numOfItemInCategory = 6
            } else {
                for index in numOfItemInCategory...6 {
                    cell.buttons[index-1]?.setTitle(" ", for: .normal)
                    cell.buttons[index-1]?.isEnabled = true
                }
            }
            for index in 0..<numOfItemInCategory {
                cell.buttons[index]?.setTitle((categoryStringDic[parentCategoryArr[mymyPage]]![index]), for: .normal)
            }
            return cell
        case 2 - numForCase2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath) as! BestViewProductCollectionViewTableViewCell
            cell.numOfContent = numOfCell
            print(numOfCell)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "bennerCell", for: indexPath)
            return cell
        }
    }
    
}

extension CategoryDetailViewController {
    func getData() {
        var param: Parameters = [       //아직 추천이 없기떄문에 아무거나 대충 넣어놓음
            "parent_category":"soup",
            "category":"전골"
        ]
        if myPage == 0 {
            print("추천은 아직 준비중입니다")
        } else {
            param = [
                "parent_category":parentCategoryArr[myPage].rawValue,
                "category":(categoryStringDic[parentCategoryArr[myPage]]![mySubPage])
            ]
        }
        
        Alamofire
            .request(url, method: .get, parameters: param)
            .validate(statusCode: 200..<400)
            .responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    var dataArr: [JSON] = []
                    let json = JSON(value)
                    dataArr = json["results"].arrayValue
                    self.productArr = []
                    for data in dataArr {
                        let myData = ListProductModel(
                            discountRate: data["discount_rate"].intValue,
                            price: data["price"].intValue,
                            salePrice: data["sale_price"].intValue,
                            thumbnailUrl: data["thumbnail_url1"].stringValue,
                            rawName: data["raw_name"].stringValue,
                            id: data["id"].stringValue,
                            description: data["description"].stringValue,
                            starPoint: data["avg_rating"].intValue,
                            numOfComment: data["comment_count"].intValue)
                        self.productArr.append(myData)
                        
                        print(myData.rawName)
                    }
                    
                    NotificationCenter.default.post(name: Notification.Name("categoryNotification"), object: nil, userInfo: ["dataArr": self.productArr])
                    self.tableView.reloadData()
                    let indexPath = NSIndexPath(row: NSNotFound, section: 0)
                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
                    self.numOfCell = dataArr.count
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    
    
    @objc func notificationReceived(notification: Notification) {
        guard let notificationUserInfo = notification.userInfo as? [String: Int],
            let myNowPage = notificationUserInfo["tagNum"] else { return }
        mySubPage = myNowPage
        getData()
    }
    
    func setBackButton() {
        let myImage = UIImage(named: "backBlack")
        let backBTNImage = myImage?.withRenderingMode(.alwaysTemplate)
        let backBTN = UIBarButtonItem(image: backBTNImage,
                                      style: .done,
                                      target: self,
                                      action: #selector(dismissThisView))
        backBTN.tintColor = .black
        navigationItem.leftBarButtonItem = backBTN
        
        let cartBtn = CartButton.instanceFromNib()
        cartBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let cartBarBtn = UIBarButtonItem(customView: cartBtn)
        self.navigationItem.rightBarButtonItem = cartBarBtn
//        self.navigationItem.rightBarButtonItem(cartBarBtn, animated: false)
    }
    
    @objc func dismissThisView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.popViewController(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            NotificationCenter.default.post(name: Notification.Name("unHideNavigationBar"), object: nil, userInfo: nil)
        })
    }
    
    func getCartData() {
        let url = "https://server.yeojin.me/api/carts/cartitemlist/"
        let header: HTTPHeaders = ["Authorization":"token \(ViewController.userToken ?? "")"]
        Alamofire
            .request(url, method: .get, parameters: nil, headers: header)
            .validate(statusCode: 200..<400)
            .responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value).arrayValue
                    let numOfCartItem = json.count
                    NotificationCenter.default.post(name: Notification.Name("changeCartData"), object: nil, userInfo: ["numOfItems": numOfCartItem])
                case .failure(let error):
                    print(error)
                }
            })
    }
}
