//
//  ProfileSecondViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class ProfileSecondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
     @IBOutlet weak var profileTableview: UITableView!
    var NameArray = ["My Artist/Band Profile","My Profile","Band invites","My Songs","My Events","My Posts","Loyalty Program/ Badges","Become Featured Artist","Become Featured Song Plan","My Revenue"]
    var NameInfoArray = ["Select or Create Artist/Band Profile","General information,Edit profile and settings","Invites fron other artists","Manage Your Songs","View & Manage Your Events","View & Manage Your Posts","View your levels,points and badges earning","Premium and featured listing option","Premium and featured listing option","view your earning"]
    var imageArray = ["icon_persnal","icon_persnal","icon_Message","icon_playlist","icon_events","icon_community","icon_loyalty","icon_become_member","icon_playlist","icon_wallet_side_menu"]
    var data = false

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var arNameLbl: UILabel!
    @IBOutlet weak var aremailLbl: UILabel!
    var defaults:UserDefaults!
    var name:String!
    var email:String!
    var image:String!
    var imagedata:Data!
    var userId:Int!
    var ArtistId:Int!
    var artistUserId:Int!
    var response1 = NSMutableArray()
    
    var bandImage:String!
    var bandname:String!
    var bandEmail:String!
    var arband:String!
    var arid:Int!
    var bandid:Int!
    var banduserid:Int!
    var artistPlanStatus:Int!
    var songPlanStatus:Int!
    
    @objc func DiscoverGetUserRoleAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
            }
            else{
                var response = NSDictionary()
                response = (notification.userInfo?["artist_detail"] as? NSDictionary)!
                self.arNameLbl.text = response.value(forKey: "artist_name") as? String
                self.profileImageView.sd_setImage(with: URL(string: (response.value(forKey: "artist_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                self.arid = response.value(forKey: "id") as? Int
                let defaults = UserDefaults.standard
                defaults.set(self.arid, forKey: "ARIDN")
                defaults.synchronize()
                self.removeAllOverlays()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        email = defaults.value(forKey: "EMAILNEW") as? String
        arband = defaults.value(forKey: "ARTI") as? String
        artistPlanStatus = defaults.integer(forKey: "featured_artist_plan_status")
        songPlanStatus = defaults.integer(forKey: "featured_songs_plan_status")
      //  name = defaults.value(forKey: "nameofAr") as? String
      //  imagedata = defaults.data(forKey: "ARIMAGEDATA")
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        
     
        aremailLbl.text = email
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("ArProfile"), object: nil)
      
        
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            Parsing().DiscoverProfileArtistBandList()
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverGetUserRoleAction), name: NSNotification.Name(rawValue: "DiscoverProfileArtistBandList"), object: nil)
        }else{
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
    
        // Do any additional setup after loading the view.
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
         defaults = UserDefaults.standard
        arband = defaults.value(forKey: "ARTI") as? String
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            Parsing().DiscoverProfileArtistBandList()
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverGetUserRoleAction), name: NSNotification.Name(rawValue: "DiscoverProfileArtistBandList"), object: nil)
        }else{
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        
       // bandEmail = defaults.value(forKey: "BNDIMG") as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        data ? (count = NameArray.count) : (count = imageArray.count)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileCell1
        cell.nameLbl.text = NameArray[indexPath.row]
        cell.iconImage.image = UIImage(named: imageArray[indexPath.row])
        cell.NameInfoLbl.text = NameInfoArray[indexPath.row]
        if artistPlanStatus == 1 {
            NameArray[7] = "My Artist Current Plan"
            NameInfoArray[7] = "Current active featured listing option"
        }else{
            // No Changes
        }
        if songPlanStatus == 1 {
            NameArray[8] = "Active Featured Songs Plan"
            NameInfoArray[8] = "Current active featured listing option"
        }else{
            // No Changes
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let nextview = ArtistProfileView.intitiateFromNib()
            let model = NewPopModel()
            nextview.buttonCancleHandler = {
                model.closewithAnimation()
            }
            nextview.buttonCloseHandler = {
                self.defaults = UserDefaults.standard
                self.bandImage = self.defaults.value(forKey: "BNDIMG") as? String
                self.bandname = self.defaults.value(forKey: "BNDNAME") as? String
                self.bandid = self.defaults.integer(forKey: "BANDID")
                self.banduserid = self.defaults.integer(forKey: "BNDID")
                self.arband = self.defaults.value(forKey: "ARTI") as? String
                if self.bandImage != nil{
                    let AddPicture_url: NSURL = NSURL(string: self.bandImage)!
                    self.profileImageView.sd_setImage(with: AddPicture_url as URL, placeholderImage: UIImage(named: "Group 4-1"))
                }else {
                    self.profileImageView.image = UIImage(named: "Group 4-1")
                }
                self.arNameLbl.text = self.bandname
                 model.closewithAnimation()
            }
            model.show(view: nextview)
            
        }else if indexPath.row == 1 {
            if self.arband == "Arti" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArtistUpdateProfileViewController") as! ArtistUpdateProfileViewController
                navigationController?.pushViewController(vc, animated: true)
            }else {
                var str = String()
                str = "Edit"
                let defaults = UserDefaults.standard
                defaults.set(str, forKey: "AREDIT")
                defaults.set(self.bandid, forKey: "BANDID")
                defaults.set(self.banduserid, forKey: "BNDID")
                defaults.synchronize()
                let vc  = storyboard?.instantiateViewController(withIdentifier: "ArtistCreateBandViewController") as! ArtistCreateBandViewController
                navigationController?.pushViewController(vc, animated: true)
            }
         
            
        }else if indexPath.row == 2 {
            if self.arband == "Arti" {
                var type:String!
                type = "artist"
                let defaults = UserDefaults.standard
                defaults.set(type, forKey: "postType")
                defaults.set(self.arid, forKey: "ARNewID")
                defaults.synchronize()
            }else {
                var type:String!
                type = "band"
                let defaults = UserDefaults.standard
                defaults.set(type, forKey: "postType")
                defaults.set(self.bandid, forKey: "ARNewID")
                defaults.synchronize()
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArtistMyMessagesViewController") as! ArtistMyMessagesViewController
            navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 3 {
            if self.arband == "Arti" {
                let defaults = UserDefaults.standard
                defaults.set(self.arid, forKey: "ARNewID")
                defaults.synchronize()
            }else {
                let defaults = UserDefaults.standard
                defaults.set(self.bandid, forKey: "ARNewID")
                defaults.synchronize()
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArtistManageSongViewController") as! ArtistManageSongViewController
            navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 4 {
            if self.arband == "Arti" {
                var type:String!
                type = "artist"
                let defaults = UserDefaults.standard
                defaults.set(type, forKey: "postType")
                defaults.set(self.arid, forKey: "ARNewID")
                defaults.synchronize()
            }else {
                var type:String!
                type = "band"
                let defaults = UserDefaults.standard
                defaults.set(type, forKey: "postType")
                defaults.set(self.bandid, forKey: "ARNewID")
                defaults.synchronize()
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArtistManageEventsViewController") as! ArtistManageEventsViewController
            navigationController?.pushViewController(vc, animated: true)
            
            
        }else if indexPath.row == 5 {
            if self.arband == "Arti" {
                var type:String!
                type = "artist"
                let defaults = UserDefaults.standard
                defaults.set(type, forKey: "postType")
                defaults.set(self.arid, forKey: "ARNewID")
                defaults.synchronize()
            }else {
                var type:String!
                type = "band"
                let defaults = UserDefaults.standard
                defaults.set(type, forKey: "postType")
                defaults.set(self.bandid, forKey: "ARNewID")
                defaults.synchronize()
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommunityModuleViewController") as! CommunityModuleViewController
            navigationController?.pushViewController(vc, animated: true)
            
            
        }else if indexPath.row == 6 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoyaltyProgramViewController") as! LoyaltyProgramViewController
            navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 7 {
            if artistPlanStatus != 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedPackageViewController") as! FeaturedPackageViewController
                navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActiveFeaturedArtistViewController") as! ActiveFeaturedArtistViewController
                navigationController?.pushViewController(vc, animated: true)
            }
            
        }else if indexPath.row == 8 {
            if songPlanStatus != 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedSongPackageViewController") as! FeaturedSongPackageViewController
                navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivePlanViewController") as! ActivePlanViewController
                navigationController?.pushViewController(vc, animated: true)
            }
            
        }else if indexPath.row == 9 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyRevenueViewController") as! MyRevenueViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func logoutBtnAction(_ sender: Any) {
       let nextview = Logoutview.intitiateFromNib()
              let model = NewPopModel()
              nextview.buttonDoneHandler = {
                let deafults = UserDefaults.standard
                deafults.set(nil, forKey: "Logoutstatus")
                deafults.synchronize()
                  let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                  self.navigationController?.pushViewController(vc, animated: true)
                  model.closewithAnimation()
              }
              nextview.buttonCancleHandler = {
                  model.closewithAnimation()
              }
              model.show(view: nextview)
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
