//
//  PlayListSongCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class PlayListSongCell: UITableViewCell {

    @IBOutlet weak var song: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songdesLbl: UILabel!
    @IBOutlet weak var songTimeLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
