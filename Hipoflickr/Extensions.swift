//
//  Extensions.swift
//  Hipoflickr
//
//  Created by Efe Helvacı on 23.04.2017.
//  Copyright © 2017 Efe Helvacı. All rights reserved.
//

import Foundation

extension Date {
    func daysBetweenNow() -> Int
    {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: self, to: Date())
        
        return components.day ?? 0
    }
}
