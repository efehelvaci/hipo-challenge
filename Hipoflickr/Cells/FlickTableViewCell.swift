//
//  FlickTableViewCell.swift
//  Hipoflickr
//
//  Created by Efe Helvacı on 23.04.2017.
//  Copyright © 2017 Efe Helvacı. All rights reserved.
//

import UIKit
import Kingfisher

class FlickTableViewCell: UITableViewCell, OwnerRetrievedDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var flickImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    func setCell(flick: Flick) {
        flick.delegate = self
        flickImage.kf.indicatorType = .activity
        flickImage.kf.setImage(with: URL(string: flick.imageURL))
    
        if flick.owner != nil { updateOwner(owner: flick.owner!) }
        
        let daysAgo = flick.dateTaken.daysBetweenNow()
        switch daysAgo {
        case 0:
            dateLabel.text = "Today"
            break
        case 1:
            dateLabel.text = "Yesterday"
            break
        default:
            dateLabel.text = "\(daysAgo) days ago"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateOwner(owner: Profile) {
        profileImage.kf.setImage(with: URL(string: owner.iconURL))
        profileName.text = owner.nickname
    }
}
