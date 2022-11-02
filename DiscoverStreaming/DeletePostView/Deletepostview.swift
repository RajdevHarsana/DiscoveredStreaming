//
//  Deletepostview.swift
//  DiscoverStreaming
//
//  Created by Ashish Soni on 03/04/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class Deletepostview: UIView {

    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtb: UIButton!
    var buttonDoneHandler  : (() -> Void)?
    var buttonCancleHandler : (() -> Void)?
    
    class func intitiateFromNib() -> Deletepostview {
           let View1 = UINib.init(nibName: "Deletepostview", bundle: nil).instantiate(withOwner: self, options: nil).first as! Deletepostview
           return View1
       }
       
       override func awakeFromNib() {
           super.awakeFromNib()
        yesBtn.layer.cornerRadius = 18
        noBtb.layer.cornerRadius = 18
    }
    
    @IBAction func yesBtnAction(_ sender: Any) {
          buttonDoneHandler?()
    }
    
    @IBAction func noBtnAction(_ sender: Any) {
          buttonCancleHandler?()
    }
}
