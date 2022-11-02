//
//  PlaylistCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 19/02/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class PlaylistCell: UITableViewCell {

    @IBOutlet weak var playlistImage: UIImageView!
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var songcountLbl: UILabel!
    @IBOutlet weak var dotBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
