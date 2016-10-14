//
//  ProductListViewController.swift
//  Inventory
//
//  Created by Claire on 10/11/16.
//  Copyright © 2016 ClaireLi. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.estimatedRowHeight = 72
            self.tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    lazy var dataSouorce: ProductListDataSource  = {return ProductListDataSource(tableView: self.tableView)}()
    lazy var productFetcher: ProductFetcher = { return ProductFetcher(pageSize: 30) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSouorce
        self.tableView.delegate = self.dataSouorce
        self.dataSouorce.startFetching()


    }
    
    func updateResult(result: ProductRetrieveResult?) {
        
    }
}


