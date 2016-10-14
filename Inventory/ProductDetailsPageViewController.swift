//
//  ProductDetailsPageViewController.swift
//  Inventory
//
//  Created by Claire on 10/13/16.
//  Copyright © 2016 ClaireLi. All rights reserved.
//

import UIKit

class ProductDetailsPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    static let identifier = "kProductDetailsPageViewControllerIdentifier"
    var currentItemIndex: Int?
    var direction: UIPageViewControllerNavigationDirection?
    lazy var fetcher: ProductFetcher = {return ProductFetcher(pageSize: 30)}()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let firstVC = storyboard.instantiateViewController(withIdentifier: ProductDetailsViewController.identifier) as? ProductDetailsViewController else {return }
        firstVC.currentItemIndex = currentItemIndex
        self.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let vc = viewController  as? ProductDetailsViewController else {return nil}
        
        guard let index = vc.currentItemIndex else {return nil}
        
        if (index == 0 ) {
            return nil
        }
        let beforeVC = detailsViewControllerAtIndex(index: index - 1)
        return beforeVC
    }
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("after gets called\n")

        guard let vc = viewController  as? ProductDetailsViewController else {return nil}
        
        guard let index = vc.currentItemIndex else {return nil}
        
        if (index >= ProductManager.sharedProductManager.productCount - 1 && !ProductFetcher.sharedInstance.hasNextPage) {
            return nil
        }
        let afterVC = detailsViewControllerAtIndex(index: index + 1)
        return afterVC
    }
    
    
    private func fetchProductsAsNeeded() {
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if (completed && finished) {

        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let vc = pendingViewControllers.first as? ProductDetailsViewController else{return}
        print("pending view controllers")
        print(pendingViewControllers)
        
        print("end")
        guard let index = vc.currentItemIndex else {return}
        
        if (index >= ProductManager.sharedProductManager.productCount - 1 && ProductFetcher.sharedInstance.hasNextPage) {
            vc.startNetWorkIndicator()
            ProductFetcher.sharedInstance.fetchNextBatch(successHandler: { (result) in
                DispatchQueue.main.async {
                    vc.stopNetworIndicator()
                    print("Page View Controller fetched")

                }
                }, failureHandler: { (error) in
                    print("Page VIEW CONTROLLER ERROR")
            })
        }
        
    }
    
    
    func detailsViewControllerAtIndex(index: Int) -> ProductDetailsViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: ProductDetailsViewController.identifier) as? ProductDetailsViewController else {return nil}
        vc.currentItemIndex = index
        return vc
    }
    
}
