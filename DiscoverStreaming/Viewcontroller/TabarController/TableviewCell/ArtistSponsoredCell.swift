//
//  ArtistSponsoredCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 25/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ArtistSponsoredCell: UITableViewCell,FloatRatingViewDelegate {

    @IBOutlet weak var ArtistImageView: UIImageView!
    @IBOutlet weak var ArtistName: UILabel!
    @IBOutlet weak var ArtistGenre: UILabel!
    @IBOutlet weak var DistanceLbl: UILabel!
    @IBOutlet weak var ViewLBl: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var ratingPerLbl: UILabel!
    @IBOutlet weak var sponseredLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var featuredArtist_img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ratingView.emptyImage = UIImage(named: "star_2")
        self.ratingView.fullImage = UIImage(named: "star_1")
        // Optional params
        self.ratingView.delegate = self
        self.ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 0
        self.ratingView.editable = false
        self.ratingView.halfRatings = false
        self.ratingView.floatRatings = false
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
