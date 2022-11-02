//
//  VenueListView.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 14/10/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation

class VenueListView: UIView,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
   

    @IBOutlet weak var venueTableView: UITableView!
    var response:NSMutableArray!
    var userId:Int!
    var defaults:UserDefaults!
    var buttonDoneHandler : (() -> Void)?
    var buttonCancleHandler : (() -> Void)?
    var venueId:Int!
    var venueAddress:String!
    var venuename:String!
    var str_lat1:String!
    var str_long1:String!
    var city:String!
    var state:String!
    var country:String!
    var zipcode:Int!
    var Manager: CLLocationManager!
    var str_lat:NSString!
    var str_long:NSString!
    var isCall = Bool()
    
    @objc func DiscoverPostListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.venueTableView.reloadData()
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.venueTableView.reloadData()
            
            }
        }
    }
    
    
    class func intitiateFromNib() -> VenueListView {
        let View1 = UINib.init(nibName: "VenueListView", bundle: nil).instantiate(withOwner: self, options: nil).first as! VenueListView
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        response = NSMutableArray()
        
        venueTableView.delegate = self
        venueTableView.dataSource = self
        venueTableView.backgroundColor = UIColor(red: 22/255, green: 34/255, blue: 52/255, alpha: 1.0)
        
        let nib = UINib(nibName: "RVenueListCell", bundle: nil)
        self.venueTableView.register(nib, forCellReuseIdentifier: "cell")
        self.endEditing(true)
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
                if Reachability.isConnectedToNetwork() == true {
                    Parsing().DiscoverVenueListing(UserId: userId, ListType: "my_venue", Lat: str_lat as String?, Long: str_long as String?, Offset: 0)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverPostListAction), name: NSNotification.Name(rawValue: "DiscoverVenueListing"), object: nil)
                }else {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RVenueListCell
        var dict = NSDictionary()
        cell.backgroundColor = UIColor(red: 22/255, green: 34/255, blue: 52/255, alpha: 1.0)
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.venueImage.sd_setImage(with: URL(string: (dict.value(forKey: "venue_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        cell.venueName.text = dict.value(forKey: "venue_name") as? String
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        venueId = dict.value(forKey: "id") as? Int
        venueAddress = dict.value(forKey: "address") as? String
        venuename = dict.value(forKey: "venue_name") as? String
        str_lat1 = dict.value(forKey: "lat") as? String
        str_long1 = dict.value(forKey: "lng") as? String
        city = dict.value(forKey: "city") as? String
        state = dict.value(forKey: "state") as? String
        country = dict.value(forKey: "country") as? String
        zipcode = dict.value(forKey: "zipcode") as? Int
        let defaults = UserDefaults.standard
        defaults.set(venueId, forKey: "VID")
        defaults.set(venueAddress, forKey: "VADD")
        defaults.set(city, forKey: "CITY")
        defaults.set(state, forKey: "STATE")
        defaults.set(country, forKey: "COUNTRY")
        defaults.set(zipcode, forKey: "ZIPCODE")
        defaults.set(venuename, forKey: "VNAME")
        defaults.set(str_lat, forKey: "LAT")
        defaults.set(str_long, forKey: "LONG")
        defaults.synchronize()
        self.buttonDoneHandler?()
    }
    @IBAction func cnacleBtnAction(_ sender: Any) {
        buttonCancleHandler?()
    }
    

}
