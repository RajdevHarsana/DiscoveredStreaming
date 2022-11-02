//
//  FilterViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 10/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var songBtn: UIButton!
    @IBOutlet weak var artistBtn: UIButton!
    @IBOutlet weak var eventBtn: UIButton!
    @IBOutlet weak var venueBtn: UIButton!
    @IBOutlet weak var venueLbl: UILabel!
    @IBOutlet weak var eventLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var songLbl: UILabel!
    var filter_str:String!
    var defaults:UserDefaults!
    
    @IBOutlet weak var view_mail: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        filter_str = defaults.value(forKey: "FilterData") as? String
        
        if filter_str == "Song"{
        songBtn.isUserInteractionEnabled = true
        artistBtn.isUserInteractionEnabled = false
        eventBtn.isUserInteractionEnabled = false
        venueBtn.isUserInteractionEnabled = false
        songBtn.setTitleColor(UIColor.white, for: .normal)
        artistBtn.setTitleColor(UIColor.lightGray, for: .normal)
        eventBtn.setTitleColor(UIColor.lightGray, for: .normal)
        venueBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        songLbl.isHidden = false
        artistLbl.isHidden = true
        eventLbl.isHidden = true
        venueLbl.isHidden = true
        
        
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "SongFilterViewController") as! SongFilterViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_mail.frame.size.width, height: self.view_mail.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_mail.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        }else if filter_str == "Artist"
        {
            if self.children.count > 0{
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
            songBtn.isUserInteractionEnabled = false
            artistBtn.isUserInteractionEnabled = true
            eventBtn.isUserInteractionEnabled = false
            venueBtn.isUserInteractionEnabled = false
            songBtn.setTitleColor(UIColor.lightGray, for: .normal)
            artistBtn.setTitleColor(UIColor.white, for: .normal)
            eventBtn.setTitleColor(UIColor.lightGray, for: .normal)
            venueBtn.setTitleColor(UIColor.lightGray, for: .normal)
            
            
            songLbl.isHidden = true
            artistLbl.isHidden = false
            eventLbl.isHidden = true
            venueLbl.isHidden = true
            
            let controller4 = storyboard?.instantiateViewController(withIdentifier: "ArtistFilterViewController") as! ArtistFilterViewController
            controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_mail.frame.size.width, height: self.view_mail.frame.size.height)
            controller4.willMove(toParent: self)
            self.view_mail.addSubview(controller4.view)
            self.addChild(controller4)
            controller4.didMove(toParent: self)
        }else if filter_str == "Event" {
            if self.children.count > 0{
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
            songBtn.isUserInteractionEnabled = false
            artistBtn.isUserInteractionEnabled = false
            eventBtn.isUserInteractionEnabled = true
            venueBtn.isUserInteractionEnabled = false
            songBtn.setTitleColor(UIColor.lightGray, for: .normal)
            artistBtn.setTitleColor(UIColor.lightGray, for: .normal)
            eventBtn.setTitleColor(UIColor.white, for: .normal)
            venueBtn.setTitleColor(UIColor.lightGray, for: .normal)
            
            
            songLbl.isHidden = true
            artistLbl.isHidden = true
            eventLbl.isHidden = false
            venueLbl.isHidden = true
            
            let controller4 = storyboard?.instantiateViewController(withIdentifier: "EventFilterViewController") as! EventFilterViewController
            controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_mail.frame.size.width, height: self.view_mail.frame.size.height)
            controller4.willMove(toParent: self)
            self.view_mail.addSubview(controller4.view)
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
            songBtn.isUserInteractionEnabled = false
            artistBtn.isUserInteractionEnabled = false
            eventBtn.isUserInteractionEnabled = false
            venueBtn.isUserInteractionEnabled = true
            songBtn.setTitleColor(UIColor.lightGray, for: .normal)
            artistBtn.setTitleColor(UIColor.lightGray, for: .normal)
            eventBtn.setTitleColor(UIColor.lightGray, for: .normal)
            venueBtn.setTitleColor(UIColor.white, for: .normal)
            
            
            songLbl.isHidden = true
            artistLbl.isHidden = true
            eventLbl.isHidden = true
            venueLbl.isHidden = false
            
            let controller4 = storyboard?.instantiateViewController(withIdentifier: "VenueFilterViewController") as! VenueFilterViewController
            controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_mail.frame.size.width, height: self.view_mail.frame.size.height)
            controller4.willMove(toParent: self)
            self.view_mail.addSubview(controller4.view)
            self.addChild(controller4)
            controller4.didMove(toParent: self)
        }
    

        // Do any additional setup after loading the view.
    }
    func displayContentController(content: UIViewController) {
        addChild(content)
        self.view_mail.addSubview(content.view)
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
        songBtn.isUserInteractionEnabled = true
        artistBtn.isUserInteractionEnabled = false
        eventBtn.isUserInteractionEnabled = false
        venueBtn.isUserInteractionEnabled = false
        songBtn.setTitleColor(UIColor.white, for: .normal)
        artistBtn.setTitleColor(UIColor.lightGray, for: .normal)
        eventBtn.setTitleColor(UIColor.lightGray, for: .normal)
        venueBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        songLbl.isHidden = false
        artistLbl.isHidden = true
        eventLbl.isHidden = true
        venueLbl.isHidden = true
        
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "SongFilterViewController") as! SongFilterViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_mail.frame.size.width, height: self.view_mail.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_mail.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    
    @IBAction func ArtistBtnAction(_ sender: Any) {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        songBtn.isUserInteractionEnabled = false
        artistBtn.isUserInteractionEnabled = true
        eventBtn.isUserInteractionEnabled = false
        venueBtn.isUserInteractionEnabled = false
        songBtn.setTitleColor(UIColor.lightGray, for: .normal)
        artistBtn.setTitleColor(UIColor.white, for: .normal)
        eventBtn.setTitleColor(UIColor.lightGray, for: .normal)
        venueBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        songLbl.isHidden = true
        artistLbl.isHidden = false
        eventLbl.isHidden = true
        venueLbl.isHidden = true
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "ArtistFilterViewController") as! ArtistFilterViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_mail.frame.size.width, height: self.view_mail.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_mail.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    @IBAction func EventsBtnAction(_ sender: Any) {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        songBtn.isUserInteractionEnabled = false
        artistBtn.isUserInteractionEnabled = false
        eventBtn.isUserInteractionEnabled = true
        venueBtn.isUserInteractionEnabled = false
        songBtn.setTitleColor(UIColor.lightGray, for: .normal)
        artistBtn.setTitleColor(UIColor.lightGray, for: .normal)
        eventBtn.setTitleColor(UIColor.white, for: .normal)
        venueBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        songLbl.isHidden = true
        artistLbl.isHidden = true
        eventLbl.isHidden = false
        venueLbl.isHidden = true
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "EventFilterViewController") as! EventFilterViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_mail.frame.size.width, height: self.view_mail.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_mail.addSubview(controller4.view)
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
        songBtn.isUserInteractionEnabled = false
        artistBtn.isUserInteractionEnabled = false
        eventBtn.isUserInteractionEnabled = false
        venueBtn.isUserInteractionEnabled = true
        songBtn.setTitleColor(UIColor.lightGray, for: .normal)
        artistBtn.setTitleColor(UIColor.lightGray, for: .normal)
        eventBtn.setTitleColor(UIColor.lightGray, for: .normal)
        venueBtn.setTitleColor(UIColor.white, for: .normal)
        
        
        songLbl.isHidden = true
        artistLbl.isHidden = true
        eventLbl.isHidden = true
        venueLbl.isHidden = false
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "VenueFilterViewController") as! VenueFilterViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_mail.frame.size.width, height: self.view_mail.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_mail.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    @IBAction func backBtnAction(_ sender: Any) {
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
