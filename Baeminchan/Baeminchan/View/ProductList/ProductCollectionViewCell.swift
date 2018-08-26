//
//  ProductCollectionViewCell.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 16..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit
import Alamofire
import Cosmos
import SwiftyJSON

class ProductCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!  //이미지
    @IBOutlet weak var mainTitle: UILabel!      //상품 이름
    @IBOutlet weak var subTitle: UILabel!       //간단 상품 설명
    @IBOutlet weak var starReviewPoint: CosmosView! //별점
    @IBOutlet weak var numOfReviews: UILabel!       //리뷰 수
    @IBOutlet weak var priceLabel: UILabel!         //가격
    @IBOutlet weak var originalPriceLabel: UILabel! //원래 가격
    @IBOutlet weak var rangkingOrDiscountLabel: UILabel!    //왼쪽 위 랭킹 / 할인률
    @IBOutlet var itemButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    var numOfCartItem = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func itemSelected(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController //Storyboard ID를 설정해줘야 한다.
        secondViewController.itemID = cartButton.tag
        self.window?.rootViewController?.show(secondViewController, sender: nil)
        print(mainTitle.text)
    }
    
    @IBAction func addInCard(_ sender: UIButton) {
        print("카트가즈아")
        addCartMotion() //아래에서 검정 뷰 올라와서 상품이 담김을 알려줌
    }
    
    func addCartMotion() {
        guard ViewController.userToken != nil else {
            makeAlert(title: "로그인 후 사용 가능합니다.")
            return}
//        NotificationCenter.default.post(name: Notification.Name("changeCartData"), object: nil, userInfo: ["numOfItems": 9999])
        addCartItemOnServer()
        let rootView = self.window?.rootViewController?.view
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
        let productID = cartButton.tag
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
        self.window?.rootViewController?.present(alertController,animated: true,completion: nil)
    }
    
    func getCartData() {
        let url = "https://server.yeojin.me/api/carts/cartitemlist/"
        let header: HTTPHeaders = ["Authorization":"token \(ViewController.userToken!)"]
        Alamofire
            .request(url, method: .get, parameters: nil, headers: header)
            .validate(statusCode: 200..<400)
            .responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value).arrayValue
                    self.numOfCartItem = json.count
                    NotificationCenter.default.post(name: Notification.Name("changeCartData"), object: nil, userInfo: ["numOfItems": self.numOfCartItem])
                case .failure(let error):
                    print(error)
                }
            })
    }
}

