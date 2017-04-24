//
//  Profile.swift
//  Hipoflickr
//
//  Created by Efe Helvacı on 23.04.2017.
//  Copyright © 2017 Efe Helvacı. All rights reserved.
//

import UIKit
import SwiftyJSON

class Profile: NSObject {
    var id       : String!
    var nickname : String!
    var iconURL  : String!
    
    init(json: JSON) {
        let status = json["stat"].stringValue
        if status == "ok" {
            self.id       = json["person"]["id"].string ?? "-1"
            self.nickname = json["person"]["username"]["_content"].string ?? "No name"
            
            /*
             If the icon server is greater than zero, the url takes the following format:
             
             http://farm{icon-farm}.staticflickr.com/{icon-server}/buddyicons/{nsid}.jpg
             
             else the following url should be used:
             
             https://www.flickr.com/images/buddyicon.gif
             */
            
            let icon_server = Int(json["person"]["iconserver"].stringValue)!
            if icon_server > 0 {
                self.iconURL = "http://farm\(json["person"]["iconfarm"].intValue).staticflickr.com/\(icon_server)/buddyicons/\(json["person"]["nsid"].stringValue).jpg"
            } else {
                self.iconURL = "https://www.flickr.com/images/buddyicon.gif"
            }
        } else {
            self.id = "-1"
            self.nickname = "User is banned"
            self.iconURL  = "https://www.flickr.com/images/buddyicon.gif"
        }
    }
}
