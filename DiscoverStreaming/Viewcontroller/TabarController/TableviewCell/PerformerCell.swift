//
//  PerformerCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class PerformerCell: UITableViewCell {

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
