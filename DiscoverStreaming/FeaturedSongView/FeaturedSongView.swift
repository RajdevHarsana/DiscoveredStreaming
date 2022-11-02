//
//  FeaturedSongView.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 21/09/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class FeaturedSongView: UIView {

    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    var buttonDoneHandler  : (() -> Void)?
     var buttonCancleHandler : (() -> Void)?
       
       class func intitiateFromNib() -> FeaturedSongView {
              let View1 = UINib.init(nibName: "FeaturedSongView", bundle: nil).instantiate(withOwner: self, options: nil).first as! FeaturedSongView
              return View1
          }
          
          override func awakeFromNib() {
              super.awakeFromNib()
            yesBtn.layer.cornerRadius = 18
            noBtn.layer.cornerRadius = 18
        }
    
    
    @IBAction func yesBtnAction(_ sender: Any) {
        buttonDoneHandler?()
    }
    
    @IBAction func noBtnAction(_ sender: Any) {
        buttonCancleHandler?()
    }

}
