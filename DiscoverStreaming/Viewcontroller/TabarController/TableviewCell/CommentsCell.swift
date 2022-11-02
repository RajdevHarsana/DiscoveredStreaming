//
//  CommentsCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {

    @IBOutlet weak var profileImagview: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var reportBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImagview.layer.cornerRadius = profileImagview.frame.height/2
        profileImagview.layer.masksToBounds = true
        profileImagview.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
