//
//  RevenueEventCell.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 28/08/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class RevenueEventCell: UITableViewCell {
   
    @IBOutlet weak var revenueEvent_Img: UIImageView!
    @IBOutlet weak var revenueEventName_Lbl: UILabel!
    @IBOutlet weak var revenueEventDate_Lbl: UILabel!
    @IBOutlet weak var revenueEventPrice_Lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        revenueEvent_Img.layer.cornerRadius = 10

        revenueEvent_Img.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
