//
//  MySubscriotionViewController.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 29/07/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation

class MySubscriotionViewController: UIViewController,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var mySubscriptiontableView: UITableView!
    var userID:Int!
    var defaults:UserDefaults!
    var response = NSMutableArray()
    var Manager: CLLocationManager!
    var str_lat:NSString!
    var str_long:NSString!
    var isCall = Bool()
    var venueId:Int!
    var venueName:String!
    var arryFav = NSMutableArray()
    var Data1 = Int()
    var venue_Status:Int!
//    var slooooooooooot = Int()
    var APICall = Bool()
    //MARK:- Login WebService
    @objc func DiscoverVenueListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.mySubscriptiontableView.isHidden = true
                 self.APICall = false
                self.mySubscriptiontableView.reloadData()
            }
            else{
                var arr_data = NSMutableArray()
                arr_data = (notification.userInfo?["data"] as? NSMutableArray)!
                self.APICall = true
                if arr_data.count != 0 {
                    self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
//                    self.slooooooooooot = self.slooooooooooot + 10
                    arr_data.removeAllObjects()
                }
                self.venue_Status = self.response.value(forKey: "venue_status") as? Int

                for i in 0..<self.response.count {

                    var dict = NSDictionary()
                    dict = self.response.object(at: i) as! NSDictionary

                    let s_id = dict.object(forKey: "id") ?? NSString()
                    var isFav = Int()
                    isFav = dict.object(forKey: "venue_status") as! Int
                    //self.arryFav = []
                    if isFav == 2
                    {
                        self.arryFav.add(s_id)
                    }

                }
                print("response: \(String(describing: self.response))")
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverVenueListing"), object: nil)
                self.mySubscriptiontableView.reloadData()
                self.removeAllOverlays()
                self.mySubscriptiontableView.isHidden = false
                
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaults = UserDefaults.standard
        userID = defaults.integer(forKey: "UserIDGet")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
        self.determineMyCurrentLocation()
        
        // NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("CreateVenue"), object: nil)
        
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
                    Parsing().DiscoverVenueListing(UserId: userID, ListType: "my_venue", Lat: str_lat as String?, Long: str_long as String?, Offset: 0)
                      NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverVenueListing"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverVenueListAction), name: NSNotification.Name(rawValue: "DiscoverVenueListing"), object: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MySubscriptionCell
        
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.venue_name_lbl.text = dict.value(forKey: "venue_name") as? String
        cell.subs_btn.tag = indexPath.row
        cell.subs_btn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        var createdDate = dict.value(forKey: "created_date") as? String
        
        var venuestatus:Int!
        venuestatus = dict.value(forKey: "venue_status") as? Int
        
        if venuestatus == 0{
            cell.subs_btn.isHidden = true
            cell.package_status_lbl.isHidden = false
            cell.package_status_lbl.text = "Not approved"
            
        }else if venuestatus == 2 {
            cell.subs_btn.isHidden = false
            cell.package_status_lbl.isHidden = true
            var venuepackagestatus:Int!
            venuepackagestatus = dict.value(forKey: "venue_package_status") as? Int
            if venuepackagestatus == 0{
                cell.subs_btn.setImage(UIImage(named: "buy-btn"), for: .normal)
            }else if venuepackagestatus == 1{
                cell.subs_btn.setImage(UIImage(named: "active-btn"), for: .normal)
            }else if venuepackagestatus == 2{
                cell.subs_btn.setImage(UIImage(named: "expired-btn"), for: .normal)
            }
        }else if venuestatus == 3 {
            cell.subs_btn.isHidden = true
            cell.package_status_lbl.isHidden = false
            cell.package_status_lbl.text = "Venue rejected"
        }
        
        return cell
    }
    
    @objc func handleTap(_ sender:UIButton) {
        
//        var btn = sender as? UIButton
        let dict1 = response.object(at: sender.tag) as! NSDictionary
        let venueId = dict1.object(forKey: "id") as! Int
        defaults.set(venueId, forKey: "PackageForId")
        var s_id = Int()
        s_id = dict1.object(forKey: "venue_package_status") as! Int
        
        if s_id == 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PackageViewController") as! PackageViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if s_id == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActiveVenuePlanViewController") as! ActiveVenuePlanViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if s_id == 2{
            
        }
        
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
//            showWaitOverlay()
//            Parsing().DiscoverVenueListing(UserId: userID, ListType: "my_venue", Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
//            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverVenueListAction), name: NSNotification.Name(rawValue: "DiscoverVenueListing"), object: nil)
//
//        }
//    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
