//
//  SongRevenueCell.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 21/09/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class SongRevenueCell: UITableViewCell {

    @IBOutlet weak var revenueSong_Img: UIImageView!
    @IBOutlet weak var revenueSongName_Lbl: UILabel!
    @IBOutlet weak var revenueSongDate_Lbl: UILabel!
    @IBOutlet weak var revenueSongPrice_Lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        revenueSong_Img.layer.cornerRadius = 10

        revenueSong_Img.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
