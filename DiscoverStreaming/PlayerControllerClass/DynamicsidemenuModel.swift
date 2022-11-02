//
//  DynamicsidemenuModel.swift
//  HowLit
//
//  Created by Tarun Nagar on 16/07/18.
//  Copyright © 2018 Tarun Nagar. All rights reserved.
//

import UIKit

class DynamicsidemenuModel: NSObject {
    var contentView : UIView!  = UIView()
    fileprivate var darkview: UIView!
    fileprivate var backview: UIView!
    weak var window : UIWindow!
    var distanceOpenMenu : CGFloat = 0
    var tabBar = UITabBarController()
    //////////////////////////////////////////////////////////////
    func closewithAnimation()  {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: { () -> Void in
            // UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.contentView.frame.origin.y = +(UIScreen.main.bounds.size.width)
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
        window = UIApplication.shared.delegate?.window as? UIWindow
//        let sceneDelegate = UIApplication.shared.connectedScenes
//             .first!.delegate as! SceneDelegate
//        window = sceneDelegate.window
//        backview=UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
//        darkview = UIView(frame: backview.frame)
//        darkview.backgroundColor = UIColor.black
//        darkview.alpha = 0
//        window.addSubview(darkview)
//        window.addSubview(backview)
        
        self.configureContentview()
        self.applyshowbehaviour()
    }
    
  ///////////////////////////////////////////////////////////////
    fileprivate func configureContentview() {
        
        contentView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: contentView.frame.size.height)
        contentView.backgroundColor = UIColor(red: 36/255, green: 40/255, blue: 50/255, alpha: 1.0)
//        contentView.layer.cornerRadius = 4
        //contentView.layer.borderColor=UIColor.init(red: 205/255, green: 0/255, blue: 243/255, alpha: 1).cgColor
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth=1
        window.addSubview(contentView)
        
    }
    
    //////////////////////////////////////////////////////////////////
    fileprivate func applyshowbehaviour() {
        let tabFrame = tabBar.tabBar.frame.size.height
        print(tabFrame)
        print(self.contentView.frame.height)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.contentView.frame.origin.y = UIScreen.main.bounds.size.height - tabFrame - self.contentView.frame.size.height-34
            self.darkview?.alpha = 0.7
        },completion: { (finished: Bool) -> Void in
            self.window?.backgroundColor = UIColor.black
        })
    }
}
