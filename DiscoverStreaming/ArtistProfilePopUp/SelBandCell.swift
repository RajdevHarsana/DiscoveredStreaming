//
//  SelBandCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 21/11/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class SelBandCell: UITableViewCell {

    @IBOutlet weak var bandnameLbl: UILabel!
    
    class func intiatefromNib() -> SelBandCell {
        let cell = UINib.init(nibName: "SelBandCell", bundle: nil).instantiate(withOwner: self, options: nil).first as! SelBandCell
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
