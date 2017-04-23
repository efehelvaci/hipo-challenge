//
//  Flick.swift
//  Hipoflickr
//
//  Created by Efe Helvacı on 23.04.2017.
//  Copyright © 2017 Efe Helvacı. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol OwnerRetrievedDelegate {
    func updateOwner(owner: Profile)
}

class Flick: NSObject {
    var id       : String!
    var imageURL : String!
    var dateTaken: Date! {
        didSet {
            dateTaken.hour   = 0
            dateTaken.minute = 0
            dateTaken.second = 0
        }
    }
    var owner    : Profile? { didSet { if delegate != nil { delegate!.updateOwner(owner: self.owner!) } } }
    var delegate : OwnerRetrievedDelegate?
    
    init(json: JSON) {
        self.id       = json["id"].stringValue
        self.imageURL = "https://farm\(json["farm"].intValue).staticflickr.com/\(json["server"].stringValue)/\(json["id"].stringValue)_\(json["secret"].stringValue)_z.jpg"
        self.dateTaken = ConstantManager.sharedInstance.dateFormatter.date(from: json["datetaken"].stringValue)
        
    }
}

// Flickr Image Format
// https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg

// SAMPLE JSON
/*
 { "id": "33373771014", "owner": "8773601@N03", "secret": "ae9d536e68", "server": "2810", "farm": 3, "title": "PA201360", "ispublic": 1, "isfriend": 0, "isfamily": 0, "datetaken": "2017-04-23 12:32:58" },
 */

