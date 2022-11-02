//
//  BandsFollowCell.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 16/01/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class BandsFollowCell: UITableViewCell,FloatRatingViewDelegate {

    @IBOutlet weak var bandImageview: UIImageView!
    @IBOutlet weak var bandNameLbl: UILabel!
    @IBOutlet weak var bandRatingView: FloatRatingView!
    @IBOutlet weak var bandRatePer: UILabel!
    @IBOutlet weak var viewLbl: UILabel!
    @IBOutlet weak var unFollowBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.bandRatingView.emptyImage = UIImage(named: "star_2")
        self.bandRatingView.fullImage = UIImage(named: "star_1")
        // Optional params
        self.bandRatingView.delegate = self
        self.bandRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.bandRatingView.maxRating = 5
        self.bandRatingView.minRating = 0
        self.bandRatingView.editable = false
        self.bandRatingView.halfRatings = false
        self.bandRatingView.floatRatings = false
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
