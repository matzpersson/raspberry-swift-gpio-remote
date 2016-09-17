//
//  Extensions.swift
//  raspberry_gpio_remote
//
//  Created by Matz Persson on 16/09/2016.
//  Copyright © 2016 Headstation. All rights reserved.
//

import UIKit

extension String {
    
    var parseJSONString: AnyObject? {
        
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)

        do {
            if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                return jsonResult
            }
        } catch let error as NSError {
             return error.localizedDescription
        }
        
        return nil

    }
}
