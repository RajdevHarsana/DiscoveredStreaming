//
//  HomeViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 27/06/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class HomeViewController: UIViewController {

    @IBOutlet weak var song_lbl: UILabel!
    @IBOutlet weak var song_Btn: UIButton!
    @IBOutlet weak var artits_Lbl: UILabel!
    @IBOutlet weak var artist_btn: UIButton!
    @IBOutlet weak var event_lbl: UILabel!
    @IBOutlet weak var event_btn: UIButton!
    @IBOutlet weak var venue_lbl: UILabel!
    @IBOutlet weak var venue_btn: UIButton!
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var profileimgaview: UIImageView!
    @IBOutlet weak var namelbl: UILabel!
    var deafults:UserDefaults!
    var user_id:Int!
    var updateImage:String!
    var conroller_string:String!
    var artistSts:Int!
    var isComingFrom = Bool()
    var flag = Bool()
    
    @objc func UserDetailAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                let test =  SwiftToast(
                    text: str_message,
                    textAlignment: .center,
                    backgroundColor: .purple,
                    textColor: .white,
                    font: .boldSystemFont(ofSize: 15.0),
                    duration: 2.0,
                    minimumHeight: CGFloat(80.0),
                    aboveStatusBar: false,
                    target: nil,
                    style: .navigationBar)
                self.present(test, animated: true)
                //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else {
                var response = NSDictionary()
                response = (notification.userInfo?["response"] as? NSDictionary)!
                print("response: \(response)")
               // self.artistSts = (notification.userInfo?["artist_status"] as? Int)
                self.namelbl.text = response.object(forKey: "full_name") as? String
                
                self.updateImage = response.value(forKey: "profile_picture") as? String
                self.removeAllOverlays()
                let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                self.profileimgaview.sd_setImage(with: AddPicture_url as URL?, placeholderImage: UIImage(named: "Group 4-1"), options: []) { (image, error, imageCacheType, imageUrl) in
                }
                var refcode:String!
                refcode = response.value(forKey: "referral_code") as? String
                
                var customerId:String!
                customerId = response.value(forKey: "customer_id") as? String
                
                var accountId:String!
                accountId = response.value(forKey: "account_id") as? String
                 
                var featuredartistplanstatus:Int!
                featuredartistplanstatus = response.value(forKey: "featured_artist_plan_status") as? Int
                var featuredsongplanstatus:Int!
                featuredsongplanstatus = response.value(forKey: "featured_songs_plan_status") as? Int
                var email = String()
                email = response.value(forKey: "email") as? String ?? ""
                var name = String()
                name = response.value(forKey: "full_name") as? String ?? ""
                var range:Int!
                range = response.value(forKey: "default_range") as? Int
                print(range!)
                let defaults = UserDefaults.standard
                defaults.setValue(refcode, forKey: "REFCODE")
                defaults.setValue(range, forKey: "Default_range")
                defaults.setValue(customerId, forKey: "CUSTOMERID")
                defaults.setValue(accountId, forKey: "Account_ID")
                defaults.setValue(featuredartistplanstatus, forKey: "featured_artist_plan_status")
                defaults.setValue(featuredsongplanstatus, forKey: "featured_songs_plan_status")
                defaults.setValue(name, forKey: "full_name")
                defaults.setValue(email, forKey: "email")
