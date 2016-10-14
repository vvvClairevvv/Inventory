//
//  ProductManager.swift
//  Inventory
//
//  Created by Claire on 10/12/16.
//  Copyright © 2016 ClaireLi. All rights reserved.
//

import UIKit

class ProductManager: AnyObject {
    private var products: [Product]
    var productCount: Int {
        get {
            return products.count
        }
    }
    
    init(products: [Product] = []) {
        self.products = products
    }
    
    func updateProduct(newProducts: [Product]?) {
        self.products = self.products  + (newProducts ?? [])
    }
    
    func productAtIndex(index: Int) -> Product? {
        if (index < products.count) {
            return products[index]
        }
        
        return nil
    }
    
}
