//
//  ArtistSongCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ArtistSongCell: UITableViewCell,FloatRatingViewDelegate {

    @IBOutlet weak var featuredSong_img: UIImageView!
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songNAme: UILabel!
    @IBOutlet weak var Genres: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var rating: FloatRatingView!
    @IBOutlet weak var ratingPer: UILabel!
    @IBOutlet weak var songTime: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.rating.emptyImage = UIImage(named: "star_2")
        self.rating.fullImage = UIImage(named: "star_1")
        // Optional params
        self.rating.delegate = self
        self.rating.contentMode = UIView.ContentMode.scaleAspectFit
        self.rating.maxRating = 5
        self.rating.minRating = 0
        self.rating.editable = false
        self.rating.halfRatings = false
        self.rating.floatRatings = false
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
