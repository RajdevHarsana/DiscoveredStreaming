//
//  BecomeArtistPopUpView.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/09/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class BecomeArtistPopUpView: UIView {
    
    var buttonCancelHandler : (() -> Void)?
    var buttonDoneHandler : (() -> Void)?

    class func intitiateFromNib() -> BecomeArtistPopUpView {
        let View1 = UINib.init(nibName: "BecomeArtistPopUpView", bundle: nil).instantiate(withOwner: self, options: nil).first as! BecomeArtistPopUpView
        
        return View1
    }

    @IBAction func cancelBtnaction(_ sender: Any) {
         self.buttonCancelHandler?()
    }
    @IBAction func postBtnAction(_ sender: Any) {
         self.buttonDoneHandler?()
    }
    
}
