//
//  ProfileViewThirdViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import CoreLocation
import SDWebImage


class ProfileViewThirdViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
   
    @IBOutlet weak var profileTableview: UITableView!
    var NameArray = ["My Venues","Venue Profile","My Events","My Posts","Ticket Manager","My Packages","My Revenue"]
    var NameInfoArray = ["View & Manage Your Venues","General information,Edit profile and settings","View & Manage Your Events","View & Manage Your Post","Manage Your Tickets","View & Manage Your Packages","View Your Revenue"]
    var imageArray = ["icon_publish_event","icon_persnal","icon_events","icon_posts","small-tickets-couple","icon_package","icon_loyalty"]
    var data = false
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var venueEmailLbl: UILabel!
    var defaults:UserDefaults!
    var name:String!
    var email:String!
    var venueImage:String!
    var venueName:String!
    var venueid:Int!
    var arvenid:Int!
    var vent:String!
    var Manager: CLLocationManager!
    var str_lat:String!
    var str_long:String!
    var isCall = Bool()
    var userid:Int!
    var res = NSMutableArray()
    var selectedVenueID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        email = defaults.value(forKey: "EMAILNEW") as? String
        vent = defaults.value(forKey: "VENe") as? String
        //arvenid = defaults.integer(forKey: "ARVenID")
        userid = defaults.integer(forKey: "UserIDGet")
        venueEmailLbl.text = email
        str_lat = defaults.value(forKey: "LAT") as? String
        str_long = defaults.value(forKey: "LONG") as? String
        
        venueImageView.layer.cornerRadius = venueImageView.frame.width/2
        venueImageView.layer.masksToBounds = true
        venueImageView.clipsToBounds = true
        self.myVenueListApi()
        // Do any additional setup after loading the view.
    }

    func myVenueListApi(){
        if !isCall{
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setObject(DataManager.getVal(self.userid), forKey: "user_id" as NSCopying)
            parameterDictionary.setValue(DataManager.getVal("my_venue"), forKey: "list_type")
            parameterDictionary.setValue(DataManager.getVal(str_lat), forKey: "lat")
            parameterDictionary.setValue(DataManager.getVal(str_long), forKey: "lng")
            parameterDictionary.setValue(DataManager.getVal(0), forKey: "offset")
            print(parameterDictionary)
            let methodName = "venue_list"
            DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                if status == "0" {
                }else{
                    self.res = (responseData?.object(forKey: "data") as? NSMutableArray)!
                    print("response: \(String(describing: self.res))")
                    var dict = NSDictionary()
                    dict = self.res.object(at: 0) as! NSDictionary
                    self.venueImageView.sd_setImage(with: URL(string: (dict.value(forKey: "venue_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                    self.venueNameLbl.text = dict.value(forKey: "venue_name") as? String
                    self.arvenid = dict.value(forKey: "id") as? Int
                    print(dict)
              }
                self.removeAllOverlays()
            })
            }
        }else{
        }
       }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        data ? (count = NameArray.count) : (count = imageArray.count)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileCell2
        cell.nameLbl.text = NameArray[indexPath.row]
        cell.iconImage.image = UIImage(named: imageArray[indexPath.row])
        cell.NameInfoLbl.text = NameInfoArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let nextview = VenueProfileViewpop.intitiateFromNib()
            let model = NewPopModel()
            nextview.buttonCancleHandler = {
                model.closewithAnimation()
            }
            nextview.buttonCloseHandler = {
                self.defaults = UserDefaults.standard
                self.venueImage = self.defaults.value(forKey: "VENIMG") as? String
                self.venueName = self.defaults.value(forKey: "VENNAME") as? String
                self.venueid = self.defaults.integer(forKey: "VENID")
                self.vent = self.defaults.value(forKey: "VENe") as? String
                if self.venueImage != nil{
                    let AddPicture_url: NSURL = NSURL(string: self.venueImage)!
                    self.venueImageView.sd_setImage(with: AddPicture_url as URL, placeholderImage: UIImage(named: "Group 4-1"))
                }else {
                    self.venueImageView.image = UIImage(named: "Group 4-1")
                }
                self.venueNameLbl.text = self.venueName
                model.closewithAnimation()
            }
            model.show(view: nextview)
            
        }else if indexPath.row == 1 {
            var str:String!
            str = "Edit"
            let defaults = UserDefaults.standard
            defaults.set(str, forKey: "VnAdd")
            defaults.synchronize()
            if self.vent == "Ven" {
                var type:String!
                type = "venue"
                let defaults = UserDefaults.standard
                defaults.set(self.arvenid, forKey: "ARVenID")
                defaults.set(type, forKey: "postType")
                defaults.synchronize()
            }else {
                var type:String!
                type = "venue"
                let defaults = UserDefaults.standard
                defaults.set(self.venueid, forKey: "ARVenID")
                defaults.set(type, forKey: "postType")
                defaults.synchronize()
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateAnVenueViewController") as! CreateAnVenueViewController
            navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 2 {
            if self.vent == "Ven" {
                var type:String!
                type = "venue"
                let defaults = UserDefaults.standard
                defaults.set(self.arvenid, forKey: "ARVenID")
                defaults.set(type, forKey: "postType")
                defaults.synchronize()
            }else {
                var type:String!
                type = "venue"
                let defaults = UserDefaults.standard
                defaults.set(self.venueid, forKey: "ARVenID")
                defaults.set(type, forKey: "postType")
                defaults.synchronize()
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VenueManageEventsViewController") as! VenueManageEventsViewController
            navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 3 {
            if self.vent == "Ven" {
                var type:String!
                type = "venue"
                let defaults = UserDefaults.standard
                defaults.set(self.arvenid, forKey: "ARVenID")
                defaults.set(type, forKey: "postType")
                defaults.synchronize()
            }else {
                var type:String!
                type = "venue"
                let defaults = UserDefaults.standard
                defaults.set(self.venueid, forKey: "ARVenID")
                defaults.set(type, forKey: "postType")
                defaults.synchronize()
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommunityModuleViewController") as! CommunityModuleViewController
            navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 4 {
            
            let defaults = UserDefaults.standard
            defaults.set(self.arvenid, forKey: "ARVenID")
            defaults.synchronize()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VenueTicketManagerViewController") as! VenueTicketManagerViewController
            navigationController?.pushViewController(vc, animated: true)
        
        }else if indexPath.row == 5 {
            if self.vent == "Ven" {
                var type:String!
                type = "venue"
                let defaults = UserDefaults.standard
                defaults.set(self.arvenid, forKey: "ARVenID")
                defaults.set(type, forKey: "postType")
                defaults.synchronize()
            }else {
                var type:String!
                type = "venue"
                let defaults = UserDefaults.standard
                defaults.set(self.venueid, forKey: "ARVenID")
                defaults.set(type, forKey: "postType")
                defaults.synchronize()
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MySubscriotionViewController") as! MySubscriotionViewController
            navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 6 {
            if self.vent == "Ven" {
                var type:String!
                type = "venue"
                let defaults = UserDefaults.standard
                defaults.set(self.arvenid, forKey: "ARVenID")
                defaults.set(type, forKey: "postType")
                defaults.synchronize()
            }else {
                var type:String!
                type = "venue"
                let defaults = UserDefaults.standard
                defaults.set(self.venueid, forKey: "ARVenID")
                defaults.set(type, forKey: "postType")
                defaults.synchronize()
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VenueRevenueViewController") as! VenueRevenueViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
