//
//  UpcomingEventCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 27/06/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class UpcomingEventCell: UICollectionViewCell {
     @IBOutlet weak var imgUpcomming: UIImageView!
    
    @IBOutlet weak var evenyNameLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
