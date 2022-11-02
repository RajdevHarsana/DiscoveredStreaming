//
//  Logoutview.swift
//  DiscoverStreaming
//
//  Created by Ashish Soni on 03/04/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class Logoutview: UIView {

    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    var buttonDoneHandler  : (() -> Void)?
     var buttonCancleHandler : (() -> Void)?
       
       class func intitiateFromNib() -> Logoutview {
              let View1 = UINib.init(nibName: "Logoutview", bundle: nil).instantiate(withOwner: self, options: nil).first as! Logoutview
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
