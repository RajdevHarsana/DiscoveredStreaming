//
//  PlaySongListCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 07/03/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class PlaySongListCell: UITableViewCell {

    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songNameLbl: UILabel!
    @IBOutlet weak var arNameLbl: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
