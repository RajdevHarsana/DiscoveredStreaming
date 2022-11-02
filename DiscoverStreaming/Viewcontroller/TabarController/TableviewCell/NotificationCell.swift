//
//  NotificationCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 05/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var msg_Img: UIImageView!
    @IBOutlet weak var msg_Lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
