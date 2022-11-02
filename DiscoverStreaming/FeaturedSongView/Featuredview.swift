//
//  Featuredview.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 21/09/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class Featuredview: UIView {

    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    var buttonDoneHandeler : (() -> Void)?
    var buttonCancleHandeler : (() -> Void)?
    
    class func intitiateFromNib() -> Featuredview {
        let view2 = UINib.init(nibName: "Featuredview", bundle: nil).instantiate(withOwner: self, options: nil).first as! Featuredview
        return view2
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()

    }
    
    
    @IBAction func yesBtnAction(_ sender: Any) {
        buttonDoneHandeler?()
    }
    
    @IBAction func noBtnAction(_ sender: Any) {
        buttonCancleHandeler?()
    }
    
    
}
