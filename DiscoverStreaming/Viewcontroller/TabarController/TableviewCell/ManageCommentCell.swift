//
//  ManageCommentCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/03/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class ManageCommentCell: UITableViewCell {

    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var UsernameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var reportBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        commentImage.layer.cornerRadius = commentImage.frame.height/2
        commentImage.layer.masksToBounds = true
        commentImage.clipsToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
