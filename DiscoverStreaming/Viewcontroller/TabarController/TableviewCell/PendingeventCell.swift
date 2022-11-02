//
//  PendingeventCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class PendingeventCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var EventAddress: UILabel!
    @IBOutlet weak var VenueNameDateTiemLbl: UILabel!
    @IBOutlet weak var PriceLbl: UILabel!
    @IBOutlet weak var cancelbtn: UIButton!
    @IBOutlet weak var publishBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
