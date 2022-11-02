//
//  VenuesFollowCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 16/01/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class VenuesFollowCell: UITableViewCell,FloatRatingViewDelegate {

    @IBOutlet weak var venueImageview: UIImageView!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var venueRatingView: FloatRatingView!
    @IBOutlet weak var venueRatePer: UILabel!
    @IBOutlet weak var viewslbl: UILabel!
    @IBOutlet weak var unfollowBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.venueRatingView.emptyImage = UIImage(named: "star_2")
        self.venueRatingView.fullImage = UIImage(named: "star_1")
        // Optional params
        self.venueRatingView.delegate = self
        self.venueRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.venueRatingView.maxRating = 5
        self.venueRatingView.minRating = 0
        self.venueRatingView.editable = false
        self.venueRatingView.halfRatings = false
        self.venueRatingView.floatRatings = false
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
