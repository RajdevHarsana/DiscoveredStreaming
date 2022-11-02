//
//  RecentlyAddedCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 27/06/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class RecentlyAddedCell: UITableViewCell {

    @IBOutlet weak var reportBtn: UIButton!
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var SongNameLbl: UILabel!
    @IBOutlet weak var songDesLbl: UILabel!
    @IBOutlet weak var songTimeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
