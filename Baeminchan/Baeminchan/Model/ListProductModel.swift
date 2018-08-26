//
//  ListProductModel.swift
//  Baeminchan
//
//  Created by Na jiwon on 2018. 8. 16..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import Foundation
class ListProductModel {
    let discountRate: Int
    let price: Int
    let salePrice: Int
    let thumbnailUrl: String
    let rawName: String
    let id: String
    let description: String
    let starPoint: Int
    let numOfComment: Int
    
    init(discountRate: Int, price: Int, salePrice: Int, thumbnailUrl: String, rawName: String, id: String, description: String, starPoint: Int, numOfComment: Int) {
        self.discountRate =  discountRate
        self.price = price
        self.salePrice = salePrice
        self.thumbnailUrl = thumbnailUrl
        self.rawName = rawName
        self.id = id
        self.description = description
        self.starPoint = starPoint
        self.numOfComment = numOfComment
    }
    
}
