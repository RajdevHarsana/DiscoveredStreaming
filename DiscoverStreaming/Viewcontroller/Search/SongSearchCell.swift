//
//  SongSearchCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 10/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class SongSearchCell: UITableViewCell,FloatRatingViewDelegate {

    @IBOutlet weak var SongNameLbl: UILabel!
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songDesLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var viewLbl: UILabel!
    @IBOutlet weak var ratingview: FloatRatingView!
    @IBOutlet weak var ratingperLbl: UILabel!
    @IBOutlet weak var TimeLbl: UILabel!
    @IBOutlet weak var artistNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ratingview.emptyImage = UIImage(named: "star_2")
        self.ratingview.fullImage = UIImage(named: "star_1")
        // Optional params
        self.ratingview.delegate = self
        self.ratingview.contentMode = UIView.ContentMode.scaleAspectFit
        self.ratingview.maxRating = 5
        self.ratingview.minRating = 0
        self.ratingview.editable = false
        self.ratingview.halfRatings = false
        self.ratingview.floatRatings = false
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
