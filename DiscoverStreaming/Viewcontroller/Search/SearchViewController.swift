//
//  SearchViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 10/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var Songlbl: UILabel!
    @IBOutlet weak var songBtn: UIButton!
    @IBOutlet weak var ArtistLbl: UILabel!
    @IBOutlet weak var ArtistBtn: UIButton!
    @IBOutlet weak var EventLbl: UILabel!
    @IBOutlet weak var EventBtn: UIButton!
    @IBOutlet weak var VenueLbl: UILabel!
    @IBOutlet weak var VenueBtn: UIButton!
    
    var controller_str:String!
    var defaults :UserDefaults!
    var filter_str:String!
    
    @IBOutlet weak var view_main: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        defaults.removeObject(forKey: "APICALLEVENT")
        defaults.removeObject(forKey: "APICALL")
        defaults.removeObject(forKey: "APICALLAR")
        defaults.removeObject(forKey: "APICALLVENUE")
        defaults.removeObject(forKey: "FilterValue")
        defaults.removeObject(forKey: "FilterValue1")
        defaults.removeObject(forKey: "FilterValue2")
        defaults.removeObject(forKey: "FilterValue3")
        
        controller_str = defaults.value(forKey: "SongData") as? String
        if controller_str == "Song" {
        songBtn.setTitleColor(UIColor.white, for: .normal)
        ArtistBtn.setTitleColor(UIColor.lightGray, for: .normal)
        EventBtn.setTitleColor(UIColor.lightGray, for: .normal)
        VenueBtn.setTitleColor(UIColor.lightGray, for: .normal)
        filter_str = "Song"
        let defaults = UserDefaults.standard
        defaults.set(filter_str, forKey: "FilterData")
        defaults.synchronize()
        
        Songlbl.isHidden = false
        ArtistLbl.isHidden = true
        EventLbl.isHidden = true
        VenueLbl.isHidden = true
        
        
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "SongSearchViewController") as! SongSearchViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        }else if controller_str == "Artist" {
            if self.children.count > 0{
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
            
            songBtn.setTitleColor(UIColor.lightGray, for: .normal)
            ArtistBtn.setTitleColor(UIColor.white, for: .normal)
            EventBtn.setTitleColor(UIColor.lightGray, for: .normal)
            VenueBtn.setTitleColor(UIColor.lightGray, for: .normal)
            filter_str = "Artist"
            let defaults = UserDefaults.standard
            defaults.set(filter_str, forKey: "FilterData")
            defaults.synchronize()
            
            Songlbl.isHidden = true
            ArtistLbl.isHidden = false
            EventLbl.isHidden = true
            VenueLbl.isHidden = true
            
            let controller4 = storyboard?.instantiateViewController(withIdentifier: "ArtistSearchViewController") as! ArtistSearchViewController
            controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
            controller4.willMove(toParent: self)
            self.view_main.addSubview(controller4.view)
            self.addChild(controller4)
            controller4.didMove(toParent: self)
        }else if controller_str == "Event" {
            if self.children.count > 0{
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
            
            songBtn.setTitleColor(UIColor.lightGray, for: .normal)
            ArtistBtn.setTitleColor(UIColor.lightGray, for: .normal)
            EventBtn.setTitleColor(UIColor.white, for: .normal)
            VenueBtn.setTitleColor(UIColor.lightGray, for: .normal)
            filter_str = "Event"
            let defaults = UserDefaults.standard
            defaults.set(filter_str, forKey: "FilterData")
            defaults.synchronize()
            
            Songlbl.isHidden = true
            ArtistLbl.isHidden = true
            EventLbl.isHidden = false
            VenueLbl.isHidden = true
            
            let controller4 = storyboard?.instantiateViewController(withIdentifier: "EventSearchViewController") as! EventSearchViewController
            controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
            controller4.willMove(toParent: self)
            self.view_main.addSubview(controller4.view)
            self.addChild(controller4)
            controller4.didMove(toParent: self)
        }else {
            if self.children.count > 0{
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
            
            songBtn.setTitleColor(UIColor.lightGray, for: .normal)
            ArtistBtn.setTitleColor(UIColor.lightGray, for: .normal)
            EventBtn.setTitleColor(UIColor.lightGray, for: .normal)
            VenueBtn.setTitleColor(UIColor.white, for: .normal)
            filter_str = "Venue"
            let defaults = UserDefaults.standard
            defaults.set(filter_str, forKey: "FilterData")
            defaults.synchronize()
            
            Songlbl.isHidden = true
            ArtistLbl.isHidden = true
            EventLbl.isHidden = true
            VenueLbl.isHidden = false
            
            let controller4 = storyboard?.instantiateViewController(withIdentifier: "VenueSearchViewController") as! VenueSearchViewController
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
        defaults.removeObject(forKey: "APICALLEVENT")
        defaults.removeObject(forKey: "APICALL")
        defaults.removeObject(forKey: "APICALLAR")
        defaults.removeObject(forKey: "APICALLVENUE")
        defaults.removeObject(forKey: "FilterValue")
        defaults.removeObject(forKey: "FilterValue1")
        defaults.removeObject(forKey: "FilterValue2")
        defaults.removeObject(forKey: "FilterValue3")
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        
        songBtn.setTitleColor(UIColor.white, for: .normal)
        ArtistBtn.setTitleColor(UIColor.lightGray, for: .normal)
        EventBtn.setTitleColor(UIColor.lightGray, for: .normal)
        VenueBtn.setTitleColor(UIColor.lightGray, for: .normal)
        filter_str = "Song"
        let defaults = UserDefaults.standard
        defaults.set(filter_str, forKey: "FilterData")
        defaults.synchronize()
        
        Songlbl.isHidden = false
        ArtistLbl.isHidden = true
        EventLbl.isHidden = true
        VenueLbl.isHidden = true
        
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "SongSearchViewController") as! SongSearchViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    @IBAction func ArtistBtnAction(_ sender: Any) {
        
        defaults.removeObject(forKey: "ORDERTYPE")
        defaults.removeObject(forKey: "SORTORDER")
        defaults.removeObject(forKey: "APICALL")
        defaults.removeObject(forKey: "APICALLAR")
        defaults.removeObject(forKey: "APICALLEVENT")
        defaults.removeObject(forKey: "APICALLVENUE")
        defaults.removeObject(forKey: "FilterValue")
        defaults.removeObject(forKey: "FilterValue1")
        defaults.removeObject(forKey: "FilterValue2")
        defaults.removeObject(forKey: "FilterValue3")
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        
        songBtn.setTitleColor(UIColor.lightGray, for: .normal)
        ArtistBtn.setTitleColor(UIColor.white, for: .normal)
        EventBtn.setTitleColor(UIColor.lightGray, for: .normal)
        VenueBtn.setTitleColor(UIColor.lightGray, for: .normal)
        filter_str = "Artist"
        let defaults = UserDefaults.standard
        defaults.set(filter_str, forKey: "FilterData")
        defaults.synchronize()
        
        Songlbl.isHidden = true
        ArtistLbl.isHidden = false
        EventLbl.isHidden = true
        VenueLbl.isHidden = true
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "ArtistSearchViewController") as! ArtistSearchViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    @IBAction func eventBtnAction(_ sender: Any) {
        defaults.removeObject(forKey: "ORDERTYPE")
        defaults.removeObject(forKey: "SORTORDER")
        defaults.removeObject(forKey: "APICALL")
        defaults.removeObject(forKey: "APICALLAR")
        defaults.removeObject(forKey: "APICALLEVENT")
        defaults.removeObject(forKey: "APICALLVENUE")
        defaults.removeObject(forKey: "FilterValue")
        defaults.removeObject(forKey: "FilterValue1")
        defaults.removeObject(forKey: "FilterValue2")
        defaults.removeObject(forKey: "FilterValue3")
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        
        songBtn.setTitleColor(UIColor.lightGray, for: .normal)
        ArtistBtn.setTitleColor(UIColor.lightGray, for: .normal)
        EventBtn.setTitleColor(UIColor.white, for: .normal)
        VenueBtn.setTitleColor(UIColor.lightGray, for: .normal)
        filter_str = "Event"
        let defaults = UserDefaults.standard
        defaults.set(filter_str, forKey: "FilterData")
        defaults.synchronize()
        
        Songlbl.isHidden = true
        ArtistLbl.isHidden = true
        EventLbl.isHidden = false
        VenueLbl.isHidden = true
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "EventSearchViewController") as! EventSearchViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    
    
    @IBAction func VenueBtnAction(_ sender: Any) {
        defaults.removeObject(forKey: "ORDERTYPE")
        defaults.removeObject(forKey: "SORTORDER")
        defaults.removeObject(forKey: "APICALL")
        defaults.removeObject(forKey: "APICALLEVENT")
        defaults.removeObject(forKey: "APICALLAR")
        defaults.removeObject(forKey: "APICALLVENUE")
        defaults.removeObject(forKey: "FilterValue")
        defaults.removeObject(forKey: "FilterValue1")
        defaults.removeObject(forKey: "FilterValue2")
        defaults.removeObject(forKey: "FilterValue3")
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        
        songBtn.setTitleColor(UIColor.lightGray, for: .normal)
        ArtistBtn.setTitleColor(UIColor.lightGray, for: .normal)
        EventBtn.setTitleColor(UIColor.lightGray, for: .normal)
        VenueBtn.setTitleColor(UIColor.white, for: .normal)
        filter_str = "Venue"
        let defaults = UserDefaults.standard
        defaults.set(filter_str, forKey: "FilterData")
        defaults.synchronize()
        
        Songlbl.isHidden = true
        ArtistLbl.isHidden = true
        EventLbl.isHidden = true
        VenueLbl.isHidden = false
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "VenueSearchViewController") as! VenueSearchViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        defaults.removeObject(forKey: "ORDERTYPE")
        defaults.removeObject(forKey: "SORTORDER")
        defaults.removeObject(forKey: "APICALL")
        let isComingFrom = "isPlaying"
        Config().AppUserDefaults.set(isComingFrom, forKey: "SearchSongPlayer")
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
