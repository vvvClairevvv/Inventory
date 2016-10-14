//
//  ProductRetrieveOperation.swift
//  Inventory
//
//  Created by Claire on 10/11/16.
//  Copyright © 2016 ClaireLi. All rights reserved.
//

import UIKit

typealias FetchHandler = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()
typealias SuccessFetchHandler = (ProductRetrieveResult?) -> ()
typealias FailureHandler = (Error) -> ()

typealias Payload = [String: AnyObject]?

class ProductRetrieveOperation: AnyObject {
    let URL = "https://walmartlabs-test.appspot.com/_ah/api/walmart/v1"
    let apiKey = "0fce4a09-5ed0-49d9-9c0f-17693b382f7b"
    let pageNumber: String
    let pageSize: String
    init(pageNumber: String, pageSize: String) {
        self.pageNumber = pageNumber
        self.pageSize   = pageSize
    }
    
    func fetch(successHandler: @escaping SuccessFetchHandler, failureHandler: @escaping FailureHandler) {
        let defaultSession = URLSession(configuration: .default)
        let URL = NSURL(string: "https://walmartlabs-test.appspot.com/_ah/api/walmart/v1/walmartproducts/\(apiKey)/\(pageNumber)/\(pageSize)")
        print("Inventory: connect to end point \(URL)\n")
        guard let url = URL else { return }
        let dataTask = defaultSession.dataTask(with: url as URL, completionHandler: {
             ( data: Data?, response:URLResponse?, error: Error? ) in
            if let error = error {
                failureHandler(error)
            } else if let httpResponse = response  as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let result = self.deserializeFetchedData(data: data)
                    print("------------ successfully ------------\n")
                    print(result)
                    successHandler(result)
                }
            }
        })
        
        dataTask.resume()
    }
    
    func deserializeFetchedData(data: Data?) -> ProductRetrieveResult? {
        let fetchedJson: [String : AnyObject]?
        do {
            guard let data = data else { return nil }
            fetchedJson = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject]
            print("fetched JSON -------\n")
            print(fetchedJson)
            print("fetched JSON end -------\n")

        } catch {
            print(error)
            return nil
        }
        guard let json = fetchedJson else {return nil}
        guard let products = json["products"] as? [Payload] else { return nil }
        guard let totalProduct = json["totalProducts"] as? Int else { return nil }
        guard let pageNumber = json["pageNumber"] as? Int  else {return nil}
        guard let status = json["status"] as? Int else {return nil}
        guard let pageSize = json["pageSize"] as? Int else {return nil}
        
        
        let productObjs = products.map { return Product(data: $0)  }
        
        return ProductRetrieveResult(products: productObjs, totalProduct: totalProduct, pageNumber: pageNumber, pageSize: pageSize, status: status)
    }

}
