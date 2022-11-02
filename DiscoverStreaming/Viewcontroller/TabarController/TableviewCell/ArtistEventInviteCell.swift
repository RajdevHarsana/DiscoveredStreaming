//
//  ArtistEventInviteCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ArtistEventInviteCell: UITableViewCell {

    @IBOutlet weak var evnetImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var venuenamelbl: UILabel!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var accpetBtn: UIButton!
    @IBOutlet weak var venLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
