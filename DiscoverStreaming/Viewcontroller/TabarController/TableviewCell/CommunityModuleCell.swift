//
//  CommunityModuleCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 05/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class CommunityModuleCell: UITableViewCell {

    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var posttitle: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var commentcountLbl: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var postNameLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
