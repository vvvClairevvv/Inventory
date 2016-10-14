//
//  Product.swift
//  Inventory
//
//  Created by Claire on 10/11/16.
//  Copyright © 2016 ClaireLi. All rights reserved.
//

import UIKit

class Product {
    let productId         : String?
    let productName       : String?
    let shortDescription  : String?
    let longDescription   : String?
    let price             : String?
    let productImage      : String?
    let reviewRating      : Double?
    let reviewCount       : Int?
    let inStock           : Bool?
    var image             : UIImage? = nil
    
    init(data: Payload) {
        let productId = data?["productId"] as? String
        let productName = data?["productName"] as? String
        let shortDescription = data?["shortDescription"] as? String
        let longDescription = data?["longDescription"] as? String
        let price = data?["price"] as? String
        let productImage = data?["productImage"] as? String
        let reviewRating = data?["reviewRating"] as? Double
        let reviewCount = data?["reviewCount"]   as? Int
        let inStock = data?["inStock"] as? Bool
        
        self.productId = productId
        self.productName = productName
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.price = price
        self.productImage = productImage
        self.reviewRating = reviewRating
        self.reviewCount = reviewCount
        self.inStock = inStock
    }
}



