//
//  ProductDetailsViewController.swift
//  Inventory
//
//  Created by Claire on 10/13/16.
//  Copyright © 2016 ClaireLi. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    static let identifier = "kProductDetailsViewControllerIdentifier"
    var currentItemIndex: Int?
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var longDescriptionLabel: UILabel!
    
    @IBOutlet weak var loadingView: UIView! {
        didSet{
            self.loadingView.isHidden = true
        }
    }
    
    lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        return session
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        print("currentIndex is : \(currentItemIndex)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayProductInfoFor()
    }
    func startNetWorkIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.loadingView.isHidden = false
    }
    
    func stopNetworIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.loadingView.isHidden = true
        self.view.layoutIfNeeded()
        displayProductInfoFor()

    }
    
    func displayProductInfoFor() {
        guard let currentItemIndex = currentItemIndex else {return}
        guard let product = ProductManager.sharedProductManager.productAtIndex(index: currentItemIndex) else {return}
        productNameLabel?.text = product.productName
        reviewLabel?.text = reviewLabelForProduct(product: product)
        priceLabel?.text = product.price
        stockLabel?.text = product.stockStateString
        longDescriptionLabel?.text = StringUtility.stringFromHTML(string: product.longDescription)
        
        guard let image = product.image else
        {
            guard let imageURLString = product.productImage else {return}
            let downloader = ImageDownloader()
            downloader.downloadImageForURL(downloadSession: downloadSession, imageURLString: imageURLString, completionHandler: { (image) in
                DispatchQueue.main.async {
                    self.productImageView?.image = image
                }
            })
            return
        }
        productImageView?.image = image
        
    }
    
    func reviewLabelForProduct(product: Product) -> String {
        if let reviewRating = product.reviewRating,
            let reviewCount  = product.reviewCount {
            return "rating: \(reviewRating)/5.0 (\(reviewCount))"
        } else {
            return "rating: 0 /5.0 (0)"
        }
    }
}
