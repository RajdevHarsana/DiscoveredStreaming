//
//  RVenueListCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 14/10/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class RVenueListCell: UITableViewCell {

    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var venueName: UILabel!
    
    
    class func intiatefromNib() -> RVenueListCell {
        let cell = UINib.init(nibName: "RVenueListCell", bundle: nil).instantiate(withOwner: self, options: nil).first as! RVenueListCell
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
