//
//  ProductFetcher.swift
//  Inventory
//
//  Created by Claire on 10/11/16.
//  Copyright © 2016 ClaireLi. All rights reserved.
//

import UIKit

let fetchBatchSize: CGFloat = 30
class ProductFetcher: AnyObject {
    var fetchedPageNumber = 0
    let pageSize: CGFloat
    private (set) var hasNextPage: Bool = true
    private (set) var isFetching: Bool = false
    
    init(pageSize: CGFloat) {
        self.pageSize = pageSize
    }

    func fetchNextBatch(successHandler: @escaping SuccessFetchHandler, failureHandler: @escaping FailureHandler) {
        if (self.isFetching) {
            return
        }
        
        isFetching = true
        let pageNumber = fetchedPageNumber == 0 ? 1: fetchedPageNumber + Int(pageSize)
        let operation = ProductRetrieveOperation(pageNumber: "\(pageNumber)", pageSize: "\(pageSize)")
        operation.fetch(successHandler: { [weak self](result: ProductRetrieveResult?) in
            self?.updateFetcherStateWithResult(result: result)
            successHandler(result)
            }, failureHandler: { [weak self] (error) in
                self?.isFetching = false
            
        })
    }
    
    func updateFetcherStateWithResult(result: ProductRetrieveResult?) {
        guard let fetchedResult = result else { return }
        self.isFetching = false
        
        guard let pageNumber = fetchedResult.pageNumber else { return }
        guard let totalProducts = fetchedResult.totalProduct else { return }
        
        self.hasNextPage = pageNumber < totalProducts 
    }
}
