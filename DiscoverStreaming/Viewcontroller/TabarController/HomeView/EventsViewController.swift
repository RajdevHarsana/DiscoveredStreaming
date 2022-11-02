//
//  EventsViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation
class EventsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {

    @IBOutlet weak var eventsTableview: UITableView!
    var response = NSMutableArray()
    var defaults:UserDefaults!
    var user_Id:Int!
     var Manager: CLLocationManager!
    var str_lat:String!
    var str_long:String!
    var isCall = Bool()
   
    @IBOutlet weak var createEventBTn: UIButton!
    @IBOutlet weak var createVentBtnHeightCons: NSLayoutConstraint!
    @IBOutlet weak var cretreEventImage: UIImageView!
    var venue_sts:Int!
    var eventid:Int!
    var evntuserid:Int!
    var slooooooooooot = Int()
    var APICall = Bool()
    var eventRefreshControl: UIRefreshControl!
    
    //MARK:- Login WebService
    @objc func DiscoverEventListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        venue_sts = (notification.userInfo?["venue_status"] as? Int)!
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.APICall = false
                if self.venue_sts == 1 {
                    self.createVentBtnHeightCons.constant = 69
                    self.cretreEventImage.isHidden = false
                }else {
                    self.createVentBtnHeightCons.constant = 0
                    self.cretreEventImage.isHidden = true
                }
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverEventListing"), object: nil)
                self.eventsTableview.reloadData()
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
                self.venue_sts =  (notification.userInfo?["venue_status"] as? Int)!
                if self.venue_sts == 1 {
                    var strsts:String!
                    strsts = "showvenue"
                    let defaults = UserDefaults.standard
                    defaults.set(strsts, forKey: "SHOEVEN")
                    defaults.synchronize()
                    self.createVentBtnHeightCons.constant = 69
                    self.cretreEventImage.isHidden = false
                }else {
                    var strsts:String!
                    strsts = nil
                    let defaults = UserDefaults.standard
                    defaults.set(strsts, forKey: "SHOEVEN")
                    defaults.synchronize()
                     self.createVentBtnHeightCons.constant = 0
                     self.cretreEventImage.isHidden = true
                }
                print("response: \(String(describing: self.response))")
                self.eventsTableview.reloadData()
                self.removeAllOverlays()
                self.eventsTableview.isHidden = false
                  NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverEventListing"), object: nil)
               
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
        if #available(iOS 10.0, *) {
            self.eventRefreshControl = UIRefreshControl()
            self.eventRefreshControl.tintColor = UIColor.systemPink
//            self.eventRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.eventRefreshControl.addTarget(self,action: #selector(self.refreshEventList),for: .valueChanged)
            self.eventsTableview.addSubview(self.eventRefreshControl)
        }
        }
        
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        str_lat = defaults.value(forKey: "LAT") as? String
        str_long = defaults.value(forKey: "LONG") as? String
        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
        eventListApi()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("CreateEvent"), object: nil)
