//
//  InviteBecomeArtistCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class InviteBecomeArtistCell: UITableViewCell {

    @IBOutlet weak var inviteBtn: UIButton!
    
    @IBOutlet weak var ArtistImage: UIImageView!
    @IBOutlet weak var ArtistName: UILabel!
    @IBOutlet weak var ArtistDes: UILabel!
    @IBOutlet weak var bandNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
