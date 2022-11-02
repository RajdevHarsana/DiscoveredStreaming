//
//  MoodsSongCell.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 28/07/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class MoodsSongCell: UITableViewCell {
    
    @IBOutlet weak var featuredSong_img: UIImageView!
    @IBOutlet weak var moodssongImage: UIImageView!
    @IBOutlet weak var moodssongNameLbl: UILabel!
    @IBOutlet weak var moodssongTypeLbl: UILabel!
    @IBOutlet weak var moodssongDurationLbl: UILabel!
    @IBOutlet weak var moodsreport_btn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
