//
//  EventDetailViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    @IBOutlet weak var song_lbl: UILabel!
    @IBOutlet weak var song_Btn: UIButton!
    @IBOutlet weak var artits_Lbl: UILabel!
    @IBOutlet weak var artist_btn: UIButton!
    @IBOutlet weak var event_lbl: UILabel!
    @IBOutlet weak var event_btn: UIButton!
    @IBOutlet weak var venue_lbl: UILabel!
    @IBOutlet weak var venue_btn: UIButton!
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var defaults:UserDefaults!
    var bandname:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        bandname = defaults.value(forKey: "BandName") as? String
        titleLbl.text = bandname
        song_Btn.setTitleColor(UIColor.white, for: .normal)
        artist_btn.setTitleColor(UIColor.lightGray, for: .normal)
        event_btn.setTitleColor(UIColor.lightGray, for: .normal)
        venue_btn.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        song_lbl.isHidden = false
        artits_Lbl.isHidden = true
        event_lbl.isHidden = true
        venue_lbl.isHidden = true
        
        
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "EventUserDetailViewController") as! EventUserDetailViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        
        // Do any additional setup after loading the view.
    }
    
    func displayContentController(content: UIViewController) {
        addChild(content)
        self.view_main.addSubview(content.view)
        content.didMove(toParent: self)
    }
    
    @IBAction func songBtnAction(_ sender: Any) {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        
        song_Btn.setTitleColor(UIColor.white, for: .normal)
        artist_btn.setTitleColor(UIColor.lightGray, for: .normal)
        event_btn.setTitleColor(UIColor.lightGray, for: .normal)
        venue_btn.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        song_lbl.isHidden = false
        artits_Lbl.isHidden = true
        event_lbl.isHidden = true
        venue_lbl.isHidden = true
        
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "EventUserDetailViewController") as! EventUserDetailViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    @IBAction func artist_btnAction(_ sender: Any) {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        
        song_Btn.setTitleColor(UIColor.lightGray, for: .normal)
        artist_btn.setTitleColor(UIColor.white, for: .normal)
        event_btn.setTitleColor(UIColor.lightGray, for: .normal)
        venue_btn.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        song_lbl.isHidden = true
        artits_Lbl.isHidden = false
        event_lbl.isHidden = true
        venue_lbl.isHidden = true
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "EventUserSongViewController") as! EventUserSongViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    @IBAction func EventBtnAction(_ sender: Any) {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        
        song_Btn.setTitleColor(UIColor.lightGray, for: .normal)
        artist_btn.setTitleColor(UIColor.lightGray, for: .normal)
        event_btn.setTitleColor(UIColor.white, for: .normal)
        venue_btn.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        song_lbl.isHidden = true
        artits_Lbl.isHidden = true
        event_lbl.isHidden = false
        venue_lbl.isHidden = true
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "EventUserMemberViewController") as! EventUserMemberViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    
    @IBAction func venueBtnAction(_ sender: Any) {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        
        song_Btn.setTitleColor(UIColor.lightGray, for: .normal)
        artist_btn.setTitleColor(UIColor.lightGray, for: .normal)
        event_btn.setTitleColor(UIColor.lightGray, for: .normal)
        venue_btn.setTitleColor(UIColor.white, for: .normal)
        
        
        song_lbl.isHidden = true
        artits_Lbl.isHidden = true
        event_lbl.isHidden = true
        venue_lbl.isHidden = false
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "EventUserEventsViewController") as! EventUserEventsViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }

    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
