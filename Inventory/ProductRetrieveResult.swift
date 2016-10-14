//
//  ProductRetrieveResult.swift
//  Inventory
//
//  Created by Claire on 10/11/16.
//  Copyright © 2016 ClaireLi. All rights reserved.
//

import UIKit

class ProductRetrieveResult: AnyObject {
    let products: [Product]?
    let totalProduct: Int?
    let pageNumber: Int?
    let pageSize: Int?
    let status: Int
    
    init(products: [Product]?,
         totalProduct: Int?,
         pageNumber: Int?,
         pageSize: Int?,
         status: Int) {
        self.products = products
        self.totalProduct = totalProduct
        self.pageNumber = pageNumber
        self.pageSize = pageSize
        self.status = status
    }
}


