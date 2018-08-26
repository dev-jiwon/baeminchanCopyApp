//
//  CartButton.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 17..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit

class CartButton: UIButton {
    @IBOutlet var howManyItemInCartLabel: UILabel!
    @IBOutlet var myImageView: UIImageView!
    var howManyItemInCart = 0{
        didSet{
            if howManyItemInCart == 0 {
                howManyItemInCartLabel.isHidden = true
            } else {
                howManyItemInCartLabel.isHidden = false
                howManyItemInCartLabel.text = String(howManyItemInCart)
            }
        }
    }
    
    class func instanceFromNib() -> CartButton {
        return UINib(nibName: "CartButton", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CartButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let numOfCartItems = howManyItemInCart
        howManyItemInCart = numOfCartItems
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("changeCartData"), object: nil)
        howManyItemInCartLabel.layer.cornerRadius = howManyItemInCartLabel.frame.width / 2
        howManyItemInCartLabel.layer.masksToBounds = true
    }

    @IBAction func cartButtonTouched(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cartyViewController = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
//        cartyViewController.productslist = self.productslist
        cartyViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        //            self.show(cartyViewController, sender: nil)
        self.window?.rootViewController?.present(cartyViewController, animated: true)
        print("hi")
    }
    
    @objc func notificationReceived(notification: Notification) {
        guard let notificationUserInfo = notification.userInfo as? [String: Int],
            let numOfItems = notificationUserInfo["numOfItems"] else { return }
            howManyItemInCart = numOfItems
    }
}
