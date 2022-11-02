//
//  VenuesViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation

class VenuesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {

    @IBOutlet weak var VenueTableview: UITableView!
    var userID:Int!
    var defaults:UserDefaults!
    var response = NSMutableArray()
    var Manager: CLLocationManager!
    var str_lat:String!
    var str_long:String!
    var isCall = Bool()
    var venueId:Int!
    var venueName:String!
    var arryFav = NSMutableArray()
    var Data1 = Int()
    var followSts:Int!
    var slooooooooooot = Int()
    var APICall = Bool()
    var venueRefreshControl: UIRefreshControl!
    
    //MARK:- Login WebService
    @objc func DiscoverVenueListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.VenueTableview.isHidden = true
                 self.APICall = false
                self.VenueTableview.reloadData()
            }
            else{
                var arr_data = NSMutableArray()
                arr_data = (notification.userInfo?["data"] as? NSMutableArray)!
                self.APICall = true
                if arr_data.count != 0 {
                    self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                    self.slooooooooooot = self.slooooooooooot + 10
                    arr_data.removeAllObjects()
                }
                self.followSts = self.response.value(forKey: "follow_status") as? Int
                
                for i in 0..<self.response.count {
                    
                    var dict = NSDictionary()
                    dict = self.response.object(at: i) as! NSDictionary
                    
                    let s_id = dict.object(forKey: "id") ?? NSString()
                    var isFav = Int()
                    isFav = dict.object(forKey: "follow_status") as! Int
                    //self.arryFav = []
                    if isFav == 1
                    {
                        self.arryFav.add(s_id)
                    }
                    
                }
                print("response: \(String(describing: self.response))")
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverVenueListing"), object: nil)
                self.VenueTableview.reloadData()
                self.removeAllOverlays()
                self.VenueTableview.isHidden = false
                
                
            }
        }
    }
    
    
    //MARK:- follow
    @objc func FollowVenueAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                let test =  SwiftToast(
                    text: str_message,
                    textAlignment: .center,
                    image: UIImage(named: "ic_alert"),
                    backgroundColor: .purple,
                    textColor: .white,
                    font: .boldSystemFont(ofSize: 15.0),
                    duration: 2.0,
                    minimumHeight: CGFloat(100.0),
                    statusBarStyle: .lightContent,
                    aboveStatusBar: true,
                    target: nil,
                    style: .navigationBar)
                self.present(test, animated: true)
                self.Data1 = (notification.userInfo?["data"] as? Int)!
                //self.artistTableview.reloadData()
                Parsing().DiscoverVenueListing(UserId: self.userID, ListType: "home", Lat: self.str_lat as String?, Long: self.str_long as String?, Offset: self.slooooooooooot)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverVenueListing"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverVenueListAction), name: NSNotification.Name(rawValue: "DiscoverVenueListing"), object: nil)
                self.removeAllOverlays()
                
            }
            else{
                let test =  SwiftToast(
                    text: str_message,
                    textAlignment: .center,
                    image: UIImage(named: "ic_alert"),
                    backgroundColor: .purple,
                    textColor: .white,
                    font: .boldSystemFont(ofSize: 15.0),
                    duration: 2.0,
                    minimumHeight: CGFloat(100.0),
                    statusBarStyle: .lightContent,
                    aboveStatusBar: true,
                    target: nil,
                    style: .navigationBar)
                self.present(test, animated: true)
                self.Data1 = (notification.userInfo?["data"] as? Int)!
                // self.artistTableview.reloadData()
                Parsing().DiscoverVenueListing(UserId: self.userID, ListType: "home", Lat: self.str_lat as String?, Long: self.str_long as String?, Offset: self.slooooooooooot)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverVenueListing"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverVenueListAction), name: NSNotification.Name(rawValue: "DiscoverVenueListing"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
        if #available(iOS 10.0, *) {
            self.venueRefreshControl = UIRefreshControl()
            self.venueRefreshControl.tintColor = UIColor.systemPink
//            self.venueRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.venueRefreshControl.addTarget(self,action: #selector(self.refreshVenueList),for: .valueChanged)
            self.VenueTableview.addSubview(self.venueRefreshControl)
        }
        }
        defaults = UserDefaults.standard
        userID = defaults.integer(forKey: "UserIDGet")
        str_lat = defaults.value(forKey: "LAT") as? String
        str_long = defaults.value(forKey: "LONG") as? String
        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
        VenueListApi()
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshVenueList(sender: UIRefreshControl) {
       // Code to refresh table view
        self.VenueTableview.reloadData()
        self.venueRefreshControl.endRefreshing()
        self.VenueListApi()
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
//        slooooooooooot = 0
//        APICall = true
//        response.removeAllObjects()
//        if Reachability.isConnectedToNetwork() == true {
//            showWaitOverlay()
//            Parsing().DiscoverVenueListing(UserId: userID, ListType: "home", Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
//            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverVenueListAction), name: NSNotification.Name(rawValue: "DiscoverVenueListing"), object: nil)
//        }else {
//            let test =  SwiftToast(
//                text: "Internet Connection not Available!",
//                textAlignment: .center,
//                image: UIImage(named: "Icon-App-29x29"),
//                backgroundColor: .purple,
//                textColor: .white,
//                font: .boldSystemFont(ofSize: 15.0),
//                duration: 2.0,
//                minimumHeight: CGFloat(80.0),
//                aboveStatusBar: false,
//                target: nil,
//                style: .navigationBar)
//            self.present(test, animated: true)
//            self.response.removeAllObjects()
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
                
        // NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("CreateVenue"), object: nil)
        
    }
    
    func VenueListApi(){
                
            if !isCall
            {
            if Reachability.isConnectedToNetwork() == true{
                showWaitOverlay()
                let parameterDictionary = NSMutableDictionary()
                parameterDictionary.setObject(DataManager.getVal(self.userID), forKey: "user_id" as NSCopying)
                parameterDictionary.setValue(DataManager.getVal("home"), forKey: "list_type")
                parameterDictionary.setValue(DataManager.getVal(str_lat), forKey: "lat")
                parameterDictionary.setValue(DataManager.getVal(str_long), forKey: "lng")
                parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
                print(parameterDictionary)
                
                let methodName = "venue_list"
                
                DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                DispatchQueue.main.async(execute: {
                    let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                    let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
    //                let songCount = DataManager.getVal(responseData?.object(forKey: "song_count"))  as? Int ?? 0
    //                self.totalSongs = songCount
                    if status == "0" {
//                        let test =  SwiftToast(
//                            text: message,
//                            textAlignment: .center,
//                            image: UIImage(named: "ic_alert"),
//                            backgroundColor: .purple,
//                            textColor: .white,
//                            font: .boldSystemFont(ofSize: 15.0),
//                            duration: 2.0,
//                            minimumHeight: CGFloat(100.0),
//                            statusBarStyle: .lightContent,
//                            aboveStatusBar: true,
//                            target: nil,
//                            style: .navigationBar)
//                        self.present(test, animated: true)
                        self.APICall = false
                        self.removeAllOverlays()
                        
                    }else{
                    var arr_data = NSMutableArray()
                      arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                      self.APICall = true
                      if arr_data.count != 0 {
                      self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                      self.slooooooooooot = self.slooooooooooot + 10
                      arr_data.removeAllObjects()
                    }
                      self.VenueTableview.reloadData()
                      self.removeAllOverlays()
                  }
                    //self.clearAllNotice()
                    self.removeAllOverlays()
                })
                }
                
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
                response.removeAllObjects()
                self.present(test, animated: true)
                
              }
           }
        }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if response.count>0
        {
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
            self.VenueTableview.addSubview(venueRefreshControl)
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Venue Found"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VenueCell
        
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.venueImage.layer.cornerRadius = 5
        cell.venueImage.sd_setImage(with: URL(string: (dict.value(forKey: "venue_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        cell.venueNameLbl.text = dict.value(forKey: "venue_name") as? String
        var sponsoredStatus:Int!
        sponsoredStatus = dict.value(forKey: "sponsored") as? Int
        if sponsoredStatus == 1 {
            cell.venueSponsered_btn.isHidden = false
        }else{
            cell.venueSponsered_btn.isHidden = true
        }
        
        
        var str_address = String()
        str_address = (dict.value(forKey: "address") as? String)!
        
        var str_city = String()
        str_city = (dict.value(forKey: "city") as? String)!
        
        var str_state = String()
        str_state = (dict.value(forKey: "state") as? String)!
        
        var zip:String!
        zip = dict.value(forKey: "zipcode") as? String ?? ""
        
        var rating1:Int!
        rating1 = dict.value(forKey: "rating") as? Int
    
        var rate = Float()
        rate = Float(rating1)
        cell.venueRation.rating = Float(truncating: NSNumber(value: rate))

        var ratingper:Int!
        ratingper = dict.value(forKey: "rating_percentage") as? Int
        cell.ratingPerLbl.text = String(ratingper) + "%"
        
        
        var str_country = String()
        str_country = (dict.value(forKey: "country") as? String)!
        
       
        cell.venueAddress.text = str_address + " " + str_city + " " + str_state + " " + str_country + " " + zip
        
        var artistuserid:Int!
        artistuserid = dict.value(forKey: "user_id") as? Int
        if artistuserid == userID {
            cell.followBtn.isHidden = true
        }else {
            cell.followBtn.isHidden = false
            
        }
        
        cell.followBtn.tag = indexPath.row
        cell.followBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        
        var followSt:Int!
        followSt = dict.value(forKey: "follow_status") as? Int
        
        if followSt == 1 {
            cell.followBtn.setImage(UIImage(named: "Un_Follow_button"), for: .normal)
        }else {
            cell.followBtn.setImage(UIImage(named: "Follow"), for: .normal)
        }
        return cell
    }
    
    @objc func handleTap(_ sender:UIButton) {
        
        let dict = DataManager.getVal(self.response[sender.tag]) as! NSDictionary
        let id = DataManager.getVal(dict["id"]) as? String ?? ""
        
        let index = IndexPath(row: sender.tag, section: 0)
        let cell = self.VenueTableview.cellForRow(at: index) as? VenueCell
        
        sender.isSelected = !sender.isSelected
        if cell?.followBtn.currentImage == UIImage(named: "Follow"){
            
            //self.pleaseWait()//loader
            
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setObject(DataManager.getVal(self.userID), forKey: "user_id" as NSCopying)
            parameterDictionary.setValue(DataManager.getVal(id), forKey: "follower_id")
            parameterDictionary.setValue(DataManager.getVal("venue"), forKey: "follow_type")
            print(parameterDictionary)
            
            let methodName = "followUnfollow"//change name
            
            DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                
                DispatchQueue.main.async(execute: {
                    
                    let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                    let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                    
                    if status == "1" {
                        cell?.followBtn.setImage(UIImage(named: "Un_Follow_button"), for: .normal)
//                        let test =  SwiftToast(
//                            text: message,
//                            textAlignment: .center,
//                            image: UIImage(named: "ic_alert"),
//                            backgroundColor: .purple,
//                            textColor: .white,
//                            font: .boldSystemFont(ofSize: 15.0),
//                            duration: 2.0,
//                            minimumHeight: CGFloat(100.0),
//                            statusBarStyle: .lightContent,
//                            aboveStatusBar: true,
//                            target: nil,
//                            style: .navigationBar)
//                        self.present(test, animated: true)
                    }else{
                        //Config().error(message: message)//error message
                    }
                    self.removeAllOverlays()
                })
            }
        }else{
            
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setObject(DataManager.getVal(self.userID), forKey: "user_id" as NSCopying)
            parameterDictionary.setValue(DataManager.getVal(id), forKey: "follower_id")
            parameterDictionary.setValue(DataManager.getVal("venue"), forKey: "follow_type")
            print(parameterDictionary)
            
            let methodName = "followUnfollow"
            
            DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                
                DispatchQueue.main.async(execute: {
                    
                    let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                    let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                    
                    if status == "0" {
                        cell?.followBtn.setImage(UIImage(named: "Follow"), for: .normal)
//                        let test =  SwiftToast(
//                            text: message,
//                            textAlignment: .center,
//                            image: UIImage(named: "ic_alert"),
//                            backgroundColor: .purple,
//                            textColor: .white,
//                            font: .boldSystemFont(ofSize: 15.0),
//                            duration: 2.0,
//                            minimumHeight: CGFloat(100.0),
//                            statusBarStyle: .lightContent,
//                            aboveStatusBar: true,
//                            target: nil,
//                            style: .navigationBar)
//                        self.present(test, animated: true)
                    }else{
                        //Config().error(message: message)
                    }
                    self.removeAllOverlays()
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        venueId = dict.value(forKey: "id") as? Int ?? 0
        venueName = dict.value(forKey: "venue_name") as? String
        let defaults = UserDefaults.standard
        defaults.set(venueId, forKey: "VenueID")
        defaults.set(venueName, forKey: "VenueNam")
        defaults.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VenueDetailViewController") as! VenueDetailViewController
        let flag = true
        vc.flag = flag
        vc.nameVenue = venueName
        vc.notiId = venueId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
            VenueListApi()
        }
    }
    
    @IBAction func createVenueBtnAction(_ sender: Any) {
        var str:String!
        str = "Add"
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "VnAdd")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateAnVenueViewController") as! CreateAnVenueViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
