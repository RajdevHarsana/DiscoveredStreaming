//
//  VenuesFollowViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 16/01/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftToast

class VenuesFollowViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {

    @IBOutlet weak var venueFollowTableview: UITableView!
    var defaults:UserDefaults!
    var userid:Int!
    var Manager: CLLocationManager!
    var str_lat:NSString!
    var str_long:NSString!
    var isCall = Bool()
    var response = NSMutableArray()
    var Data1:Int!
    var venueId:Int!
    var venueName:String!
    //MARK:- Login WebService
    @objc func DiscoverFollowListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.venueFollowTableview.reloadData()
                
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.venueFollowTableview.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    //MARK:- follow
    @objc func FollowArtistAction(_ notification: Notification) {
        
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
                Parsing().DiscoverGetFollowingList(UserId: self.userid, FollowType: "venue", Lat: self.str_lat as String?, Long: self.str_long as String?, Offset: 0)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverFollowListAction), name: NSNotification.Name(rawValue: "DiscoverGetFollowingList"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistFollowUnfollow"), object: nil)
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
                Parsing().DiscoverGetFollowingList(UserId: self.userid, FollowType: "venue", Lat: self.str_lat as String?, Long: self.str_long as String?, Offset: 0)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverFollowListAction), name: NSNotification.Name(rawValue: "DiscoverGetFollowingList"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistFollowUnfollow"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        userid = defaults.integer(forKey: "UserIDGet")
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
                    showWaitOverlay()
                    Parsing().DiscoverGetFollowingList(UserId: userid, FollowType: "venue", Lat: str_lat as String?, Long: str_long as String?, Offset: 0)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverFollowListAction), name: NSNotification.Name(rawValue: "DiscoverGetFollowingList"), object: nil)
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
            noDataLabel.text          = "No Venues Found"
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VenuesFollowCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.venueImageview.sd_setImage(with: URL(string: (dict.value(forKey: "venue_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        cell.venueNameLbl.text = dict.value(forKey: "venue_name") as? String
        var Views = Int()
        Views =  dict.value(forKey: "viewer") as! Int
        var str_view = String()
        str_view = String(Views)
        cell.viewslbl.text = str_view + " " + "Views"
        var rating1:Int!
        rating1 = dict.value(forKey: "rating") as? Int
        var rate = Float()
        rate = Float(rating1)
        cell.venueRatingView.rating = Float(truncating: NSNumber(value: rate))
        var ratingper:Int!
        ratingper = dict.value(forKey: "rating_percentage") as? Int
        var rateper = String()
        rateper = String(ratingper)
        cell.venueRatePer.text = rateper + "%"
        
        cell.unfollowBtn.tag = indexPath.row
        cell.unfollowBtn.addTarget(self, action: #selector(HandleTap(_:)), for: .touchUpInside)
        
        return cell
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

    
    @objc func HandleTap(_ sender:UIButton)
    {
        var dict = NSDictionary()
        dict = response.object(at: sender.tag) as! NSDictionary
        var followid:Int!
        followid = dict.value(forKey: "id") as? Int
        
        showWaitOverlay()
        Parsing().DiscoverArtistFollowUnfollow(user_Id: userid, FollowId: followid, Follow_Type: "venue")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistFollowUnfollow"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.FollowArtistAction), name: NSNotification.Name(rawValue: "DiscoverArtistFollowUnfollow"), object: nil)
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
