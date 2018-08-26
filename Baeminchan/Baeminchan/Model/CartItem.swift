//
//  CartItem.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 22..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import Foundation
class CartItem {
    let pk: Int
    let productId: Int
    let amount: Int
    let itemTotalPrice: Int
    
    init(pk: Int, productId: Int, amount: Int, itemTotalPrice: Int) {
        self.pk = pk
        self.productId = productId
        self.amount = amount
        self.itemTotalPrice = itemTotalPrice
    }
}
