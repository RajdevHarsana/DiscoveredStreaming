//
//  EventsCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class EventsCell: UITableViewCell {

    @IBOutlet weak var eventSponsered_btn: UIButton!
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
