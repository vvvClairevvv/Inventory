//
//  ProductListViewController.swift
//  Inventory
//
//  Created by Claire on 10/11/16.
//  Copyright © 2016 ClaireLi. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController, UITableViewDelegate, ProductListDataSourceObserver{
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.estimatedRowHeight = 72
            self.tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet weak var loadingLabel: UILabel!
    
    lazy var dataSouorce: ProductListDataSource  = {return ProductListDataSource(tableView: self.tableView)}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.dataSource = self.dataSouorce
        self.dataSouorce.observer = self
        self.tableView.delegate = self
        self.dataSouorce.startFetching()
    }
    
    func showLoading() {
        self.loadingLabel.isHidden = false
    }
    
    func hiddLoading() {
        self.loadingLabel.isHidden = true
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
        guard let vc = storyboard.instantiateViewController(withIdentifier: ProductDetailsPageViewController.identifier) as? ProductDetailsPageViewController else {return}
        
        vc.currentItemIndex = indexPath.row
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: ProductListDataSourceObserver
    func didSuccessfullyFetchNewProducts() {
        DispatchQueue.main.async {
            self.hiddLoading()
            self.tableView?.reloadData()
        }
    }
    func didFinishDownloadingImageAtIndexPath(indexPath: NSIndexPath) {
        DispatchQueue.main.async {
            self.tableView?.reloadRows(at: [indexPath as IndexPath], with: .none)
        }

    }
    
    func didInitiateDownloading() {
        showLoading()
    }
}