//        response = NSMutableArray()
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshEventList(sender: UIRefreshControl) {
       // Code to refresh table view
        self.eventsTableview.reloadData()
        self.eventRefreshControl.endRefreshing()
        self.eventListApi()
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
        if Reachability.isConnectedToNetwork() == true {
           showWaitOverlay()
            Parsing().DiscoverEventListing(UserId: user_Id, EventStatus: "home", ArtistId: 0, Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
              NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverEventListing"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverEventListAction), name: NSNotification.Name(rawValue: "DiscoverEventListing"), object: nil)
        }else {
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
            self.response.removeAllObjects()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         
    }
    
    func eventListApi(){
                
            if !isCall
            {
            if Reachability.isConnectedToNetwork() == true{
                showWaitOverlay()
                let parameterDictionary = NSMutableDictionary()
                parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
                parameterDictionary.setValue(DataManager.getVal("home"), forKey: "related_type")
    //            parameterDictionary.setValue(DataManager.getVal(""), forKey: "as_type_id")
                parameterDictionary.setValue(DataManager.getVal(""), forKey: "related_type_id")
                parameterDictionary.setValue(DataManager.getVal(str_lat), forKey: "lat")
                parameterDictionary.setValue(DataManager.getVal(str_long), forKey: "lng")
                parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
    //            parameterDictionary.setValue(DataManager.getVal(list_type_id), forKey: "list_type_id")
                print(parameterDictionary)
                
                let methodName = "event_list"
                
                DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                DispatchQueue.main.async(execute: {
                    let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                    let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                    let venue_status = DataManager.getVal(responseData?.object(forKey: "venue_status"))  as? String ?? ""
                    self.venue_sts = Int(venue_status)
                    if status == "0" {
                        self.removeAllOverlays()
                        self.APICall = false
                        if self.venue_sts == 1 {
                            self.createVentBtnHeightCons.constant = 69
                            self.cretreEventImage.isHidden = false
                        }else {
                            self.createVentBtnHeightCons.constant = 0
                            self.cretreEventImage.isHidden = true
                        }
                        self.eventsTableview.reloadData()
                    }else{
                    var arr_data = NSMutableArray()
                      arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                      self.APICall = true
                      if arr_data.count != 0 {
                      self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                      self.slooooooooooot = self.slooooooooooot + 10
                      arr_data.removeAllObjects()
                    }
                    if self.venue_sts == 1 {
                        var strsts:String!
                        strsts = "showvenue"
                        let defaults = UserDefaults.standard
                        defaults.set(strsts, forKey: "SHOEVEN")
                        defaults.synchronize()
                        self.createVentBtnHeightCons.constant = 69
                        self.cretreEventImage.isHidden = false
                    }else {
                        var strsts:String!
                        strsts = nil
                        let defaults = UserDefaults.standard
                        defaults.set(strsts, forKey: "SHOEVEN")
                        defaults.synchronize()
                         self.createVentBtnHeightCons.constant = 0
                         self.cretreEventImage.isHidden = true
                    }
                      self.eventsTableview.reloadData()
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
//            self.eventsTableview.addSubview(eventRefreshControl)
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Events Found"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = .none
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
       if self.response.count > 0{
           self.eventsTableview.backgroundView = nil
           self.eventsTableview.addSubview(eventRefreshControl)
       }else{
//           self.PendingtblView.backgroundView = UIImageView(image: UIImage(named: "NoPending"))
       }
       return response.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventsCell
       
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.eventImageView.sd_setImage(with: URL(string: (dict.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        cell.EventnameLbl.text = dict.value(forKey: "event_title") as? String
        cell.EventAddress.text = dict.value(forKey: "address") as? String
        var venueName = String()
        venueName = (dict.value(forKey: "venue_name") as? String)!
        var sponsoredStatus:Int!
        sponsoredStatus = dict.value(forKey: "sponsored") as? Int
        if sponsoredStatus == 1 {
            cell.eventSponsered_btn.isHidden = false
        }else{
            cell.eventSponsered_btn.isHidden = true
        }
        
        var dateTime = String()
        dateTime = (dict.value(forKey: "event_date") as? String)!
        
        var Time = String()
        Time = (dict.value(forKey: "event_time") as? String)!
        
        
        cell.EventVanueNamedateTimeLbl.text = venueName + "  " + dateTime + "  " + Time
        
        var price = NSNumber()
        price = dict.value(forKey: "price_per_sit") as! NSNumber
        
        
        cell.EventPricelbl.text =  "$" + price.stringValue
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        eventid = dict.value(forKey: "id") as? Int ?? 0
        evntuserid = dict.value(forKey: "user_id") as? Int ?? 0
        let defaults = UserDefaults.standard
        defaults.set(eventid, forKey: "EventID")
        defaults.set(evntuserid, forKey: "EventUserID")
        defaults.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventAllDetailsViewController") as! EventAllDetailsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
            eventListApi()
            
        }
    }
    
    @IBAction func createEventBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateAnEventViewController") as! CreateAnEventViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    

  
}
