//
//  VenueProfileViewpop.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 29/11/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftToast

class VenueProfileViewpop: UIView,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    
    

    @IBOutlet weak var venueTableview: UITableView!
    var response1:NSMutableArray!
    var venueuserid:Int!
    var buttonCancleHandler : (() -> Void)?
    var buttonCloseHandler : (() -> Void)?
    var venuename:String!
    var venueimage:String!
    var userid:Int!
    var defaults:UserDefaults!
    
    var Manager: CLLocationManager!
    var str_lat:NSString!
    var str_long:NSString!
    var isCall = Bool()
    var nav: UIStoryboard!
    var navController : UINavigationController?
    class func intitiateFromNib() -> VenueProfileViewpop {
        let View1 = UINib.init(nibName: "VenueProfileViewpop", bundle: nil).instantiate(withOwner: self, options: nil).first as! VenueProfileViewpop
        return View1
    }
    
    @objc func DiscoverVenueListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.venueTableview.reloadData()
            }
            else{
                self.response1 = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response1))")
                self.venueTableview.reloadData()
                
            }
        }
    }
    
    //MARK:- Login WebService
    @objc func DiscoverDeleteVenueAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverDeleteVenue"), object: nil)
            }
            else{
                Parsing().DiscoverVenueListing(UserId: self.userid, ListType: "my_venue", Lat: self.str_lat as String?, Long: self.str_long as String?, Offset: 0)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverVenueListAction), name: NSNotification.Name(rawValue: "DiscoverVenueListing"), object: nil)
                self.nav = UIStoryboard(name: "Main", bundle: nil)
                let navigate = self.nav.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                self.navController = UINavigationController(rootViewController: navigate)
                self.window?.rootViewController = self.navController
                navigate.navigationController?.navigationBar.isHidden = true
                self.window?.makeKeyAndVisible()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverDeleteVenue"), object: nil)
                }
                
            }
        }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaults = UserDefaults.standard
        userid = defaults.integer(forKey: "UserIDGet")
        venueTableview.delegate = self
        venueTableview.dataSource = self
        response1 = NSMutableArray()
        venueTableview.backgroundColor = UIColor(red: 22/255, green: 34/255, blue: 52/255, alpha: 1.0)
        
        let nib = UINib(nibName: "SelVenueCell", bundle: nil)
        self.venueTableview.register(nib, forCellReuseIdentifier: "cell")
        
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
                if Reachability.isConnectedToNetwork() == true{
                    Parsing().DiscoverVenueListing(UserId: userid, ListType: "my_venue", Lat: str_lat as String?, Long: str_long as String?, Offset: 0)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverVenueListAction), name: NSNotification.Name(rawValue: "DiscoverVenueListing"), object: nil)
                }else{
                    
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
        if response1.count>0
        {
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
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
        return response1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelVenueCell
        var dict = NSDictionary()
        dict = response1.object(at: indexPath.row) as! NSDictionary
        cell.venuenameLbl.text = dict.value(forKey: "venue_name") as? String
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(HandleTap(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func HandleTap(_ sender:UIButton) {
        var dict = NSDictionary()
        dict = response1.object(at: sender.tag) as! NSDictionary
        var venId:Int!
        venId = dict.value(forKey: "id") as? Int
        if Reachability.isConnectedToNetwork() == true{
        Parsing().DiscoverDeleteVenue(UserId: userid, VenueId: venId)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverDeleteVenue"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverDeleteVenueAction), name: NSNotification.Name(rawValue: "DiscoverDeleteVenue"), object: nil)
         }else {
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response1.object(at: indexPath.row) as! NSDictionary
        venueuserid = dict.value(forKey: "id") as? Int
        venuename = dict.value(forKey: "venue_name") as? String
        venueimage = dict.value(forKey: "venue_image") as? String
        var str = String()
        str = "Venu"
        
        let defaults = UserDefaults.standard
        defaults.set(venueuserid, forKey: "VENID")
        defaults.set(venuename, forKey: "VENNAME")
        defaults.set(venueimage, forKey: "VENIMG")
        defaults.set(str, forKey: "VENe")
        defaults.synchronize()
        buttonCloseHandler?()
    }
    
    
    @IBAction func cnaclebtbaction(_ sender: Any) {
         buttonCancleHandler?()
    }
    

}
