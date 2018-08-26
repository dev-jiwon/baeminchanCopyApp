//
//  DeliveryViewController.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 16..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit

class DeliveryViewController: UIViewController {
    
    @IBOutlet weak var DeliveryTableView:UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    var cartData : Cart?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DeliveryTableView.register(UINib(nibName: "DissmissCell", bundle: nil), forCellReuseIdentifier: DissmissCell.reusableIdentifier)
        DeliveryTableView.register(UINib(nibName: "DeliveryDayCell", bundle: nil), forCellReuseIdentifier: DeliveryDayCell.reusableIdentifier)
        setCloseButton()
    }
    
    func setCloseButton() {
        let image = UIImage(named: "closeImage")?.withRenderingMode(.alwaysTemplate)
        closeButton.setImage(image, for: .normal)
        closeButton.tintColor = .black
    }
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction private func toPayViewControllerButton(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let payViewController = storyboard.instantiateViewController(withIdentifier: "PayViewController") as! PayViewController
        payViewController.cartData = self.cartData
        payViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(payViewController, animated: true)
    }
    
}




extension DeliveryViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: DissmissCell.reusableIdentifier, for: indexPath) as! DissmissCell
            tableView.rowHeight = 80
            return cell1
        case 1:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: DeliveryDayCell.reusableIdentifier, for: indexPath) as! DeliveryDayCell
            tableView.rowHeight = 650
            guard let cartData = self.cartData else {return cell2}
            
            cell2.totalPrice.text = "\(cartData.totalOrderPrice)" + "원"
            if cartData.totalOrderPrice >= 40000{
                cell2.deliveryPrice.text = "무료"
                cell2.payPrice.text = "\(cartData.totalOrderPrice)" + "원"
            }else{
                cell2.deliveryPrice.text = "\(2500)" + "원"
                cell2.payPrice.text = "\(cartData.totalOrderPrice + 2500)" + "원"
            }
            
            return cell2
        default:
            print("fail")
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    
    
    
}
