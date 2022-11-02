//
//  CraeteVenueView.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/11/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class CraeteVenueView: UIView {

    @IBOutlet weak var conBtnb: UIButton!
    var buttonDoneHandler : (() -> Void)?
    class func intitiateFromNib() -> CraeteVenueView {
        let View1 = UINib.init(nibName: "CraeteVenueView", bundle: nil).instantiate(withOwner: self, options: nil).first as! CraeteVenueView
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        conBtnb.layer.cornerRadius = 12
    }

    @IBAction func conBtnAction(_ sender: Any) {
        buttonDoneHandler?()
    }
}
