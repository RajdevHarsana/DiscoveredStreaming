//
//  popupmodel.swift
//  HowLit
//
//  Created by Tarun Nagar on 24/08/18.
//  Copyright © 2018 Tarun Nagar. All rights reserved.
//

import UIKit

class popupmodel: NSObject {
    fileprivate var contentView : UIView!  = UIView()
    fileprivate var darkview: UIView!
    fileprivate var backview: UIView!
    weak var window : UIWindow!
    //////////////////////////////////////////////////////////////
    func closewithAnimation()  {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: { () -> Void in
            // UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.contentView.frame.origin.y = +(UIScreen.main.bounds.size.height)
            self.darkview.alpha = 0
        },completion: { (finished: Bool) -> Void in
            self.backview.isHidden=true
            self.darkview.isHidden = true
            self.contentView.removeFromSuperview()
        })
    }
    ////////////////////////////////////////////////////////////////////
    func show(view: UIView) {
        
        self.contentView = view
        window = (UIApplication.shared.delegate?.window)!
        
        backview=UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        darkview = UIView(frame: backview.frame)
        darkview.backgroundColor = UIColor.black
        darkview.alpha = 0
        window.addSubview(darkview)
        window.addSubview(backview)
        
        self.configureContentview()
        self.applyshowbehaviour()
    }
    
   
    
    ///////////////////////////////////////////////////////////////
    fileprivate func configureContentview() {
        contentView.frame = CGRect(x: 5, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width-10, height: contentView.frame.size.height+10)
        contentView.backgroundColor=UIColor.clear
        contentView.layer.cornerRadius = 5
        //contentView.layer.borderColor=UIColor.init(red: 205/255, green: 0/255, blue: 243/255, alpha: 1).cgColor
        contentView.layer.borderColor = UIColor.clear.cgColor
       // contentView.layer.borderWidth=1
        backview.addSubview(contentView)
        
    }
    
    //////////////////////////////////////////////////////////////////
    fileprivate func applyshowbehaviour() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.contentView.frame.origin.y = 120
            self.darkview?.alpha = 0.7
        },completion: { (finished: Bool) -> Void in
            self.window?.backgroundColor = UIColor.black
        })
    }
}

