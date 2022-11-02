//
//  RecentlyAddedListCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class RecentlyAddedListCell: UITableViewCell {

    @IBOutlet weak var featuredSong_img: UIImageView!
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songNameLbl: UILabel!
    @IBOutlet weak var songTypeLbl: UILabel!
    @IBOutlet weak var songDurationLbl: UILabel!
    @IBOutlet weak var songReport_btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
