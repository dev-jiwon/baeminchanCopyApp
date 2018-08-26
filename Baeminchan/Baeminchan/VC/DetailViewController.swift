//
//  DetailViewController.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 14..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class DetailViewController: UIViewController {
    var productslist: Products?
    var detailProductImages: [Products.ProductImageSet] = []
    var itemID = 0
    var numOfCartItem = 0
    //    {
    //        didSet {
    //            self.collectView.reloadData()
    //        }
    //    }
    var otherProducts: [Products.RelatedProducts] = []
    
    //나지원 데이터
    var productDetailData: ProductDetailModel?
    
    
    func sendProductslistToCartVC() -> Products?{
        return self.productslist
    }
    
    func takeData(){
        let url = "https://server.yeojin.me/api/products/\(itemID)"      //여기 잘 들어오는거 확인됨
        Alamofire
            .request(url, method: .get, parameters: nil)
            .validate(statusCode: 200..<400)
            .responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
//                    var dataArr: [JSON] = []
                    let json = JSON(value)
                    
                    //RelatedProduct 관련
                    let myRelatedProductsArr = json["related_products"].arrayValue
                    let myRelatedProduct = json["related_products"]
                    var myRelatedProductArrs: [relatedProductModel] = []
                    for index in 0..<myRelatedProductsArr.count {
                        let myRelatedProducts = relatedProductModel(id: myRelatedProduct[index]["id"].stringValue, rawName: myRelatedProduct[index]["raw_name"].stringValue, description: myRelatedProduct[index]["description"].stringValue, price: myRelatedProduct[index]["price"].intValue, salePrice: myRelatedProduct[index]["sale_price"].intValue, thumbnailUrl: myRelatedProduct[index]["thumbnail_url1"].stringValue)
                        myRelatedProductArrs.append(myRelatedProducts)
                    }
                    
                    //category 관련
                    let myParentCategory = parentCategoryModel(name: json["category"]["parent_category"]["name"].stringValue, imageUrl: json["category"]["parent_category"]["image_url"].stringValue)
                    let myCategory = categoryModel(name: json["category"]["name"].stringValue, parentCategory: myParentCategory)
                    
                    //productimageUrlArr 관련
                    let myProductimageUrlArrNum = json["productimage_set"].arrayValue.count
                    var myProductImageUrlArr: [String] = []
                    for index in 0..<myProductimageUrlArrNum {
                        let myProductimage  = json["productimage_set"][index]["image_url"].stringValue
                        myProductImageUrlArr.append(myProductimage)
                    }
                    
                    //thumbnail_url1 관련
                    var thumbnailUrlArr: [String] = []
                    for index in 2...6 {
                        let thumbnailUrl = json["thumbnail_url\(index)"].stringValue
                        thumbnailUrlArr.append(thumbnailUrl)
                    }
                    
                    self.productDetailData = ProductDetailModel(id: json["id"].stringValue,
                                                starPoint: json["avg_rating"].intValue,
                                                numOfComment: json["comment_count"].intValue,
                                                relatedProducts: myRelatedProductArrs,
                                                category: myCategory,
                                                productimageUrlArr: myProductImageUrlArr,
                                                rawName: json["raw_name"].stringValue,
                                                description: json["description"].stringValue,
                                                thumbnail_urlArr: thumbnailUrlArr,
                                                price: json["price"].intValue,
                                                discountRate: json["discount_rate"].intValue,
                                                salePrice: json["sale_price"].intValue,
                                                type: json["type"].stringValue,
                                                supplier: json["supplier"].stringValue,
                                                deliveryDays: json["delivery_days"].stringValue,
                                                deliveryType: json["delivery_type"].stringValue)
                    
                    print(self.productDetailData!.rawName)
                    NotificationCenter.default.post(name: Notification.Name("detailPageTopScrollNoti"), object: nil, userInfo: ["productThumnailUrl": self.productDetailData!.thumbnail_urlArr])
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
                
            })
    }
    
  
    
    @IBAction private func toCartVC(_ sender: UIButton) {
        addCartMotion()
        
        let alert = UIAlertController(title: "장바구니 담기 완료!", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (alert) in
            print("//to do 장바구니숫자올라가게 구현해야함")
        }))
        alert.addAction(UIAlertAction(title: "장바구니이동", style: .default, handler: { (alert) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cartyViewController = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
//            cartyViewController.p5roductslist = self.productslist
            cartyViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//            self.show(cartyViewController, sender: nil)
            self.present(cartyViewController, animated: true)
        }))
        self.present(alert, animated: true)
    }

    
    var buttonParameter = ""
    
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        //닙네임은 파일이름
        tableView.register(UINib(nibName: "ItemInfoCell", bundle: nil), forCellReuseIdentifier: ItemInfoCell.reusableIdentifier)
        tableView.register(UINib(nibName: "DetailMenubarCell", bundle: nil), forCellReuseIdentifier:
            DetailMenubarCell.reusableIdentifier)
        tableView.register(UINib(nibName: "HelpCallCell", bundle: nil), forCellReuseIdentifier: HelpCallCell.reusableIdentifier)
        tableView.register(UINib(nibName: "SellerInfoCell", bundle: nil), forCellReuseIdentifier: SellerInfoCell.reusableIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        takeData()
        getCartData()
    }
}


