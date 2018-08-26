//
//  Products.swift
//  Baeminchan
//
//  Created by kimdaeman14 on 2018. 8. 21..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import Foundation

struct Products : Decodable {
    let id: Int
    let rawName : String //제품이름
    let description : String //제품설명
    let thumbnailUrl1 : String //메인썸네일페이징이미지
    let thumbnailUrl2 : String //메인썸네일페이징이미지
    let thumbnailUrl3 : String //메인썸네일페이징이미지
    let thumbnailUrl4 : String //메인썸네일페이징이미지
    let thumbnailUrl5 : String //메인썸네일페이징이미지
    let thumbnailUrl6 : String //메인썸네일페이징이미지
    let price : Int //원래가격
    let salePrice : Int //세일가격
    let discountRate : Int //할인율
    let productImageSet: [ProductImageSet] //상세정보 이미지 리스트
    let supplier : String //판매자이름
    let stock : Int //재고량
    let relatedProducts: [RelatedProducts] ////판매자의 다른상품
    let deliveryDays : String //배송가능일
    let deliveryType : String //배송타입
    
    enum CodingKeys: String, CodingKey {
        case id
        case productImageSet = "productimage_set"
        case relatedProducts = "related_products"
        case rawName = "raw_name"
        case description
        case thumbnailUrl1 = "thumbnail_url1" 
        case thumbnailUrl2 = "thumbnail_url2"
        case thumbnailUrl3 = "thumbnail_url3"
        case thumbnailUrl4 = "thumbnail_url4"
        case thumbnailUrl5 = "thumbnail_url5"
        case thumbnailUrl6 = "thumbnail_url6"

        case price
        case salePrice = "sale_price"
        case discountRate = "discount_rate"
        case supplier
        case stock
        case deliveryDays = "delivery_days"
        case deliveryType = "delivery_type"
    }
    
    struct ProductImageSet : Decodable { //상세정보 이미지 리스트
        let imageUrl:String
        
        enum CodingKeys: String, CodingKey{
            case imageUrl = "image_url"
        }
    }
    
    struct RelatedProducts : Decodable { //판매자의 다른상품
        let id : Int
        let rawname : String
        let description : String
        let discountRate : Int
        let price : Int
        let salePrice: Int
        let thumbnailUrl : String
        
        enum CodingKeys: String, CodingKey {
            case id
            case rawname = "raw_name"
            case description
            case discountRate = "discount_rate"
            case price
            case salePrice = "sale_price"
            case thumbnailUrl = "thumbnail_url1"
        }
    }
}
