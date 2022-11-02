//
//  MoodsListCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class MoodsListCell: UICollectionViewCell {
    @IBOutlet weak var moodImageView: UILabel!
    @IBOutlet weak var moodsImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        moodImageView.layer.cornerRadius = 10
        moodImageView.clipsToBounds = true
        // Initialization code
    }
}
