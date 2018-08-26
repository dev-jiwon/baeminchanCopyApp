
//
//  CartViewController.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 16..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class CartViewController: UIViewController {
    
    @IBOutlet weak var CartViewTableView:UITableView!
    @IBOutlet weak var closeButton: UIButton!
    //    var productslist: Products?
    var cartItems: [Cart.CartItems] = []
    var cartData : Cart?
    //    var cartItemsProduct: [Cart.CartItems.Product] = []
    var pk:Int = 000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CartViewTableView.register(UINib(nibName: "StatusViewCell", bundle: nil), forCellReuseIdentifier: StatusViewCell.reusableIdentifier)
        CartViewTableView.register(UINib(nibName: "AllSelectCell", bundle: nil), forCellReuseIdentifier: AllSelectCell.reusableIdentifier)
        CartViewTableView.register(UINib(nibName: "CartInfoCell", bundle: nil), forCellReuseIdentifier: CartInfoCell.reusableIdentifier)
        CartViewTableView.register(UINib(nibName: "InfomationCell", bundle: nil), forCellReuseIdentifier: InfomationCell.reusableIdentifier)
        CartViewTableView.register(UINib(nibName: "OrderPriceCell", bundle: nil), forCellReuseIdentifier: OrderPriceCell.reusableIdentifier)
        CartViewTableView.register(UINib(nibName: "HelpCallCell", bundle: nil), forCellReuseIdentifier: HelpCallCell.reusableIdentifier)
        CartViewTableView.register(UINib(nibName: "SellerInfoCell", bundle: nil), forCellReuseIdentifier: SellerInfoCell.reusableIdentifier)
        setCloseButton()
        takeData()
    }
    
    func setCloseButton() {
        let image = UIImage(named: "closeImage")?.withRenderingMode(.alwaysTemplate)
        closeButton.setImage(image, for: .normal)
        closeButton.tintColor = .black
    }
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func takeData(){
        
        let url = URL(string: "https://server.yeojin.me/api/carts/usercart/")
        
        let myToken = ViewController.userToken!
        print(myToken, "09090909")
        Alamofire.request(url!, method: HTTPMethod.get, headers: ["Authorization": "token \(myToken)"])
            .validate(statusCode: 200..<400)
            .responseData { [weak self](response) in
                guard let strongSelf = self else { return }
                
                switch response.result{
                case .success(let value):
                    print(value)
                    do{
                        print("1")
                        let cartData = try JSONDecoder().decode(Cart.self, from: value)
                        print("2")
                        strongSelf.cartData = cartData
                        strongSelf.cartItems = cartData.cartItems
                        //                        print("111", strongSelf.cartItems)
                        self?.CartViewTableView.reloadData()
                        
                    }catch{
                        print(error.localizedDescription, "success")
                    }
                case .failure(let error):
                    print(error, "failure")
                }
        }
    }
    
    
    
}


extension CartViewController: CalenderButtonDelegate {
    func CalenderButton(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let deliveryViewController = storyboard.instantiateViewController(withIdentifier: "DeliveryViewController") as! DeliveryViewController
        deliveryViewController.cartData = self.cartData
        deliveryViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(deliveryViewController, animated: true)
        
        
        
    }
}


extension CartViewController : dissmissbuttonDelegate {
    func changeAmountCartItem( count:Int) {
        print("changeAmountCartItem")
        let url = URL(string: "https://server.yeojin.me/api/carts/cartitemdetail/12/")
        
        
        
        Alamofire.request(url!, method: HTTPMethod.patch, parameters: ["amount":"\(count)"], headers: ["Authorization":"token \(ViewController.userToken!)"])
            .validate(statusCode: 200..<400)
            .responseData { [weak self] (response) in
                guard let strongSelf = self else { return }
                switch response.result{
                case .success(let value):
                    print(value)
                    do{
                        strongSelf.CartViewTableView.reloadData()
                    }catch{
                        print(error.localizedDescription, "success")
                    }
                case .failure(let error):
                    print(error, "failure")
                }
        }
    }
    
    func dismissCartItem() {
        print("dissmissbuttonDelegate")
        
        //
        //        let url = URL(string: "https://server.yeojin.me/api/carts/cartitemdetail/19/")
        //
        //        Alamofire.request(url!, method: HTTPMethod.delete, headers: ["Authorization":" token d913fd0242a68add0be6274410b4422d0438263c"])
        //            .validate(statusCode: 200..<400)
        //
        //        CartViewTableView.reloadData()
        
    }
    
    
    
}


extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 2:
            return cartItems.count
        default:
            print("default")
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        pk = (cartItems[indexPath.row].pk)
        //        print(pk, "tableView didSelectRowAt" )
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: StatusViewCell.reusableIdentifier, for: indexPath) as! StatusViewCell
            tableView.rowHeight = 80
            
            return cell1
        case 1:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: AllSelectCell.reusableIdentifier, for: indexPath) as! AllSelectCell
            tableView.rowHeight = 60
            
            return cell2
        case 2:
            let cell3 = tableView.dequeueReusableCell(withIdentifier: CartInfoCell.reusableIdentifier, for: indexPath) as! CartInfoCell
            tableView.rowHeight = 300
            cell3.delegate = self
            guard cartItems.count > 0 else {return cell3}
            //            print(cartItems[indexPath.row].product)
            cell3.Label.text = cartItems[indexPath.row].product.rawname
            let url = URL(string: cartItems[indexPath.row].product.thumbnailUrl1)
            cell3.ImageView.kf.setImage(with: url)
            cell3.price.text = "\(cartItems[indexPath.row].product.salePrice)" + "원"
            cell3.itemTotalPrice.text = "\(cartItems[indexPath.row].itemTotalPrice)" + "원"
            cell3.count = cartItems[indexPath.row].amount
            cell3.amountLabel.text = "\(cartItems[indexPath.row].amount)"
            return cell3
        case 3:
            let cell4 = tableView.dequeueReusableCell(withIdentifier: InfomationCell.reusableIdentifier, for: indexPath) as! InfomationCell
            tableView.rowHeight = 250
            return cell4
        case 4:
            let cell5 = tableView.dequeueReusableCell(withIdentifier: OrderPriceCell.reusableIdentifier, for: indexPath) as! OrderPriceCell
            cell5.delegate = self
            tableView.rowHeight = 350
            
            guard let cartData = cartData else {return cell5}
            
            cell5.sumPoint.text = "적립예정 포인트  " + "\(cartData.totalPoint)" + "원"
            cell5.price.text = "\(cartData.totalPrice)" + "원"
            if cartData.totalOrderPrice >= 40000{
                cell5.deliveryPrice.text = "무료"
                cell5.sumPrice.text = "\(cartData.totalOrderPrice)" + "원"
            }else{
                cell5.deliveryPrice.text = "\(2500)" + "원"
                cell5.sumPrice.text = "\(cartData.totalOrderPrice + 2500)" + "원"
            }
            return cell5
            
        case 5:
            let cell6 = tableView.dequeueReusableCell(withIdentifier: HelpCallCell.reusableIdentifier, for: indexPath) as! HelpCallCell
            tableView.rowHeight = 200
            return cell6
            
        case 6:
            let cell7 = tableView.dequeueReusableCell(withIdentifier: SellerInfoCell.reusableIdentifier, for: indexPath) as! SellerInfoCell
            tableView.rowHeight = 400
            return cell7
        default:
            print("fail")
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int{
        return 7
    }
    
}
