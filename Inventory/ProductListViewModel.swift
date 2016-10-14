//
//  ProductListViewModel.swift
//  Inventory
//
//  Created by Claire on 10/12/16.
//  Copyright © 2016 ClaireLi. All rights reserved.
//

import UIKit

protocol ProductListViewModelObserver:class {
    func didSuccessfullyFetchProduct()
    func didFinishDownloadImageAt(indexPath: NSIndexPath)
}

class ProductListViewModel {
    var fetcher: ProductFetcher
    weak var tableView: UITableView?
    let productManager: ProductManager
    weak var observer: ProductListViewModelObserver?
    
    lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        return session
    }()
    
    init(tableView: UITableView?) {
        self.tableView = tableView
        self.fetcher = ProductFetcher.sharedInstance
        self.productManager = ProductManager.sharedProductManager
    }
    
    func loadNextBatchOfProducts() {
        if (fetcher.hasNextPage && !fetcher.isFetching) {
            fetcher.fetchNextBatch(successHandler: {(result: ProductRetrieveResult?) in
                self.observer?.didSuccessfullyFetchProduct()
                }, failureHandler: { (error) in
                    print(error)
            })
        }
    }
    
    func productNameText(indexPath: NSIndexPath) -> String? {
        guard let product = productManager.productAtIndex(index: indexPath.row) else {return nil}
        guard let htmlEncodedString = product.productName else {return nil}
        return htmlEncodedString
    }
    
    func productReviewText(indexPath: NSIndexPath) -> String {
        guard let product = productManager.productAtIndex(index: indexPath.row) else {return ""}
        if let reviewRating = product.reviewRating,
            let reviewCount  = product.reviewCount {
            return "\(reviewRating) (\(reviewCount))"
        } else {
            return ""
        }
    }
    
    func priceText(indexPath: NSIndexPath) -> String {
        guard let product = productManager.productAtIndex(index: indexPath.row) else {return ""}
        guard let price = product.price else { return ""}
        return price
    }
    
    func imageAtIndexPath(indexPath: NSIndexPath) -> UIImage? {
        guard let product = productManager.productAtIndex(index: indexPath.row) else {return nil}
        if let image = product.image {
            return image
        }else {
            guard let imageURLString = product.productImage else {return nil}
            let downloader = ImageDownloader()
            downloader.downloadImageForURL(downloadSession: self.downloadSession, imageURLString: imageURLString, completionHandler: { (image) in
                product.image = image
                self.observer?.didFinishDownloadImageAt(indexPath: indexPath)
            })
            return nil
        }
        
    }
}

