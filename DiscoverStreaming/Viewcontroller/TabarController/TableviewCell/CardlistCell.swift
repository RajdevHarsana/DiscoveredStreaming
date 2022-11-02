//
//  CardlistCell.swift
//  DiscoverStreaming
//
//  Created by Ashish Soni on 06/04/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class CardlistCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var bankNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.borderColor = UIColor.white.cgColor
        cardView.layer.borderWidth = 1
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
