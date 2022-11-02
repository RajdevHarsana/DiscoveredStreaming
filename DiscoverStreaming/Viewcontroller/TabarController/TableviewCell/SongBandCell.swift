//
//  SongBandCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/11/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class SongBandCell: UITableViewCell {

    @IBOutlet weak var bandNameLbl: UILabel!
    @IBOutlet weak var radioBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