extension DetailViewController: ListReloadDelegate {
    func ListReload(prameter : String){
        buttonParameter = "\(prameter)"
        print(buttonParameter)
        print("\n---------- [ 잘되는건가 ? ? ? ] ----------\n")
        tableView.reloadData()
    }
}




extension DetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "PageControlCell", for: indexPath) as! PageControlCell
            tableView.rowHeight = tableView.frame.width//230
            return cell1
        case 1:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: ItemInfoCell.reusableIdentifier, for: indexPath) as! ItemInfoCell
            tableView.rowHeight = 300           //productDetailData
            
            if let productDetailData = productDetailData{
                cell2.rawNameLabel.text = productDetailData.rawName
                cell2.descriptionLabel.text = productDetailData.description
                cell2.priceLabel.text = "\(String(productDetailData.price))" + "원"
                cell2.salePriceLabel.text = "\(String(productDetailData.salePrice))" + "원"
                cell2.discountRateLabel.text = "\(String(productDetailData.discountRate))" + "%"
                cell2.deliveryDaysLabel.text = productDetailData.deliveryDays
                cell2.deliveryTypeLabel.text = productDetailData.deliveryType
                if productDetailData.discountRate == 0 {
                    cell2.eventLabel.isHidden = true
                }
            }
            return cell2
            
        case 2:
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "AnotherItemCell", for: indexPath) as! AnotherItemCell
            tableView.rowHeight = 200
            if let productDetailData = productDetailData{
                cell3.relatedProducts = productDetailData.relatedProducts
                cell3.sendRalatedProducts()
            }
            return cell3
            
        case 3:
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "VerticalItemCell", for: indexPath) as! VerticalItemCell
            tableView.rowHeight = 8000
            if let productDetailData = productDetailData{
                cell4.relatedProducts = productDetailData.productimageUrlArr
                cell4.sendRalatedProducts()
            }
//            if let product = productslist?.productImageSet {
//                cell4.sendRalatedProducts(value: product)
//            }
            return cell4
        case 4:
            let cell6 = tableView.dequeueReusableCell(withIdentifier: HelpCallCell.reusableIdentifier) as! HelpCallCell
            tableView.rowHeight = 200
            return cell6
            
        case 5:
            let cell7 = tableView.dequeueReusableCell(withIdentifier: SellerInfoCell.reusableIdentifier) as! SellerInfoCell
            tableView.rowHeight = 400
            return cell7
            
        default:
            print("fail")
        }
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        
        return 6
    }
    
}

extension DetailViewController {
    func setNavigation() {
        let myImage = UIImage(named: "backBlack")
        let backBTNImage = myImage?.withRenderingMode(.alwaysTemplate)
        let backBTN = UIBarButtonItem(image: backBTNImage,
                                      style: .done,
                                      target: self,
                                      action: #selector(postAlert))
        backBTN.tintColor = .black
        navigationItem.leftBarButtonItem = backBTN
        
        let cartBtn = CartButton.instanceFromNib()
        cartBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let cartBarBtn = UIBarButtonItem(customView: cartBtn)
        self.navigationItem.setRightBarButton(cartBarBtn, animated: false)
    }
    
    @objc func postAlert() {
        self.navigationController?.popViewController(animated: true)
    }
}

//카트 넣기 관련
extension DetailViewController {
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
    
    func addCartMotion() {
        guard ViewController.userToken != nil else {
            makeAlert(title: "로그인 후 사용 가능합니다.")
            return}
        //        NotificationCenter.default.post(name: Notification.Name("changeCartData"), object: nil, userInfo: ["numOfItems": 9999])
        addCartItemOnServer()
        let rootView = self.view
        let addCartLabel = UILabel()
        addCartLabel.text = "    상품을 1개 담았습니다."
        addCartLabel.font = UIFont.boldSystemFont(ofSize: 17)
        addCartLabel.textColor = .white
        addCartLabel.backgroundColor = UIColor(white: 0.1, alpha: 0.95)
        addCartLabel.frame = CGRect(x: 0, y: (rootView?.frame.maxY)!, width: (rootView?.frame.width)!, height: 50)
        rootView?.addSubview(addCartLabel)
        
        UIView.animate(withDuration: 0.5) {
            addCartLabel.frame.origin = CGPoint(x: 0, y: (rootView?.frame.maxY)! - 80)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {  //타이머 2초를 준다.
            UIView.animate(withDuration: 0.5) {
                addCartLabel.frame.origin = CGPoint(x: 0, y: (rootView?.frame.maxY)!)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                addCartLabel.removeFromSuperview()
            })
        })
    }
    
    func addCartItemOnServer() {
        let urlString = "https://server.yeojin.me/api/carts/cartitemlist/"
        let productID = itemID
        let numOfItem = 1
        
        let header: HTTPHeaders = ["Authorization":"token \(ViewController.userToken!)"]
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append("\(productID)".data(using: .utf8)!, withName: "product")
                multipartFormData.append("\(numOfItem)".data(using: .utf8)!, withName: "amount")
        },
            to: urlString,
            headers: header,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            print(json)
                        case .failure(let error):
                            print("nooooo")
                            print(error)
                        }
                        self.getCartData()
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    
    func makeAlert(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let cancelButton = UIAlertAction(title: "확인", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController,animated: true,completion: nil)
    }
}
