//
//  FeturedSongCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class FeturedSongCell: UITableViewCell {

    @IBOutlet weak var featuredsongImage: UIImageView!
    @IBOutlet weak var featuredsongNameLbl: UILabel!
    @IBOutlet weak var featuredsongTypeLbl: UILabel!
    @IBOutlet weak var featuredsongDurationLbl: UILabel!
    @IBOutlet weak var report_btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
