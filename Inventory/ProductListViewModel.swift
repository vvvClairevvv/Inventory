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
        self.fetcher = ProductFetcher(pageSize: fetchBatchSize)
        self.productManager = ProductManager.sharedProductManager
    }
    
    func loadNextBatchOfProducts() {
        if (fetcher.hasNextPage && !fetcher.isFetching) {
            fetcher.fetchNextBatch(successHandler: {(result: ProductRetrieveResult?) in
                self.updateProductModelOnSuccessWithResult(result: result)
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
            guard let imageURL = URL(string: imageURLString) else {return nil}


            let downloadTask = self.downloadSession.downloadTask(with: imageURL as URL, completionHandler: { (location, response, error) in
                guard let location = location else {return}
                guard let data = try? Data(contentsOf: location) else {return}
                let downloadImage = UIImage(data: data)
                
                let fileManager = FileManager.default
                
                guard let desitinationPathURL = self.localPathForUrl(imageURLString: imageURLString) else {return}

                do {
                    try fileManager.copyItem(at: location, to:desitinationPathURL as URL)
                }catch {
                    print("Failed to copy file : \(error.localizedDescription)")
                }
                
                DispatchQueue.main.async {
                    product.image = downloadImage
                    self.observer?.didFinishDownloadImageAt(indexPath: indexPath)
                }
            })
            
            downloadTask.resume()
            
            return nil
            
        }
        
    }
    

    func updateProductModelOnSuccessWithResult(result: ProductRetrieveResult?) {
        productManager.updateProduct(newProducts: result?.products)
    }
    
    private func localPathForUrl(imageURLString: String) -> NSURL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        if let url = NSURL(string: imageURLString), let lastPathComponent = url.lastPathComponent {
            let fullPath = documentsPath.appendingPathComponent(lastPathComponent)
            return NSURL(fileURLWithPath:fullPath)
        }
        return nil
    }
    


}

