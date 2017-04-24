//
//  ConstantManager.swift
//  Hipoflickr
//
//  Created by Efe Helvacı on 23.04.2017.
//  Copyright © 2017 Efe Helvacı. All rights reserved.
//

import Foundation

class ConstantManager : NSObject {
    // Constant Manager is a singleton
    static let sharedInstance = ConstantManager()
    private override init() {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Format of the retrieved date time from Flickr
    }
    
    let dateFormatter = DateFormatter()
}
