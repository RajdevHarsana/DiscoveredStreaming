//
//  VenueDetailViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class VenueDetailViewController: UIViewController {
    @IBOutlet weak var song_lbl: UILabel!
    @IBOutlet weak var song_Btn: UIButton!
    @IBOutlet weak var venue_lbl: UILabel!
    @IBOutlet weak var venue_btn: UIButton!
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var titlrLbl: UILabel!
    var flag = Bool()
    var nameVenue = String()
    var notiFrom = Bool()
    var notiId = Int()
    var defaults:UserDefaults!
    var venueName:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.venueName = nameVenue
        titlrLbl.text = venueName
        song_Btn.setTitleColor(UIColor.white, for: .normal)
        venue_btn.setTitleColor(UIColor.lightGray, for: .normal)
        song_lbl.isHidden = false
        venue_lbl.isHidden = true

        if flag == true{
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "VenueUserDetailViewController") as! VenueUserDetailViewController
        controller4.flag = flag
        controller4.typeID = notiId
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        }else{
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "VenueUserDetailViewController") as! VenueUserDetailViewController
        controller4.flag = notiFrom
        controller4.typeID = notiId
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        }
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
        if flag == true{
        self.venueName = nameVenue
        titlrLbl.text = venueName
        song_Btn.setTitleColor(UIColor.white, for: .normal)
        venue_btn.setTitleColor(UIColor.lightGray, for: .normal)
        song_lbl.isHidden = false
        venue_lbl.isHidden = true
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "VenueUserDetailViewController") as! VenueUserDetailViewController
        controller4.flag = flag
        controller4.typeID = notiId
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        }else{
        self.venueName = nameVenue
        titlrLbl.text = venueName
        song_Btn.setTitleColor(UIColor.white, for: .normal)
        venue_btn.setTitleColor(UIColor.lightGray, for: .normal)
        song_lbl.isHidden = false
        venue_lbl.isHidden = true
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "VenueUserDetailViewController") as! VenueUserDetailViewController
        controller4.flag = notiFrom
        controller4.typeID = notiId
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        }
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
        if flag == true{
        self.venueName = nameVenue
        titlrLbl.text = venueName
        song_Btn.setTitleColor(UIColor.white, for: .normal)
        venue_btn.setTitleColor(UIColor.lightGray, for: .normal)
        song_lbl.isHidden = true
        venue_lbl.isHidden = false
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "VenueUserEventViewController") as! VenueUserEventViewController
        controller4.flag = flag
        controller4.typeID = notiId
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        }else{
        self.venueName = nameVenue
        titlrLbl.text = venueName
        song_Btn.setTitleColor(UIColor.white, for: .normal)
        venue_btn.setTitleColor(UIColor.lightGray, for: .normal)
        song_lbl.isHidden = true
        venue_lbl.isHidden = false
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "VenueUserEventViewController") as! VenueUserEventViewController
        controller4.flag = notiFrom
        controller4.typeID = notiId
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        }
    }

    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
