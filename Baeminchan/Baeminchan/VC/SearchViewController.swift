//
//  SearchViewController.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 20..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var howmanyItems = 0
    var productArr: [ListProductModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("searchValueNoti"), object: nil)
        setNavigation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if howmanyItems == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return howmanyItems
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70
        case 1:
            return 120
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTextFieldTableViewCell", for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
            let nowProduct = productArr[indexPath.row]
            cell.titleLabel.text = nowProduct.rawName
            let url = URL(string: nowProduct.thumbnailUrl)
            cell.productImageView.kf.setImage(with: url)
            cell.salePriceLabel.text = "\(String(nowProduct.salePrice)) 원"
            cell.itemButton.tag = Int(nowProduct.id)!
            cell.starPointView.rating = Double(nowProduct.starPoint)
            if nowProduct.price == 0 {
                cell.originalPriceLabel.isHidden = true
            } else {
                cell.originalPriceLabel.attributedText = myOriginalPrice(originalPrice: nowProduct.price)
            }
            
            if nowProduct.discountRate == 0 {
                cell.discountLabel.isHidden = true
            } else {
                cell.discountLabel.attributedText = myDiscountRate(discountRate: nowProduct.discountRate)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
            return cell
        }
    }
    
    @objc func notificationReceived(notification: Notification) {
        guard let notificationUserInfo = notification.userInfo as? [String: String],
            let mySearchValue = notificationUserInfo["textValue"] else { return }
        print(mySearchValue)
        serchProduct(value: mySearchValue)
    }
    
    func serchProduct(value: String) {
        let url = "https://server.yeojin.me/api/products/search/"
        let param: Parameters = ["query":value]
        Alamofire
            .request(url, method: .get, parameters: param)
            .validate(statusCode: 200..<400)
            .responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    var dataArr: [JSON] = []
                    let json = JSON(value)
                    dataArr = json.arrayValue
                    print(dataArr)
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
                    self.howmanyItems = self.productArr.count
                    self.tableView.reloadData()
                case .failure(let error):
                    self.howmanyItems = 0
                    self.tableView.reloadData()
                    print(error)
                }
                
            })
    }
    
    func myOriginalPrice(originalPrice: Int) -> NSMutableAttributedString {
        let originalPrice = String(originalPrice) + "원"
        let range = (originalPrice as NSString).range(of: originalPrice)
        let attributedString = NSMutableAttributedString(string: originalPrice)
        attributedString.addAttribute(NSAttributedStringKey.baselineOffset, value: 0, range: range)
        attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: range)
        return attributedString
    }
    
    func myDiscountRate(discountRate: Int) -> NSMutableAttributedString {
        let myDiscountRate = String(discountRate) + "%"
        let font = UIFont.systemFont(ofSize: 11)
        let attributedString = NSMutableAttributedString(string: myDiscountRate)
        let range = (myDiscountRate as NSString).range(of: "%")
        attributedString.addAttribute(NSAttributedStringKey.font, value: font, range: range)
        return attributedString
    }
    
    func setNavigation() {
        navigationItem.title = "검색"
        let myImage = UIImage(named: "backBlack")
        let backBTNImage = myImage?.withRenderingMode(.alwaysTemplate)
        let backBTN = UIBarButtonItem(image: backBTNImage,
                                      style: .done,
                                      target: self,
                                      action: #selector(postAlert))
        backBTN.tintColor = .black
        navigationItem.leftBarButtonItem = backBTN
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @objc func postAlert() {
        self.navigationController?.popViewController(animated: true)
    }
}
