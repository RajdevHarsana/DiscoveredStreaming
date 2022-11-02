//
//  ProfileViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var profileTableview: UITableView!
    var NameArray = ["Personal Information","Messages","My Artist/Band Profile","My Venue Profile","My Playlist","My Tickets","My Subscription Plan","Loyalty Program","My Followings"]
    var NameInfoArray = [String]()
    var imageArray = ["icon_persnal","icon_Message","icon_persnal","icon_publish_event","icon_playlist","icon_tickets","icon_rewards","icon_loyalty","icon_follwings"]
     var data = false
    
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var profileBottomCons: NSLayoutConstraint!
    
    var defaults:UserDefaults!
    var user_id:Int!
    var updateImage:String!
    var showvenue:String!
    var showartist:String!
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
                 self.profileTableview.reloadData()
                //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else {
                var response = NSDictionary()
                response = (notification.userInfo?["response"] as? NSDictionary)!
                print("response: \(response)")
                self.nameLbl.text = response.object(forKey: "full_name") as? String
                self.emailLbl.text = response.object(forKey: "email") as? String
                self.updateImage = response.value(forKey: "profile_picture") as? String
                let defaults = UserDefaults.standard
                defaults.set(self.emailLbl.text, forKey: "EMAILNEW")
                defaults.synchronize()
                self.removeAllOverlays()
                let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                self.profileTableview.reloadData()
                self.profileImageview.sd_setImage(with: AddPicture_url as URL?, placeholderImage: UIImage(named: "Group 4-1"), options: []) { (image, error, imageCacheType, imageUrl) in
                }
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if (view.window != nil) {
            // do stuff
            self.profileBottomCons.constant = -10
        }else{
            self.profileBottomCons.constant = -60
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        defaults = UserDefaults.standard
        user_id = defaults.integer(forKey: "UserIDGet")
        showvenue = defaults.value(forKey: "SHOEVEN") as? String
        showartist = defaults.value(forKey: "SHOWAR") as? String
        profileImageview.layer.cornerRadius = profileImageview.frame.width/2
        profileImageview.layer.masksToBounds = true
        profileImageview.clipsToBounds = true
        
        if showvenue == "showvenue" && showartist == "showartist" {
            NameArray = ["Personal Information","My Artist/Band Profile","My Venue Profile","My Playlist","My Tickets","My Subscription Plan","Loyalty Program","My Followings"]
            NameInfoArray = ["General information,Edit profile and settings","General information,Edit profile and settings","General information,Edit profile and settings","Song playlist that you loved","Tickets for Events you Purchased","Information about your current active plan","View Your Level, Points, & Badges","View Artist/Bands & Venues You Follow"]
            imageArray = ["icon_persnal","icon_persnal","icon_publish_event","icon_playlist","icon_tickets","icon_rewards","icon_loyalty","icon_follwings"]
        }else if showvenue == nil && showartist == "showartist"{
            NameArray = ["Personal Information","My Artist/Band Profile","My Playlist","My Tickets","My Subscription Plan","Loyalty Program","My Followings"]
            NameInfoArray = ["General information,Edit profile and settings","General information,Edit profile and settings","Song playlist that you loved","Tickets for Events you Purchased","Information about your current active plan","View Your Level, Points, & Badges","View Artist/Bands & Venues You Follow"]
            imageArray = ["icon_persnal","icon_persnal","icon_playlist","icon_tickets","icon_rewards","icon_loyalty","icon_follwings"]
        }else if showvenue == "showvenue" && showartist == nil {
            NameArray = ["Personal Information","My Venue Profile","My Playlist","My Tickets","My Subscription Plan","Loyalty Program","My Followings"]
            NameInfoArray = ["General information,Edit profile and settings","General information,Edit profile and settings","Song playlist that you loved","Tickets for Events you Purchased","Information about your current active plan","View Your Level, Points, & Badges","View Artist/Bands & Venues You Follow"]
            imageArray = ["icon_persnal","icon_publish_event","icon_playlist","icon_tickets","icon_rewards","icon_loyalty","icon_follwings"]
        }else {
            NameArray = ["Personal Information","My Playlist","My Tickets","My Subscription Plan","Loyalty Program","My Followings"]
            NameInfoArray = ["General information,Edit profile and settings","Song playlist that you loved","Tickets for Events you Purchased","Information about your current active plan","View Your Level, Points, & Badges","View Artist/Bands & Venues You Follow"]
            imageArray = ["icon_persnal","icon_playlist","icon_tickets","icon_rewards","icon_loyalty","icon_follwings"]
        }
        
        if Reachability.isConnectedToNetwork(){
            showWaitOverlay()
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
            // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Internet Connection not Available!" , buttonTitle: "OK")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        data ? (count = NameArray.count) : (count = imageArray.count)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileCell
        cell.nameLbl.text = NameArray[indexPath.row]
        cell.iconImage.image = UIImage(named: imageArray[indexPath.row])
        cell.NameInfoLbl.text = NameInfoArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showvenue == "showvenue" && showartist == "showartist" {
        if indexPath.row == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "PersonalInformationViewController") as! PersonalInformationViewController
            navigationController?.pushViewController(vc, animated: true)
            
//        }else if indexPath.row == 1 {
//            let vc = storyboard?.instantiateViewController(withIdentifier: "MyMessagesViewController") as! MyMessagesViewController
//            navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 1 {
            var str = String()
            str = "Arti"
            let deafault = UserDefaults.standard
            deafault.set(str, forKey: "ARTI")
            deafault.synchronize()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileSecondViewController") as! ProfileSecondViewController
            navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 2 {
            var str = String()
            str = "Ven"
            let deafault = UserDefaults.standard
            deafault.set(str, forKey: "VENe")
            deafault.synchronize()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewThirdViewController") as! ProfileViewThirdViewController
            navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 3 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "AllPlayListViewController") as! AllPlayListViewController
            navigationController?.pushViewController(vc, animated: true)
            
            
        }else if indexPath.row == 4 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "MyTicketsViewController") as! MyTicketsViewController
            navigationController?.pushViewController(vc, animated: true)
            
            
        }else if indexPath.row == 5 {
            
        }else if indexPath.row == 6 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoyaltyProgramViewController") as! LoyaltyProgramViewController
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "MyFollowingNewViewController") as! MyFollowingNewViewController
            navigationController?.pushViewController(vc, animated: true)
        }
        }else if showvenue == nil && showartist == "showartist" {
            if indexPath.row == 0 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "PersonalInformationViewController") as! PersonalInformationViewController
                navigationController?.pushViewController(vc, animated: true)
                
