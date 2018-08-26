//
//  MainViewController.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 16..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import SwiftyJSON
import XLPagerTabStrip

class MainViewController: UIViewController, IndicatorInfoProvider {
    var itemInfo: IndicatorInfo = "홈"
    let loadingImageView = UIImageView()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let url = "https://server.yeojin.me/api/products/"
    var couponImageCellMaxY: CGFloat = 0
    var productArr: [ListProductModel] = []
    var numOfCell = 0
    var myNowPage2 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let headerNib = UINib.init(nibName: "MainHeaderView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "MainHeaderView")
        getData(nowPage: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendDataToCollectionView(notification:)), name: Notification.Name("notiWhatPageIsThis"), object: nil)   //noti1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //header 관련
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MainHeaderView") as! MainHeaderView
            return headerView
        } else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 60
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewWidth = view.frame.width
        switch indexPath.section {
        case 0:
            let height = 345 * viewWidth / 588
            return height
        case 1:
            let height = 174 * viewWidth / 588 + 10
            return height
        case 2:
            return (290 + 30) * CGFloat(numOfCell) + 40 + 30 + self.navigationController!.navigationBar.frame.maxY
            //위 수치는 아래에서 얻은 값들이다
//                (ProductCollectionViewCellInTableView().singleContentHeight + ProductCollectionViewCellInTableView().betweenTwoContent) * CGFloat(numOfCell) + ProductCollectionViewCellInTableView().moreButtonHeight + 30 + self.navigationController!.navigationBar.frame.maxY
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "couponImageCell", for: indexPath)
            couponImageCellMaxY = cell.frame.maxY
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath) as! ProductCollectionViewCellInTableView
            
            return cell
        }
    }
}

extension MainViewController {
    func getData(nowPage: Int) {
        var param: Parameters = [:]
        switch nowPage {
        case 0:
            param = ["parent_category":parentCategory.아이반찬.rawValue, "category":아이반찬.어린이반찬.rawValue]
        case 1:
            param = ["parent_category":parentCategory.밑반찬.rawValue, "category":밑반찬.김치.rawValue]
        case 2:
            param = ["parent_category":parentCategory.메인반찬.rawValue, "category":메인반찬.고기반찬.rawValue]
        case 3:
            param = ["parent_category":parentCategory.국.rawValue, "category":국.국.rawValue]
        case 4:
            param = ["parent_category":parentCategory.간식.rawValue, "category":간식.과일.rawValue]
        default:
            param = ["parent_category":"soup", "category":"전골"]
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
                    }
                    
                    NotificationCenter.default.post(name: Notification.Name("notiSetMainData"), object: nil, userInfo: ["dataArr": self.productArr, "numberOfItem":self.myNowPage2])
                    self.tableView.reloadData()
                    let indexPath = NSIndexPath(row: NSNotFound, section: 2)
                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
                    
                    //*******************서버의 문제로 데이터 임시로 12개 만 받아서 집어 넣음 *******************
                    self.numOfCell = dataArr.count
//                    self.numOfCell = 12
                case .failure(let error):
                    print(error)
                }
                
            })
    }
    
    @objc func sendDataToCollectionView(notification: Notification) {   //noti1
        guard let notificationUserInfo = notification.userInfo as? [String: Int],
            let myNowPage = notificationUserInfo["numberOfItem"] else { return }
        myNowPage2 = myNowPage
        getData(nowPage: myNowPage)
        //여기에 변경하려는 데이터를 넣으면 된다
    }
}