//                defaults.setValue(accountId, forKey: "ACCOUNTID")
               // defaults.set(self.artistSts, forKey: "CheckArtist")
                defaults.synchronize()
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        //        if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
        //            status.backgroundColor = UIColor.white
        //        }
        deafults = UserDefaults.standard
        user_id = deafults.integer(forKey: "UserIDGet")
        
        
        profileimgaview.layer.cornerRadius = profileimgaview.frame.width/2
        profileimgaview.layer.masksToBounds = true
        profileimgaview.clipsToBounds = true
        
        if flag == true{
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            song_Btn.setTitleColor(UIColor.lightGray, for: .normal)
             artist_btn.setTitleColor(UIColor.lightGray, for: .normal)
             event_btn.setTitleColor(UIColor.white, for: .normal)
             venue_btn.setTitleColor(UIColor.lightGray, for: .normal)
             conroller_string = "Event"
             let defaults = UserDefaults.standard
             defaults.set(conroller_string, forKey: "SongData")
            // defaults.set(self.artistSts, forKey: "CheckArtist")
             defaults.synchronize()
             
             song_lbl.isHidden = true
             artits_Lbl.isHidden = true
             event_lbl.isHidden = false
             venue_lbl.isHidden = true
             
             let controller4 = storyboard?.instantiateViewController(withIdentifier: "EventsViewController") as! EventsViewController
             controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
             controller4.willMove(toParent: self)
             self.view_main.addSubview(controller4.view)
             self.addChild(controller4)
             controller4.didMove(toParent: self)
        }else if isComingFrom == true{
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            song_Btn.setTitleColor(UIColor.lightGray, for: .normal)
             artist_btn.setTitleColor(UIColor.white, for: .normal)
             event_btn.setTitleColor(UIColor.lightGray, for: .normal)
             venue_btn.setTitleColor(UIColor.lightGray, for: .normal)
             conroller_string = "Artist"
             let defaults = UserDefaults.standard
             defaults.set(conroller_string, forKey: "SongData")
            // defaults.set(self.artistSts, forKey: "CheckArtist")
             defaults.synchronize()
             
             song_lbl.isHidden = true
             artits_Lbl.isHidden = false
             event_lbl.isHidden = true
             venue_lbl.isHidden = true
             
             let controller4 = storyboard?.instantiateViewController(withIdentifier: "ArtistViewController") as! ArtistViewController
             controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
             controller4.willMove(toParent: self)
             self.view_main.addSubview(controller4.view)
             self.addChild(controller4)
             controller4.didMove(toParent: self)
        }else{
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        song_Btn.setTitleColor(UIColor.white, for: .normal)
        artist_btn.setTitleColor(UIColor.lightGray, for: .normal)
        event_btn.setTitleColor(UIColor.lightGray, for: .normal)
        venue_btn.setTitleColor(UIColor.lightGray, for: .normal)
        conroller_string = "Song"
        let defaults = UserDefaults.standard
        defaults.set(conroller_string, forKey: "SongData")
      //  defaults.set(self.artistSts, forKey: "CheckArtist")
        defaults.synchronize()
        
        song_lbl.isHidden = false
        artits_Lbl.isHidden = true
        event_lbl.isHidden = true
        venue_lbl.isHidden = true
    
      
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "SongViewController") as! SongViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        }
        // Do any additional setup after loading the view.
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Reachability.isConnectedToNetwork() {
           // showWaitOverlay()
            Parsing().DiscoverUserDetail(user_Id: user_id)
            NotificationCenter.default.addObserver(self, selector: #selector(self.UserDetailAction), name: NSNotification.Name(rawValue: "DiscoverUserDetail"), object: nil)
        } else {
            let test =  SwiftToast(
                text: "Internet Connection not Available!",
                textAlignment: .center,
                image: UIImage(named: "Icon-App-29x29"),
                backgroundColor: .purple,
                textColor: .white,
                font: .boldSystemFont(ofSize: 15.0),
                duration: 2.0,
                minimumHeight: CGFloat(80.0),
                aboveStatusBar: false,
                target: nil,
                style: .navigationBar)
            self.present(test, animated: true)
        }
    }
    
    
    func displayContentController(content: UIViewController) {
        addChild(content)
        self.view_main.addSubview(content.view)
        content.didMove(toParent: self)
    }
    
    @IBAction func songBtnAction(_ sender: Any) {
//        if self.children.count > 0{
//            let viewControllers:[UIViewController] = self.children
//            for viewContoller in viewControllers{
//                viewContoller.willMove(toParent: nil)
//                viewContoller.view.removeFromSuperview()
//                viewContoller.removeFromParent()
//            }
//        }
        
        song_Btn.setTitleColor(UIColor.white, for: .normal)
        artist_btn.setTitleColor(UIColor.lightGray, for: .normal)
        event_btn.setTitleColor(UIColor.lightGray, for: .normal)
        venue_btn.setTitleColor(UIColor.lightGray, for: .normal)
        conroller_string = "Song"
        let defaults = UserDefaults.standard
        defaults.set(conroller_string, forKey: "SongData")
       // defaults.set(self.artistSts, forKey: "CheckArtist")
        defaults.synchronize()
        
        song_lbl.isHidden = false
        artits_Lbl.isHidden = true
        event_lbl.isHidden = true
        venue_lbl.isHidden = true
       
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "SongViewController") as! SongViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        
      
    }
    @IBAction func artist_btnAction(_ sender: Any) {
//        if self.children.count > 0{
//            let viewControllers:[UIViewController] = self.children
//            for viewContoller in viewControllers{
//                viewContoller.willMove(toParent: nil)
//                viewContoller.view.removeFromSuperview()
//                viewContoller.removeFromParent()
//            }
//        }
        
        song_Btn.setTitleColor(UIColor.lightGray, for: .normal)
        artist_btn.setTitleColor(UIColor.white, for: .normal)
        event_btn.setTitleColor(UIColor.lightGray, for: .normal)
        venue_btn.setTitleColor(UIColor.lightGray, for: .normal)
        conroller_string = "Artist"
        let defaults = UserDefaults.standard
        defaults.set(conroller_string, forKey: "SongData")
       // defaults.set(self.artistSts, forKey: "CheckArtist")
        defaults.synchronize()
        
        song_lbl.isHidden = true
        artits_Lbl.isHidden = false
        event_lbl.isHidden = true
        venue_lbl.isHidden = true
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "ArtistViewController") as! ArtistViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    @IBAction func EventBtnAction(_ sender: Any) {
//        if self.children.count > 0{
//            let viewControllers:[UIViewController] = self.children
//            for viewContoller in viewControllers{
//                viewContoller.willMove(toParent: nil)
//                viewContoller.view.removeFromSuperview()
//                viewContoller.removeFromParent()
//            }
//        }
        
        song_Btn.setTitleColor(UIColor.lightGray, for: .normal)
        artist_btn.setTitleColor(UIColor.lightGray, for: .normal)
        event_btn.setTitleColor(UIColor.white, for: .normal)
        venue_btn.setTitleColor(UIColor.lightGray, for: .normal)
        conroller_string = "Event"
        let defaults = UserDefaults.standard
        defaults.set(conroller_string, forKey: "SongData")
       // defaults.set(self.artistSts, forKey: "CheckArtist")
        defaults.synchronize()
        
        song_lbl.isHidden = true
        artits_Lbl.isHidden = true
        event_lbl.isHidden = false
        venue_lbl.isHidden = true
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "EventsViewController") as! EventsViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    
    @IBAction func venueBtnAction(_ sender: Any) {
//        if self.children.count > 0{
//            let viewControllers:[UIViewController] = self.children
//            for viewContoller in viewControllers{
//                viewContoller.willMove(toParent: nil)
//                viewContoller.view.removeFromSuperview()
//                viewContoller.removeFromParent()
//            }
//        }
        
        song_Btn.setTitleColor(UIColor.lightGray, for: .normal)
        artist_btn.setTitleColor(UIColor.lightGray, for: .normal)
        event_btn.setTitleColor(UIColor.lightGray, for: .normal)
        venue_btn.setTitleColor(UIColor.white, for: .normal)
        conroller_string = "Venue"
        let defaults = UserDefaults.standard
        defaults.set(conroller_string, forKey: "SongData")
      //  defaults.set(self.artistSts, forKey: "CheckArtist")
        defaults.synchronize()
        
        song_lbl.isHidden = true
        artits_Lbl.isHidden = true
        event_lbl.isHidden = true
        venue_lbl.isHidden = false
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "VenuesViewController") as! VenuesViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    @IBAction func notificationBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchBtnAction(_ sender: Any) {
        
       let vc = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
       navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func homeprofileBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeProfileViewController") as! HomeProfileViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