//            }else if indexPath.row == 1 {
//                let vc = storyboard?.instantiateViewController(withIdentifier: "MyMessagesViewController") as! MyMessagesViewController
//                navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 1 {
                var str = String()
                str = "Arti"
                let deafault = UserDefaults.standard
                deafault.set(str, forKey: "ARTI")
                deafault.synchronize()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileSecondViewController") as! ProfileSecondViewController
                navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 2 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "AllPlayListViewController") as! AllPlayListViewController
                navigationController?.pushViewController(vc, animated: true)
                
                
            }else if indexPath.row == 3 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "MyTicketsViewController") as! MyTicketsViewController
                navigationController?.pushViewController(vc, animated: true)
                
                
            }else if indexPath.row == 4 {
                
            }else if indexPath.row == 5 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "LoyaltyProgramViewController") as! LoyaltyProgramViewController
                navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "MyFollowingNewViewController") as! MyFollowingNewViewController
                navigationController?.pushViewController(vc, animated: true)
            }
        }else if showvenue == "showvenue" && showartist == nil {
            if indexPath.row == 0 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "PersonalInformationViewController") as! PersonalInformationViewController
                navigationController?.pushViewController(vc, animated: true)
                
//            }else if indexPath.row == 1 {
//                let vc = storyboard?.instantiateViewController(withIdentifier: "MyMessagesViewController") as! MyMessagesViewController
//                navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 1 {
                var str = String()
                str = "Ven"
                let deafault = UserDefaults.standard
                deafault.set(str, forKey: "VENe")
                deafault.synchronize()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewThirdViewController") as! ProfileViewThirdViewController
                navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 2 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "AllPlayListViewController") as! AllPlayListViewController
                navigationController?.pushViewController(vc, animated: true)
                
                
            }else if indexPath.row == 3 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "MyTicketsViewController") as! MyTicketsViewController
                navigationController?.pushViewController(vc, animated: true)
                
                
            }else if indexPath.row == 4 {
                
            }else if indexPath.row == 5 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "LoyaltyProgramViewController") as! LoyaltyProgramViewController
                navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "MyFollowingNewViewController") as! MyFollowingNewViewController
                navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            if indexPath.row == 0 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "PersonalInformationViewController") as! PersonalInformationViewController
                navigationController?.pushViewController(vc, animated: true)
                
//            }else if indexPath.row == 1 {
//                let vc = storyboard?.instantiateViewController(withIdentifier: "MyMessagesViewController") as! MyMessagesViewController
//                navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 1 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "AllPlayListViewController") as! AllPlayListViewController
                navigationController?.pushViewController(vc, animated: true)
                
                
            }else if indexPath.row == 2 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "MyTicketsViewController") as! MyTicketsViewController
                navigationController?.pushViewController(vc, animated: true)
                
                
            }else if indexPath.row == 3 {
                
            }else if indexPath.row == 4 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "LoyaltyProgramViewController") as! LoyaltyProgramViewController
                navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "MyFollowingNewViewController") as! MyFollowingNewViewController
                navigationController?.pushViewController(vc, animated: true)
            }
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
    
}
