//
//  VenueUserEventViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation

class VenueUserEventViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
   

    @IBOutlet weak var eventTable: UITableView!
    var venueId:Int!
    var user_id:Int!
    var defaults:UserDefaults!
    var response = NSMutableArray()
    var evemtid:Int!
    var Manager: CLLocationManager!
    var str_lat:NSString!
    var str_long:NSString!
    var isCall = Bool()
    var typeID = Int()
    var flag = Bool()
    
    //MARK:- Login WebService
    @objc func DiscoverEventListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.eventTable.reloadData()
                
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.eventTable.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if flag == true{
        defaults = UserDefaults.standard
        user_id = defaults.integer(forKey: "UserIDGet")
        venueId = typeID
        }else{
        defaults = UserDefaults.standard
        venueId = defaults.integer(forKey: "VenueID")
        user_id = defaults.integer(forKey: "UserIDGet")
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        determineMyCurrentLocation()
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
//                    var vid:Int!
//                    vid = Int(venueId)
                    showWaitOverlay()
                    Parsing().DiscoverEventListing(UserId: user_id, EventStatus: "venue", ArtistId: venueId, Lat: str_lat as String?, Long: str_long as String?, Offset: 0)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverEventListAction), name: NSNotification.Name(rawValue: "DiscoverEventListing"), object: nil)
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
            noDataLabel.text          = "No Events Found"
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VenueUserEventCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.eventImageview.sd_setImage(with: URL(string: (dict.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        cell.eventNameLbl.text = dict.value(forKey: "event_title") as? String
        cell.eventAddLbl.text = dict.value(forKey: "address") as? String
       // var venueName = String()
       // venueName = (dict.value(forKey: "venue_name") as? String)!
        
        var dateTime = String()
        dateTime = (dict.value(forKey: "event_date") as? String)!
        
        var Time = String()
        Time = dict.value(forKey: "event_time") as! String
        cell.venuenamedatetimeLbl.text =  dateTime + " " + Time
        
        
        var eventprice = NSNumber()
        eventprice =  dict.value(forKey: "price_per_sit") as! NSNumber
        
        cell.priceLbl.text =  "$" + eventprice.stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        evemtid = dict.value(forKey: "id") as? Int
        var evntid:String!
        evntid = String(evemtid)
        let defaults = UserDefaults.standard
        defaults.set(evntid, forKey: "EventID")
        defaults.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventAllDetailsViewController") as! EventAllDetailsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
