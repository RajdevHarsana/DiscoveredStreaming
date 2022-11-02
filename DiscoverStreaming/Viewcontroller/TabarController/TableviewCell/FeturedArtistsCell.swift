//
//  FeturedArtistsCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class FeturedArtistsCell: UITableViewCell,FloatRatingViewDelegate  {
    
    
    @IBOutlet weak var follow_btn: UIButton!
    @IBOutlet weak var ArtistImageView: UIImageView!
    @IBOutlet weak var ArtistNameLbl: UILabel!
    @IBOutlet weak var genreslbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var viewLbl: UILabel!
    @IBOutlet weak var rationView: FloatRatingView!
    @IBOutlet weak var ratingPercentacgelbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.rationView.emptyImage = UIImage(named: "star_2")
        self.rationView.fullImage = UIImage(named: "star_1")
        // Optional params
        self.rationView.delegate = self
        self.rationView.contentMode = UIView.ContentMode.scaleAspectFit
        self.rationView.maxRating = 5
        self.rationView.minRating = 0
        self.rationView.editable = false
        self.rationView.halfRatings = false
        self.rationView.floatRatings = false
        // Initialization code
    }
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
//        self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
//        self.liveLabel.text = String(self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
//        self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
