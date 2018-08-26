//
//  OrderCheckController.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 23..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class OrderCheckController: UIViewController {
    
    var cartData : Cart?
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var productList: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBAction func toMainListController(_ sender: Any) {
        presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let cartData = cartData else {return}
        totalPrice.text = "\(cartData.totalOrderPrice)" + "원"
        productList.text = "\(cartData.cartItems[0].product.rawname)" + " 외 " + "\(cartData.cartItems.count - 1)"
        emailLabel.text = "주문정보가 \(cartData.user.email) 으로 발송되었습니다"
        addActInd()
    }
    
    
    
    
    
    func addActInd() {
        let myView = UIView(frame: view.frame)
        myView.backgroundColor = .white
        let myTextLabel = UILabel()
        myTextLabel.textColor = .black
        myTextLabel.text = "결제가 진행중입니다."
        myTextLabel.textAlignment = .center
        myTextLabel.font = UIFont.systemFont(ofSize: 17)
        myTextLabel.frame.size = CGSize(width: 200, height: 30)
        myTextLabel.center = myView.center
        myTextLabel.center.y = myView.center.y - 80
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        let myX = view.frame.width / 2 - 15
        actInd.center.x = myX
        actInd.center.y = myView.center.y
        actInd.frame.size = CGSize(width: 30, height: 30)
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = .whiteLarge
        actInd.color = UIColor(red: 0.2431, green: 0.7569, blue: 0.7294, alpha: 1)
        myView.addSubview(myTextLabel)
        myView.addSubview(actInd)
        actInd.startAnimating()
        view.addSubview(myView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {  //타이머 3초를 준다.
            actInd.stopAnimating()
            myView.removeFromSuperview()
        })
        
    }
}
