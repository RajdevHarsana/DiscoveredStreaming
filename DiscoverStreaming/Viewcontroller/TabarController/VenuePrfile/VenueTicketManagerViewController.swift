//
//  VenueTicketManagerViewController.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 10/08/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation

class VenueTicketManagerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {

    @IBOutlet weak var eventsTableview: UITableView!
     var response: NSMutableArray!
     var defaults:UserDefaults!
     var user_Id:Int!
     var Manager: CLLocationManager!
     var str_lat:NSString!
     var str_long:NSString!
     var isCall = Bool()
     var venue_ID:Int!
    
     @IBOutlet weak var createEventBTn: UIButton!
     @IBOutlet weak var createVentBtnHeightCons: NSLayoutConstraint!
     @IBOutlet weak var cretreEventImage: UIImageView!
     var venue_sts:Int!
     var eventid:Int!
     var evntuserid:Int!
     var slooooooooooot = Int()
     var APICall = Bool()
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
//                     self.createVentBtnHeightCons.constant = 69
//                     self.cretreEventImage.isHidden = false
                 }else {
//                     self.createVentBtnHeightCons.constant = 0
//                     self.cretreEventImage.isHidden = true
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
//                     self.createVentBtnHeightCons.constant = 69
//                     self.cretreEventImage.isHidden = false
                 }else {
                     var strsts:String!
                     strsts = nil
                     let defaults = UserDefaults.standard
                     defaults.set(strsts, forKey: "SHOEVEN")
                     defaults.synchronize()
//                      self.createVentBtnHeightCons.constant = 0
//                      self.cretreEventImage.isHidden = true
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
         
         defaults = UserDefaults.standard
         user_Id = defaults.integer(forKey: "UserIDGet")
         venue_ID = defaults.integer(forKey: "ARVenID")
        
        self.eventsTableview.delegate = self
        self.eventsTableview.dataSource = self
         
     NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("CreateEvent"), object: nil)
         
         
         
         response = NSMutableArray()
        
        
        

         // Do any additional setup after loading the view.
     }
     
     @objc func currencyItemChosen1(_ pNotification: Notification?) {
         slooooooooooot = 0
         APICall = true
         response.removeAllObjects()
         if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
             Parsing().DiscoverEventListing(UserId: user_Id, EventStatus: "venue_upcoming_ongoing", ArtistId: venue_ID, Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
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
         slooooooooooot = 0
         APICall = true
         response.removeAllObjects()
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
                 if Reachability.isConnectedToNetwork(){
                     showWaitOverlay()
                     Parsing().DiscoverEventListing(UserId: user_Id, EventStatus: "venue_upcoming_ongoing", ArtistId: venue_ID, Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
                       NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverEventListing"), object: nil)
                     NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverEventListAction), name: NSNotification.Name(rawValue: "DiscoverEventListing"), object: nil)
                 }
                 else{
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
                     // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Internet Connection not Available!" , buttonTitle: "OK")
                 }
             }
             manager.stopUpdatingLocation()
         }
         
     }
     
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
     {
         print("Error \(error)")
     }
     
     
     func numberOfSections(in tableView: UITableView) -> Int
     {
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
             noDataLabel.text = "No Events Found"
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
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VenueEventsCell
        
         var dict = NSDictionary()
         dict = response.object(at: indexPath.row) as! NSDictionary
         cell.eventImageView.sd_setImage(with: URL(string: (dict.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
         cell.EventnameLbl.text = dict.value(forKey: "event_title") as? String
         cell.EventAddress.text = dict.value(forKey: "address") as? String
         var venueName = String()
         venueName = (dict.value(forKey: "venue_name") as? String)!
         
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
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "VenueEventDetailViewController") as! VenueEventDetailViewController
         navigationController?.pushViewController(vc, animated: true)
     }
     
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
             showWaitOverlay()
             Parsing().DiscoverEventListing(UserId: user_Id, EventStatus: "venue_upcoming_ongoing", ArtistId: venue_ID, Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
               NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverEventListing"), object: nil)
             NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverEventListAction), name: NSNotification.Name(rawValue: "DiscoverEventListing"), object: nil)
             
         }
     }
     
     @IBAction func backBtnAction(_ sender: Any) {
         navigationController?.popViewController(animated: true)
     }

}
