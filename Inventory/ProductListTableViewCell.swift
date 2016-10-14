//
//  ProductListTableViewCell.swift
//  Inventory
//
//  Created by Claire on 10/11/16.
//  Copyright © 2016 ClaireLi. All rights reserved.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {
    static let reusableId = "kProductListTableViewCellIdentifier"
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func prepareForReuse() {
        self.productImageView?.image = nil
        self.productNameLabel?.text = nil
        self.reviewLabel?.text = nil
        self.priceLabel?.text = nil
        
    }


}
