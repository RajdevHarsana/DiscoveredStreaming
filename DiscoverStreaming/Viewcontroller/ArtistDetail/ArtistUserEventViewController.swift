//
//  ArtistUserEventViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation

class ArtistUserEventViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {

    @IBOutlet weak var artistEventTable: UITableView!
    
    var response: NSMutableArray!
    var defaults:UserDefaults!
    var user_Id:Int!
    var artistId:Int!
    var evemtid:Int!
    var Manager: CLLocationManager!
    var str_lat:NSString!
    var str_long:NSString!
    var isCall = Bool()
    var artisatEventRefreshControl: UIRefreshControl!
    
    @IBOutlet weak var notFoundLbl: UILabel!
    //MARK:- Login WebService
    @objc func DiscoverEventListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                 self.removeAllOverlays()
                self.artistEventTable.isHidden = true
                self.notFoundLbl.isHidden = false
                self.artistEventTable.reloadData()
                
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.artistEventTable.reloadData()
                self.artistEventTable.isHidden = false
                self.notFoundLbl.isHidden = true
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
        if #available(iOS 10.0, *) {
            self.artisatEventRefreshControl = UIRefreshControl()
            self.artisatEventRefreshControl.tintColor = UIColor.systemPink
//            self.venueRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.artisatEventRefreshControl.addTarget(self,action: #selector(self.refreshArtistEventList),for: .valueChanged)
            self.artistEventTable.addSubview(self.artisatEventRefreshControl)
        }
        }
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        artistId = defaults.integer(forKey: "ArtistID")
        
        notFoundLbl.isHidden = true
        
        response = NSMutableArray()
        self.artistEventTable.reloadData()
        

        // Do any additional setup after loading the view.
    }
    
    @objc func refreshArtistEventList(sender: UIRefreshControl) {
       // Code to refresh table view
        self.artistEventTable.reloadData()
        self.artisatEventRefreshControl.endRefreshing()
        self.EventListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.response.removeAllObjects()
        self.EventListApi()
    }
    
//    func determineMyCurrentLocation() {
//        Manager = CLLocationManager()
//        Manager.delegate = self
//        Manager.desiredAccuracy = kCLLocationAccuracyBest
//        Manager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            Manager.startUpdatingLocation()
//            Manager.startUpdatingHeading()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation:CLLocation = locations[0] as CLLocation
//
//
//
//        // self.map.setRegion(region, animated: true)
//
//        print("user latitude = \(userLocation.coordinate.latitude)")
//        print("user longitude = \(userLocation.coordinate.longitude)")
//
//        print("\(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
//
//        str_lat = ((String(userLocation.coordinate.latitude) as NSString))
//        str_long = ((String(userLocation.coordinate.longitude) as NSString))
//        print("lat: \(String(describing: str_lat))")
//        print("long: \(String(describing: str_long))")
//
//        let geocoder = CLGeocoder()
//        let location = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//        geocoder.reverseGeocodeLocation(location) {
//            (placemarks, error) -> Void in
//            // print(placemarks!)
//            //            if let placemarks = placemarks as? [CLPlacemark], placemarks.count > 0 {
//            //                var placemark = placemarks[0]
//            //                print(placemark.addressDictionary)
//        }
//
//        if userLocation.coordinate.latitude>0  {
//
//            if !isCall
//            {
//                if Reachability.isConnectedToNetwork(){
//                    showWaitOverlay()
//                    Parsing().DiscoverEventListing(UserId: user_Id, EventStatus: "artist", ArtistId: artistId, Lat: str_lat as String?, Long: str_long as String?, Offset: 0)
//                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverEventListAction), name: NSNotification.Name(rawValue: "DiscoverEventListing"), object: nil)
//                } else {
//                    let test =  SwiftToast(
//                        text: "Internet Connection not Available!",
//                        textAlignment: .center,
//                        image: UIImage(named: "Icon-App-29x29"),
//                        backgroundColor: .purple,
//                        textColor: .white,
//                        font: .boldSystemFont(ofSize: 15.0),
//                        duration: 2.0,
//                        minimumHeight: CGFloat(80.0),
//                        aboveStatusBar: false,
//                        target: nil,
//                        style: .navigationBar)
//                    self.present(test, animated: true)
//                    self.response.removeAllObjects()
//                }
//            }
//            manager.stopUpdatingLocation()
//        }
//
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
//    {
//        print("Error \(error)")
//    }

     
    func EventListApi(){
        if !isCall
        {
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
            parameterDictionary.setValue(DataManager.getVal("artist"), forKey: "related_type")
            parameterDictionary.setValue(DataManager.getVal(artistId), forKey: "related_type_id")
            parameterDictionary.setValue(DataManager.getVal(str_lat), forKey: "lat")
            parameterDictionary.setValue(DataManager.getVal(str_long), forKey: "lng")
            parameterDictionary.setValue(DataManager.getVal(0), forKey: "offset")
            print(parameterDictionary)
            
            let methodName = "event_list"
            
            DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                if status == "0" {
                    self.removeAllOverlays()
//                    self.artistEventTable.isHidden = true
//                    self.notFoundLbl.isHidden = false
                    self.artistEventTable.reloadData()
                }else{
                self.response = (responseData?.object(forKey: "data") as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.artistEventTable.reloadData()
                self.artistEventTable.isHidden = false
                self.notFoundLbl.isHidden = true
                self.removeAllOverlays()
              }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if response.count>0
        {
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
            self.artistEventTable.addSubview(artisatEventRefreshControl)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArtistUserEventCell
       
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.eventImageView.layer.cornerRadius = 5
        cell.eventImageView.sd_setImage(with: URL(string: (dict.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        cell.EvnetNameLbl.text = dict.value(forKey: "event_title") as? String
        cell.EventAddress.text = dict.value(forKey: "address") as? String
      //  var venueName = String()
       // venueName = (dict.value(forKey: "venue_name") as? String)!
        
        var dateTime = String()
        dateTime = (dict.value(forKey: "event_date") as? String)!
        
        var Time = String()
        Time = dict.value(forKey: "event_time") as! String
        var SponseredSts:Int!
        SponseredSts = dict.value(forKey: "sponsored") as? Int
        
        if SponseredSts == 0 {
            cell.sponsoredbtn.isHidden = true
        }else {
            cell.sponsoredbtn.isHidden = false
        }
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"//this your string date format
//        let date = dateFormatter.date(from: dateTime)
//
//
//        dateFormatter.dateFormat = "dd MMM yyyy HH:mm a"///this is what you want to convert format
        //let timeStamp = dateFormatter.string(from: date!)
        
        cell.EventVenueNameDateTimeLbl.text =  dateTime + " " + Time
        
      //  var price = Int()
      //  price = dict.value(forKey: "price_per_sit") as! Int
        
        var price = NSNumber()
        price = dict.value(forKey: "price_per_sit") as! NSNumber
        
       
        
        cell.EventPriceLbl.text =  "$" + price.stringValue
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
