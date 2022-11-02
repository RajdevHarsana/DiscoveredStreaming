//
//  BackModel.swift
//  Picsort
//
//  Created by Hitesh Saini on 2/1/18.
//  Copyright © 2018 PixelPoint Technology. All rights reserved.
//

import UIKit

class BackModel: NSObject {
    
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
        darkview.backgroundColor = UIColor.clear
        darkview.alpha = 1.0
        window.addSubview(darkview)
        window.addSubview(backview)
        contentView.isHidden = false
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BackModel.dismissView))
        self.window.addGestureRecognizer(tap)
        self.configureContentview()
        self.applyshowbehaviour()
    }
    
    @objc func dismissView() {
        self.backview.isHidden=true
        self.darkview.isHidden = true
        self.contentView.removeFromSuperview()
    }
    
    ///////////////////////////////////////////////////////////////
    fileprivate func configureContentview() {
        contentView.frame = CGRect(x: 5, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width-180, height: contentView.frame.size.height-15)
        contentView.backgroundColor=UIColor(red: 36/255, green: 40/255, blue: 50/255, alpha: 1)
        contentView.layer.cornerRadius = 4
        //contentView.layer.borderColor=UIColor.init(red: 205/255, green: 0/255, blue: 243/255, alpha: 1).cgColor
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth=1
        backview.addSubview(contentView)
        
    }
    
    //////////////////////////////////////////////////////////////////
    fileprivate func applyshowbehaviour() {
        let IS_IPHONEX = (UIScreen.main.bounds.size.height - 667) != 0.0 ? false : true
        let IS_IPHONE_XS = (UIScreen.main.bounds.size.height - 667) != 0.0 ? false : true
        let IS_IPHONE_X_MAX = (UIScreen.main.bounds.size.height - 568) != 0.0 ? false : true
        let IS_IPHONE_XR = (UIScreen.main.bounds.size.height - 896) != 0.0 ? false : true
       
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            let screenSize = UIScreen.main.bounds
            var screenHeight:Int
            screenHeight  = Int(screenSize.height)
            if IS_IPHONEX  {
              self.contentView.frame.origin.y = CGFloat(screenHeight-450)
            }else if IS_IPHONE_XS {
                 self.contentView.frame.origin.y = CGFloat(screenHeight-450)
            }else if IS_IPHONE_X_MAX {
                 self.contentView.frame.origin.y = CGFloat(screenHeight-350)
            }else if IS_IPHONE_XR {
                 self.contentView.frame.origin.y = CGFloat(screenHeight-650)
            }
            else{
            self.contentView.frame.origin.y = CGFloat(screenHeight-572)
            }
           // self.contentView.frame.origin.y = 240
            self.darkview?.alpha = 1.0
        },completion: { (finished: Bool) -> Void in
            self.window?.backgroundColor = UIColor.clear
        })
    }
}

