//
//  ProfileCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var NameInfoLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
