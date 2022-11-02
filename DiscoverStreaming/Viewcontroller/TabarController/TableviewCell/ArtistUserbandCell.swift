//
//  ArtistUserbandCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ArtistUserbandCell: UITableViewCell {

    @IBOutlet weak var bandImageView: UIImageView!
    @IBOutlet weak var bandNameLbl: UILabel!
    @IBOutlet weak var bandArtistLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bandImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
