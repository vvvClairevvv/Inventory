//
//  ProfuctListDataSource.swift
//  Inventory
//
//  Created by Claire on 10/12/16.
//  Copyright © 2016 ClaireLi. All rights reserved.
//

import UIKit

protocol ProductListDataSourceObserver: class {
    func didSuccessfullyFetchNewProducts()
    func didFinishDownloadingImageAtIndexPath(indexPath: NSIndexPath)
    func didInitiateDownloading()
}

class ProductListDataSource: NSObject, UITableViewDataSource {
    weak var tableView: UITableView?
    var observer: ProductListDataSourceObserver?
    lazy var viewModel: ProductListViewModel = {
        let vm = ProductListViewModel(tableView: self.tableView)
        vm.observer = self
        return vm
    }()
    
    init(tableView: UITableView?) {
        self.tableView = tableView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let dequedCell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.reusableId) as? ProductListTableViewCell else {
            return UITableViewCell()
        }
        

        self.configureCell(tableViewCell: dequedCell, indexPath: indexPath as NSIndexPath)
        return dequedCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return viewModel.productManager.productCount
        }
        
        return 1
    }
    
    func startFetching() {
        viewModel.loadNextBatchOfProducts()
    }
    
    func handleScrolling() {
        guard let tableView = self.tableView else {return}
        
        guard let lastVisibleRowIndexPath = tableView.indexPathsForVisibleRows?.last else {return}
        let lastFetchedProductIndex = viewModel.productManager.productCount - 1
        
        if(lastFetchedProductIndex <= lastVisibleRowIndexPath.row) {
            observer?.didInitiateDownloading()
            viewModel.loadNextBatchOfProducts()
        }
    }
    private func configureCell(tableViewCell: ProductListTableViewCell, indexPath: NSIndexPath) {
        tableViewCell.productNameLabel?.text = viewModel.productNameText(indexPath: indexPath)
        tableViewCell.productImageView?.image = viewModel.imageAtIndexPath(indexPath: indexPath)
        tableViewCell.reviewLabel?.text = viewModel.productReviewText(indexPath: indexPath)
        tableViewCell.priceLabel?.text = viewModel.priceText(indexPath: indexPath)
    }

    
}

extension ProductListDataSource: ProductListViewModelObserver {
    func didSuccessfullyFetchProduct() {
        observer?.didSuccessfullyFetchNewProducts()
    }
    
    func didFinishDownloadImageAt(indexPath: NSIndexPath) {
        observer?.didFinishDownloadingImageAtIndexPath(indexPath: indexPath)
    }
}


