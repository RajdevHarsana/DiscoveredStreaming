//
//  OngoingCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 09/01/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class OngoingCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var EventNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var datetimeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
