//
//  VenueManageEventsViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation
class VenueManageEventsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,CLLocationManagerDelegate {
   

    @IBOutlet weak var pendingEventCollection: UICollectionView!
    @IBOutlet weak var ongoingEventCollection: UICollectionView!
    @IBOutlet weak var upcomingEventCollection: UICollectionView!
    @IBOutlet weak var pastEventCollection: UICollectionView!
    
    var response = NSMutableArray()
    var response1 = NSMutableArray()
    var response2 = NSMutableArray()
    var response3 = NSMutableArray()
    var defaults:UserDefaults!
    var user_Id:Int!
    var Manager: CLLocationManager!
    var str_lat:NSString!
    var str_long:NSString!
    var isCall = Bool()
    var venueid:Int!
    var eventid:Int!
    var evntuserid:Int!
    
    @IBOutlet weak var pendingViewAllBtn: UIButton!
    @IBOutlet weak var ongoingViewAllBtn: UIButton!
    
    @IBOutlet weak var upcomingViewAllBtn: UIButton!
    @IBOutlet weak var pastViewAllBtn: UIButton!
    
    @objc func DiscoverEventListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                // self.upcomingEventCollection.isHidden = true
                self.pendingViewAllBtn.isHidden = true
                self.ongoingViewAllBtn.isHidden = true
                self.upcomingViewAllBtn.isHidden = true
                self.pastViewAllBtn.isHidden = true
                self.pendingEventCollection.reloadData()
            }
            else{
                var dict = NSMutableDictionary()
                dict = (notification.userInfo?["data"] as? NSMutableDictionary)!
                self.response = dict.value(forKey: "pending") as! NSMutableArray
                self.response1 = dict.value(forKey: "ongoing") as! NSMutableArray
                self.response2 = dict.value(forKey: "upcoming") as! NSMutableArray
                self.response3 = dict.value(forKey: "past") as! NSMutableArray
                if self.response.count == 0 {
                    self.pendingViewAllBtn.isHidden = true
                }else {
                     self.pendingViewAllBtn.isHidden = false
                }
                
                if self.response1.count == 0 {
                    self.ongoingViewAllBtn.isHidden = true
                }else {
                    self.ongoingViewAllBtn.isHidden = false
                }
                if self.response2.count == 0 {
                    self.upcomingViewAllBtn.isHidden = true
                }else {
                    self.upcomingViewAllBtn.isHidden = false
                }
                if self.response3.count == 0 {
                    self.pastViewAllBtn.isHidden = true
                }else {
                    self.pastViewAllBtn.isHidden = false
                }
                self.pendingEventCollection.reloadData()
                self.ongoingEventCollection.reloadData()
                self.upcomingEventCollection.reloadData()
                self.pastEventCollection.reloadData()
                self.removeAllOverlays()
                self.pendingEventCollection.isHidden = false
                
            }
        }
    }
    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        venueid = defaults.integer(forKey: "ARVenID")


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
                    Parsing().DiscoverEventListing1(UserId: user_Id, EventStatus: "venue_all_event", ArtistId: venueid, Lat: str_lat as String?, Long: str_long as String?)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverEventListAction), name: NSNotification.Name(rawValue: "DiscoverEventListing1"), object: nil)
                    
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == pendingEventCollection {
            var numOfSections: Int = 0
            if response.count>0
            {
                numOfSections            = 1
                collectionView.backgroundView = nil
            }
            else
            {
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
                noDataLabel.text          = "No Pending Events Found"
                noDataLabel.textColor     = UIColor.white
                noDataLabel.textAlignment = .center
                collectionView.backgroundView  = noDataLabel
            }
            return numOfSections
        }else if collectionView == ongoingEventCollection{
            var numOfSections: Int = 0
            if response1.count>0
            {
                numOfSections            = 1
                collectionView.backgroundView = nil
            }
            else
            {
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
                noDataLabel.text          = "No Ongoing Events Found"
                noDataLabel.textColor     = UIColor.white
                noDataLabel.textAlignment = .center
                collectionView.backgroundView  = noDataLabel
            }
            return numOfSections
        }else if collectionView == upcomingEventCollection{
            var numOfSections: Int = 0
            if response2.count>0
            {
                numOfSections            = 1
                collectionView.backgroundView = nil
            }
            else
            {
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
                noDataLabel.text          = "No Upcoming Events Found"
                noDataLabel.textColor     = UIColor.white
                noDataLabel.textAlignment = .center
                collectionView.backgroundView  = noDataLabel
            }
            return numOfSections
        }else{
            var numOfSections: Int = 0
            if response3.count>0
            {
                numOfSections            = 1
                collectionView.backgroundView = nil
            }
            else
            {
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
                noDataLabel.text          = "No Past Events Found"
                noDataLabel.textColor     = UIColor.white
                noDataLabel.textAlignment = .center
                collectionView.backgroundView  = noDataLabel
            }
            return numOfSections
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == pendingEventCollection {
            return response.count
        } else if collectionView == ongoingEventCollection {
            return response1.count
        } else if collectionView == upcomingEventCollection {
            return response2.count
        }else {
            return response3.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == pendingEventCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VenuePendingEventCell
            var dict = NSDictionary()
            dict = response.object(at: indexPath.row) as! NSDictionary
            cell.eventImage.sd_setImage(with: URL(string: (dict.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.eventname.text = dict.value(forKey: "event_title") as? String
            var dateTime = String()
            dateTime = (dict.value(forKey: "event_date") as? String)!
            
            var Time = String()
            Time = (dict.value(forKey: "event_time") as? String)!
            
            cell.dateLbl.text = dateTime + " " + Time
            var price = NSNumber()
            price = dict.value(forKey: "price_per_sit") as! NSNumber
            
           
            
            cell.priceLbl.text =  "$" + price.stringValue
            return cell
        } else if collectionView == ongoingEventCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VenueOngoingEventCell
            var dict = NSDictionary()
            dict = response1.object(at: indexPath.row) as! NSDictionary
            cell.evnetImage.sd_setImage(with: URL(string: (dict.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.eventNameLbl.text = dict.value(forKey: "event_title") as? String
            var dateTime = String()
            dateTime = (dict.value(forKey: "event_date") as? String)!
            
            var Time = String()
            Time = (dict.value(forKey: "event_time") as? String)!
            
            cell.dateLbl.text = dateTime + " " + Time
            var price = NSNumber()
            price = dict.value(forKey: "price_per_sit") as! NSNumber
            
           
            cell.priceLbl.text =  "$" + price.stringValue
            return cell
        }else if collectionView == upcomingEventCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VenueUpcomingEventCell
            var dict = NSDictionary()
            dict = response2.object(at: indexPath.row) as! NSDictionary
            cell.eventImage.sd_setImage(with: URL(string: (dict.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.nameLbl.text = dict.value(forKey: "event_title") as? String
            var dateTime = String()
            dateTime = (dict.value(forKey: "event_date") as? String)!
            
            var Time = String()
            Time = (dict.value(forKey: "event_time") as? String)!
            
            cell.dateLbl.text = dateTime + " " + Time
            var price = NSNumber()
            price = dict.value(forKey: "price_per_sit") as! NSNumber
            
            
            
            cell.priceLbl.text =  "$" + price.stringValue
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VenuePastEventCell
            var dict = NSDictionary()
            dict = response3.object(at: indexPath.row) as! NSDictionary
            cell.eventImage.sd_setImage(with: URL(string: (dict.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.nameLbl.text = dict.value(forKey: "event_title") as? String
            var dateTime = String()
            dateTime = (dict.value(forKey: "event_date") as? String)!
            
            var Time = String()
            Time = (dict.value(forKey: "event_time") as? String)!
            
            cell.dateLbl.text = dateTime + " " + Time
            var price = NSNumber()
            price = dict.value(forKey: "price_per_sit") as! NSNumber
            
           
            
            cell.priceLbl.text =  "$" + price.stringValue
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == pendingEventCollection {
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
        }else if collectionView == ongoingEventCollection {
            var dict = NSDictionary()
            dict = response1.object(at: indexPath.row) as! NSDictionary
            eventid = dict.value(forKey: "id") as? Int
            evntuserid = dict.value(forKey: "user_id") as? Int
            let defaults = UserDefaults.standard
            defaults.set(eventid, forKey: "EventID")
            defaults.set(evntuserid, forKey: "EventUserID")
            defaults.synchronize()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventAllDetailsViewController") as! EventAllDetailsViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == upcomingEventCollection {
            var dict = NSDictionary()
            dict = response2.object(at: indexPath.row) as! NSDictionary
            eventid = dict.value(forKey: "id") as? Int
            evntuserid = dict.value(forKey: "user_id") as? Int
            let defaults = UserDefaults.standard
            defaults.set(eventid, forKey: "EventID")
            defaults.set(evntuserid, forKey: "EventUserID")
            defaults.synchronize()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventAllDetailsViewController") as! EventAllDetailsViewController
            navigationController?.pushViewController(vc, animated: true)
        }else {
            var dict = NSDictionary()
            dict = response3.object(at: indexPath.row) as! NSDictionary
            eventid = dict.value(forKey: "id") as? Int
            evntuserid = dict.value(forKey: "user_id") as? Int
            let defaults = UserDefaults.standard
            defaults.set(eventid, forKey: "EventID")
            defaults.set(evntuserid, forKey: "EventUserID")
            defaults.synchronize()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventAllDetailsViewController") as! EventAllDetailsViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createEventBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateAnEventViewController") as! CreateAnEventViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func pendingViewAllBtnAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(venueid, forKey: "VID")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "PendingUserEventViewController") as! PendingUserEventViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func ongoingViewAllBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OngoingViewController") as! OngoingViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func upcomingViewAllBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UpcomingEventsViewController") as! UpcomingEventsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func pastViewAllBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PastViewController") as! PastViewController
        navigationController?.pushViewController(vc, animated: true)
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
