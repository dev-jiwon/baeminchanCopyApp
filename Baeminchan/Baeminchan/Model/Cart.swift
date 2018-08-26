//
//  Cart.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 23..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import Foundation

struct Cart:Decodable {
    
    let user: User
    let totalPoint: Int
    let totalPrice: Int
    let shippingFee: Int
    let totalOrderPrice: Int
    let cartItems: [CartItems]
    
    enum CodingKeys: String, CodingKey {
        case user
        case totalPoint = "total_point"
        case totalPrice = "total_price"
        case shippingFee = "shipping_fee"
        case totalOrderPrice = "total_order_price"
        case cartItems = "cart_items"
    }
    
    struct User : Decodable {
        let fullname: String
        let email: String
        let contactPhone :String
        
        enum CodingKeys: String, CodingKey{
            case fullname
            case email
            case contactPhone = "contact_phone"
        }
    }
    
    struct CartItems : Decodable {
        let pk : Int
        let product : Product
        let amount : Int
        let itemTotalPrice : Int
        
        enum CodingKeys: String, CodingKey{
            case pk
            case product
            case amount
            case itemTotalPrice = "item_total_price"
        }
        struct Product : Decodable {
            let id : Int
            let rawname : String
            let salePrice: Int
            let thumbnailUrl1: String
            enum CodingKeys: String, CodingKey{
                case id
                case rawname = "raw_name"
                case salePrice = "sale_price"
                case thumbnailUrl1 = "thumbnail_url1"
            }
        }
    }
    
    
    
}
