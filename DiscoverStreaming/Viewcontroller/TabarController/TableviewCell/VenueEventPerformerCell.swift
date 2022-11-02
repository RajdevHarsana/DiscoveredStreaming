//
//  VenueEventPerformerCell.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 10/08/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class VenueEventPerformerCell: UITableViewCell {

    
    @IBOutlet weak var performerImage: UIImageView!
    @IBOutlet weak var performenameLbl: UILabel!
    @IBOutlet weak var performerAddlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
