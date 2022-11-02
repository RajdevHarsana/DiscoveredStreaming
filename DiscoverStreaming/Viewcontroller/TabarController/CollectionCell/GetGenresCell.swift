//
//  GetGenresCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 12/09/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class GetGenresCell: UICollectionViewCell {
    @IBOutlet weak var genreBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        genreBtn.layer.cornerRadius = 18
        genreBtn.layer.borderWidth = 1
        genreBtn.layer.borderColor = UIColor(red: 255/255, green: 4/255, blue: 160/255, alpha: 1.0).cgColor
        // Initialization code
    }
    
}
