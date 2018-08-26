//
//  PayViewController.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 17..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit
import Kingfisher

class PayViewController: UIViewController {
    
    @IBOutlet weak var PayTableView:UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction private func toOrderCheckController(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let orderCheckController = storyboard.instantiateViewController(withIdentifier: "OrderCheckController") as! OrderCheckController
        orderCheckController.cartData = self.cartData
        orderCheckController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(orderCheckController, animated: true)
    }
    
    
    var cartData : Cart?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCloseButton()
        PayTableView.register(UINib(nibName: "PayStatusbarCell", bundle: nil), forCellReuseIdentifier: PayStatusbarCell.reusableIdentifier)
        PayTableView.register(UINib(nibName: "ProductInfoCell", bundle: nil), forCellReuseIdentifier: ProductInfoCell.reusableIdentifier)
        PayTableView.register(UINib(nibName: "PriceInfoCell", bundle: nil), forCellReuseIdentifier: PriceInfoCell.reusableIdentifier)
        PayTableView.register(UINib(nibName: "PayInfoCell", bundle: nil), forCellReuseIdentifier: PayInfoCell.reusableIdentifier)
        PayTableView.register(UINib(nibName: "OrdererCell", bundle: nil), forCellReuseIdentifier: OrdererCell.reusableIdentifier)
        PayTableView.register(UINib(nibName: "BasicDestinationCell", bundle: nil), forCellReuseIdentifier: BasicDestinationCell.reusableIdentifier)
        PayTableView.register(UINib(nibName: "PayMethodCell", bundle: nil), forCellReuseIdentifier: PayMethodCell.reusableIdentifier)
        PayTableView.register(UINib(nibName: "AgreementCell", bundle: nil), forCellReuseIdentifier: AgreementCell.reusableIdentifier)
        
    }
    
    func setCloseButton() {
        let image = UIImage(named: "closeImage")?.withRenderingMode(.alwaysTemplate)
        closeButton.setImage(image, for: .normal)
        closeButton.tintColor = .black
    }
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension PayViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 1:
            if let count = cartData?.cartItems.count  {
                return count
            }
            return 1
        default:
            print("default")
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: PayStatusbarCell.reusableIdentifier, for: indexPath) as! PayStatusbarCell
            tableView.rowHeight = 80
            
            return cell1
        case 1:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: ProductInfoCell.reusableIdentifier, for: indexPath) as! ProductInfoCell
            tableView.rowHeight = 250
            
            guard let cartData = cartData else {return cell2}
            
            let url = URL(string: cartData.cartItems[indexPath.row].product.thumbnailUrl1)
            cell2.Imageview.kf.setImage(with: url)
            cell2.Label.text = cartData.cartItems[indexPath.row].product.rawname
            cell2.Price.text = "\(cartData.cartItems[indexPath.row].product.salePrice)" + "원 / "
            cell2.amountLabel.text = "\(cartData.cartItems[indexPath.row].amount)" + "개"
            return cell2
            
            
            
        case 2:
            let cell3 = tableView.dequeueReusableCell(withIdentifier: PriceInfoCell.reusableIdentifier, for: indexPath) as! PriceInfoCell
            tableView.rowHeight = 300
            
            guard let cartData = cartData else {return cell3}
            
            cell3.totalPrice.text = "\(cartData.totalOrderPrice)" + "원"
            if cartData.totalOrderPrice >= 40000{
                cell3.deliveryPrice.text = "무료"
            }else{
                cell3.deliveryPrice.text = "\(2500)" + "원"
            }
            cell3.totalPrice.text = "\(cartData.totalOrderPrice)" + "원"
            return cell3
        case 3:
            let cell4 = tableView.dequeueReusableCell(withIdentifier: PayInfoCell.reusableIdentifier, for: indexPath) as! PayInfoCell
            tableView.rowHeight = 350
            
            guard let cartData = cartData else {return cell4}
            if cartData.totalOrderPrice >= 40000{
                cell4.deliveryPrice.text = "무료"
                cell4.totalPayPrice.text = "\(cartData.totalOrderPrice)" + "원"
                cell4.totalProductPrice.text = "\(cartData.totalOrderPrice)" + "원"
            }else{
                cell4.deliveryPrice.text = "\(2500)" + "원"
                cell4.totalPayPrice.text = "\(cartData.totalOrderPrice + 2500)" + "원"
                cell4.totalProductPrice.text = "\(cartData.totalOrderPrice + 2500)" + "원"
            }
            cell4.totalPrice.text = "\(cartData.totalOrderPrice)" + "원"
            
            return cell4
        case 4:
            let cell5 = tableView.dequeueReusableCell(withIdentifier: OrdererCell.reusableIdentifier, for: indexPath) as! OrdererCell
            tableView.rowHeight = 300
            
            guard let cartData = cartData else {return cell5}
            
            cell5.userNameLabel.text = cartData.user.fullname
            cell5.phoneNumberLabel.text = cartData.user.contactPhone
            
            return cell5
        case 5:
            let cell6 = tableView.dequeueReusableCell(withIdentifier: BasicDestinationCell.reusableIdentifier, for: indexPath) as! BasicDestinationCell
            tableView.rowHeight = 600
            return cell6
        case 6:
            let cell7 = tableView.dequeueReusableCell(withIdentifier: PayMethodCell.reusableIdentifier, for: indexPath) as! PayMethodCell
            tableView.rowHeight = 150
            return cell7
        case 7:
            let cell8 = tableView.dequeueReusableCell(withIdentifier: AgreementCell.reusableIdentifier, for: indexPath) as! AgreementCell
            tableView.rowHeight = 150
            return cell8
        default:
            print("fail")
        }
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int{
        return 8
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}
