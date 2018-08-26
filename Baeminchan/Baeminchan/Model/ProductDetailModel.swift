//
//  ProductDetailModel.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 23..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import Foundation

class ProductDetailModel {
    let id: String
    let starPoint: Int
    let numOfComment: Int
    let relatedProducts: [relatedProductModel]
    let category: categoryModel
    let productimageUrlArr: [String]
    let rawName: String
    let description: String
    let thumbnail_urlArr: [String]  //여기에 썸네일1~6 넣으면 될듯
    let price: Int
    let discountRate: Int
    let salePrice: Int
    let type: String
    let supplier: String
    let deliveryDays: String
    let deliveryType: String
    
    init(id: String, starPoint: Int, numOfComment: Int, relatedProducts: [relatedProductModel], category: categoryModel, productimageUrlArr: [String], rawName: String, description: String, thumbnail_urlArr:[String], price: Int, discountRate: Int, salePrice: Int, type: String, supplier: String, deliveryDays: String, deliveryType:String) {
        self.id = id
        self.starPoint = starPoint
        self.numOfComment = numOfComment
        self.relatedProducts = relatedProducts
        self.category = category
        self.productimageUrlArr = productimageUrlArr
        self.rawName = rawName
        self.description = description
        self.thumbnail_urlArr = thumbnail_urlArr
        self.price = price
        self.discountRate = discountRate
        self.salePrice = salePrice
        self.type = type
        self.supplier = supplier
        self.deliveryDays = deliveryDays
        self.deliveryType = deliveryType
    }
    
}

class relatedProductModel {
    let id: String
    let rawName: String
    let description: String
    let price: Int
    let salePrice: Int
    let thumbnailUrl: String
    init(id: String, rawName: String, description: String, price: Int, salePrice: Int, thumbnailUrl: String) {
        self.id = id
        self.rawName = rawName
        self.description = description
        self.price = price
        self.salePrice = salePrice
        self.thumbnailUrl = thumbnailUrl
    }
}

class categoryModel {
    let name: String
    let parentCategory: parentCategoryModel
    init(name: String, parentCategory: parentCategoryModel) {
        self.name = name
        self.parentCategory = parentCategory
    }
}

class parentCategoryModel {
    let name: String
    let imageUrl: String
    init(name: String, imageUrl: String) {
        self.name = name
        self.imageUrl = imageUrl
    }
}
