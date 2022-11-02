//
//  SelVenueCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 29/11/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class SelVenueCell: UITableViewCell {
    @IBOutlet weak var venuenameLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
