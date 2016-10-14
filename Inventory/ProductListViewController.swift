//
//  ProductListViewController.swift
//  Inventory
//
//  Created by Claire on 10/11/16.
//  Copyright © 2016 ClaireLi. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController, UITableViewDelegate{
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
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.dataSource = self.dataSouorce
        self.tableView.delegate = self
        self.dataSouorce.startFetching()


    }
    
    func updateResult(result: ProductRetrieveResult?) {
        
    }
    
    //MARK: UITableViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dataSouorce.handleScrolling()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: ProductDetailsViewController.identifier) as? ProductDetailsViewController else {return}
        vc.currentItemIndex = indexPath.row
        self.navigationController?.pushViewController(vc, animated: false)
    }
}




