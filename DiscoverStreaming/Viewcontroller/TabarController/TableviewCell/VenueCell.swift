//
//  VenueCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class VenueCell: UITableViewCell,FloatRatingViewDelegate {

    @IBOutlet weak var venueSponsered_btn: UIButton!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var venueRation: FloatRatingView!
    @IBOutlet weak var venueAddress: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var ratingPerLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.venueRation.emptyImage = UIImage(named: "star_2")
        self.venueRation.fullImage = UIImage(named: "star_1")
        // Optional params
        self.venueRation.delegate = self
        self.venueRation.contentMode = UIView.ContentMode.scaleAspectFit
        self.venueRation.maxRating = 5
        self.venueRation.minRating = 0
        self.venueRation.editable = false
        self.venueRation.halfRatings = false
        self.venueRation.floatRatings = false
        // Initialization code
    }
    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        //        self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
        //self.liveLabel.text = String(self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
