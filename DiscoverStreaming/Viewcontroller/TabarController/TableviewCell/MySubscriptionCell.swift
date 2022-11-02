//
//  MySubscriptionCell.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 29/07/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class MySubscriptionCell: UITableViewCell {
    
    
    @IBOutlet weak var subs_btn: UIButton!
    @IBOutlet weak var venue_name_lbl: UILabel!
    @IBOutlet weak var package_status_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
