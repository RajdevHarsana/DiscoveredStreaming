//
//  SongViewCell.swift
//  LnPopUpDemo
//
//  Created by MAC-27 on 24/09/20.
//  Copyright © 2020 MAC-27. All rights reserved.
//

import UIKit

class SongViewCell1: UITableViewCell {
    
    @IBOutlet weak var song_img: UIImageView!
    @IBOutlet weak var song_Name: UILabel!
    @IBOutlet weak var song_Artist_Name: UILabel!
    @IBOutlet weak var downloadSong_btn: UIButton!
    @IBOutlet weak var more_btn: UIButton!
    
    class func intiatefromNib() -> SongViewCell1 {
        let cell = UINib.init(nibName: "SongViewCell1", bundle: nil).instantiate(withOwner: self, options: nil).first as! SongViewCell1
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
