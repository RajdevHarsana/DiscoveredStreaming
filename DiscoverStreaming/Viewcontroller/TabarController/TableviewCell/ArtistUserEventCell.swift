//
//  ArtistUserEventCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ArtistUserEventCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var EvnetNameLbl: UILabel!
    @IBOutlet weak var EventAddress: UILabel!
    @IBOutlet weak var EventVenueNameDateTimeLbl: UILabel!
    @IBOutlet weak var EventPriceLbl: UILabel!
    @IBOutlet weak var sponsoredbtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
