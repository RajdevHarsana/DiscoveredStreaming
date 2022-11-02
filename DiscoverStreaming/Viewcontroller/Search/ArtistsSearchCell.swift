//
//  ArtistsSearchCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 10/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ArtistsSearchCell: UITableViewCell,FloatRatingViewDelegate {

    @IBOutlet weak var ArtistImage: UIImageView!
    @IBOutlet weak var ArtistNameLbl: UILabel!
    @IBOutlet weak var RatingView: FloatRatingView!
    @IBOutlet weak var RatingPer: UILabel!
    @IBOutlet weak var GenreLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var ViewLbl: UILabel!
    @IBOutlet weak var artistlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.RatingView.emptyImage = UIImage(named: "star_2")
        self.RatingView.fullImage = UIImage(named: "star_1")
        // Optional params
        self.RatingView.delegate = self
        self.RatingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.RatingView.maxRating = 5
        self.RatingView.minRating = 0
        self.RatingView.editable = false
        self.RatingView.halfRatings = false
        self.RatingView.floatRatings = false
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
