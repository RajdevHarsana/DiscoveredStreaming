//
//  UpcomingEventsTableCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 05/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class UpcomingEventsTableCell: UITableViewCell {
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var EventNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var datetimeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        eventImage.layer.cornerRadius = 10

        eventImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
