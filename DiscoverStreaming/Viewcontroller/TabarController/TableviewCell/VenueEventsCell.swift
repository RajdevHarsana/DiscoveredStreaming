//
//  VenueEventsCell.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 10/08/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class VenueEventsCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var EventnameLbl: UILabel!
    @IBOutlet weak var EventAddress: UILabel!
    @IBOutlet weak var EventVanueNamedateTimeLbl: UILabel!
    @IBOutlet weak var EventPricelbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        eventImageView.layer.cornerRadius = 5
        eventImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
