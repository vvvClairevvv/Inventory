//
//  StringUtility.swift
//  Inventory
//
//  Created by Claire on 10/13/16.
//  Copyright © 2016 ClaireLi. All rights reserved.
//

import UIKit

class StringUtility: AnyObject {
    static func stringFromHTML( string: String?) -> String?
    {
        guard let string = string else {return nil}
        
        let decodedString: NSAttributedString
        do{
            
            let encodedData = string.data(using: String.Encoding.utf8)!
            let attributedOptions : [String: Any] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType ,
                NSCharacterEncodingDocumentAttribute: NSNumber(value: String.Encoding.utf8.rawValue)
            ]
            
            decodedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
        } catch {
            print("stringFromHTML error : \(error)")
            return ""
        }
        
        return decodedString.string
    }
}
