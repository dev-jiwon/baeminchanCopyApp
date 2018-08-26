//
//  DiscountViewController.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 16..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import XLPagerTabStrip
import SwiftyJSON

class DiscountViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let url = "https://server.yeojin.me/api/products/discount/"      //사실 여긴 할인 리스트니까 할인리스트 나오면 바꿔야함
    var numOfCell = 0
    var productArr: [ListProductModel] = []
    var param: Parameters = [ "min" : "1" ]
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("subCategoryNoti"), object: nil)

        let buttonCell = UINib(nibName: "BestViewButtonTableViewCell", bundle: nil)
        tableView.register(buttonCell, forCellReuseIdentifier: "BestViewButtonTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        let indexPath = NSIndexPath(row: NSNotFound, section: 0)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension DiscountViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewWidth = view.frame.width
        switch indexPath.section{
        case 0:
            let height = 144 * viewWidth / 374
            return height
        case 1:
            return 100
        default:
            return (ProductCollectionViewCellInTableView().singleContentHeight + ProductCollectionViewCellInTableView().betweenTwoContent) * CGFloat(numOfCell) + 30 + 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "bennerCell", for: indexPath) as! CategoryBannerTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BestViewButtonTableViewCell", for: indexPath) as! BestViewButtonTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "discountList", for: indexPath) as! DiscountProductTableViewCell
            cell.numOfContent = numOfCell
            print(numOfCell)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "bennerCell", for: indexPath)
            return cell
        }
    }
    
}

extension DiscountViewController {
    func getData() {
//        let param: Parameters = [       //아직 할인이 없기떄문에 아무거나 대충 넣어놓음
//            "min":"1"
//        ]
        
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
                    
                    NotificationCenter.default.post(name: Notification.Name("DiscountNotification"), object: nil, userInfo: ["dataArr": self.productArr])
                    self.tableView.reloadData()
                    self.numOfCell = dataArr.count
                    let indexPath = NSIndexPath(row: NSNotFound, section: 0)
                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
                    
                case .failure(let error):
                    print(error)
                }
                
            })
    }
    
    @objc func notificationReceived(notification: Notification) {
        guard let notificationUserInfo = notification.userInfo as? [String: Int],
            let myNowPage = notificationUserInfo["tagNum"] else { return }
        var paramValue = "1"
        switch myNowPage {
        case 0:
            paramValue = "1"
        case 1:
            paramValue = "10"
        case 2:
            paramValue = "15"
        case 3:
            paramValue = "20"
        case 4:
            paramValue = "30"
        default:
            print("이런데이터가있습니까")
        }
        param = [ "min" : paramValue]
        getData()
    }
}

extension DiscountViewController:  IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo: IndicatorInfo = "알뜰쇼핑"
        return itemInfo
    }
}
