//
//  PendingUserEventViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation

class PendingUserEventViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
   
    

    @IBOutlet weak var pendingTableview: UITableView!
    var response: NSMutableArray!
    var defaults:UserDefaults!
    var user_Id:Int!
    var event_id:Int!
    var Manager: CLLocationManager!
    var str_lat:NSString!
    var str_long:NSString!
    var isCall = Bool()
    var venueid:Int!
    var eventid:Int!
    var evntuserid:Int!
    //MARK:- Login WebService
    @objc func DiscoverEventListAction(_ notification: Notification) {
        
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
                //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.pendingTableview.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    
    //MARK:- Login WebService
    @objc func DiscoverEventCancleAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCancelEvent"), object: nil)
                self.pendingTableview.reloadData()
                self.removeAllOverlays()
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.pendingTableview.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCancelEvent"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    //MARK:- Login WebService
    @objc func DiscoverEventPuslishAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCancelEvent"), object: nil)
                self.pendingTableview.reloadData()
                self.removeAllOverlays()
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.pendingTableview.reloadData()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                self.navigationController?.pushViewController(vc!, animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCancelEvent"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        venueid = defaults.integer(forKey: "VID")
        response = NSMutableArray()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        if Reachability.isConnectedToNetwork() == true {
//            showWaitOverlay()
//            Parsing().DiscoverEventListing(UserId: user_Id, EventStatus: "pending", ArtistId: venueid, Lat:str_lat as String?, Long: str_long as String?)
//            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverEventListAction), name: NSNotification.Name(rawValue: "DiscoverEventListing"), object: nil)
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

        
        self.determineMyCurrentLocation()
        
    }
    
    func determineMyCurrentLocation() {
        Manager = CLLocationManager()
        Manager.delegate = self
        Manager.desiredAccuracy = kCLLocationAccuracyBest
        Manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            Manager.startUpdatingLocation()
            Manager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        
        
        // self.map.setRegion(region, animated: true)
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        print("\(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
        
        str_lat = ((String(userLocation.coordinate.latitude) as NSString))
        str_long = ((String(userLocation.coordinate.longitude) as NSString))
        print("lat: \(String(describing: str_lat))")
        print("long: \(String(describing: str_long))")
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in
           // print(placemarks!)
            //            if let placemarks = placemarks as? [CLPlacemark], placemarks.count > 0 {
            //                var placemark = placemarks[0]
            //                print(placemark.addressDictionary)
        }
        
        if userLocation.coordinate.latitude>0  {
            
            if !isCall
            {
                if Reachability.isConnectedToNetwork() == true {
                    showWaitOverlay()
                    Parsing().DiscoverEventListing(UserId: user_Id, EventStatus: "pending", ArtistId: venueid, Lat: str_lat as String?, Long: str_long as String?, Offset: 0)
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
            manager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if response.count>0
        {
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Pending Events Found"
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PendingeventCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.eventImageView.sd_setImage(with: URL(string: (dict.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        cell.EventName.text = dict.value(forKey: "event_title") as? String
        cell.EventAddress.text = dict.value(forKey: "address") as? String
        
        var venueName = String()
        venueName = (dict.value(forKey: "venue_name") as? String)!
        
        var dateTime = String()
        dateTime = (dict.value(forKey: "event_date") as? String)!
        
        
        var Time = String()
        Time = (dict.value(forKey: "event_time") as? String)!
        
        cell.VenueNameDateTiemLbl.text = venueName + " " + dateTime  + "  " + Time
        
        var eventprice = NSNumber()
        eventprice = dict.value(forKey: "price_per_sit") as! NSNumber
        
        
        
        cell.PriceLbl.text =  "$" + eventprice.stringValue
    
        cell.cancelbtn.tag = indexPath.row
        cell.cancelbtn.addTarget(self, action: #selector(HandleTap(_:)), for: .touchUpInside)
        
        cell.publishBtn.tag = indexPath.row
        cell.publishBtn.addTarget(self, action: #selector(HandleTap1(_:)), for: .touchUpInside)
        
        self.event_id = dict.value(forKey: "id") as? Int
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        eventid = dict.value(forKey: "id") as? Int
        evntuserid = dict.value(forKey: "user_id") as? Int
        let defaults = UserDefaults.standard
        defaults.set(eventid, forKey: "EventID")
        defaults.set(evntuserid, forKey: "EventUserID")
        defaults.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventAllDetailsViewController") as! EventAllDetailsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func HandleTap(_ sender:UIButton) {
        
        var btn = sender as? UIButton
        let dict1 = response.object(at: (btn?.tag)!) as! NSDictionary
        
        let s_id = dict1.object(forKey: "id") ?? NSString()
        if Reachability.isConnectedToNetwork() == true {
        showWaitOverlay()
        Parsing().DiscoverCancelEvent(UserId: user_Id, EventId: s_id as? Int, Event_Type: "Cancel")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCancelEvent"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverEventCancleAction), name: NSNotification.Name(rawValue: "DiscoverCancelEvent"), object: nil)
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
        }
    }
    
    @objc func HandleTap1(_ sender:UIButton) {
        var btn = sender as? UIButton
        let dict1 = response.object(at: (btn?.tag)!) as! NSDictionary
        
        let s_id = dict1.object(forKey: "id") ?? NSString()
        if Reachability.isConnectedToNetwork() == true {
        showWaitOverlay()
        Parsing().DiscoverCancelEvent(UserId: user_Id, EventId: s_id as? Int, Event_Type: "Publish")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCancelEvent"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverEventPuslishAction), name: NSNotification.Name(rawValue: "DiscoverCancelEvent"), object: nil)
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
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("emptyfield"), object: nil)
        navigationController?.popViewController(animated: true)
    }
    
}
