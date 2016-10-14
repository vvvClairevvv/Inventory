//
//  ImageDownloader.swift
//  Inventory
//
//  Created by Claire on 10/14/16.
//  Copyright © 2016 ClaireLi. All rights reserved.
//

import UIKit

typealias ImageDownloadedHandler = (_ image: UIImage?) -> ()

class ImageDownloader: AnyObject {

    
    func downloadImageForURL(downloadSession: URLSession, imageURLString: String, completionHandler: @escaping ImageDownloadedHandler) {
        guard let imageURL = URL(string: imageURLString) else {return }
        let fileManager = FileManager.default
        guard let desitinationPathURL = self.localPathForUrl(imageURLString: imageURLString) else {return}
                
        if let localPath = desitinationPathURL.absoluteString,
            let data = fileManager.contents(atPath: localPath) {
            let savedImage = UIImage(data: data)
            completionHandler(savedImage)
        } else {
            let downloadTask = downloadSession.downloadTask(with: imageURL as URL, completionHandler: { (location, response, error) in
                guard let location = location else {return}
                guard let data = try? Data(contentsOf: location) else {return}
                let downloadImage = UIImage(data: data)
                
                
                do {
                    try fileManager.copyItem(at: location, to:desitinationPathURL as URL)
                }catch {
                    print("Failed to copy file : \(error.localizedDescription)")
                }
                
                completionHandler(downloadImage)
                
            })
            
            downloadTask.resume()
        }
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
