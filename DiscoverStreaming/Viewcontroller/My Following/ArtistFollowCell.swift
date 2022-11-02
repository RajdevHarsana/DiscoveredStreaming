//
//  ArtistFollowCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 16/01/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class ArtistFollowCell: UITableViewCell,FloatRatingViewDelegate {

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLbl: UILabel!
    @IBOutlet weak var artistRateView: FloatRatingView!
    @IBOutlet weak var artistRatePer: UILabel!
    @IBOutlet weak var viewLbl: UILabel!
    @IBOutlet weak var unfollowBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.artistRateView.emptyImage = UIImage(named: "star_2")
        self.artistRateView.fullImage = UIImage(named: "star_1")
        // Optional params
        self.artistRateView.delegate = self
        self.artistRateView.contentMode = UIView.ContentMode.scaleAspectFit
        self.artistRateView.maxRating = 5
        self.artistRateView.minRating = 0
        self.artistRateView.editable = false
        self.artistRateView.halfRatings = false
        self.artistRateView.floatRatings = false
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
