//
//  EventSearchCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 10/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class EventSearchCell: UITableViewCell {

    @IBOutlet weak var EventImage: UIImageView!
    @IBOutlet weak var EventNamnLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var venuenamedateTimeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
