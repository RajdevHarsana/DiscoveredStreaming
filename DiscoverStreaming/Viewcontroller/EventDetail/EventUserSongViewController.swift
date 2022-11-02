//
//  EventUserSongViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation

class EventUserSongViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
   
    

    @IBOutlet weak var EventSongTable: UITableView!
    var bandID:Int!
    var defaults:UserDefaults!
    var userid:Int!
    var response = NSMutableArray()
    var banduserid:Int!
    
    var str_lat:NSString!
    var str_long:NSString!
    var Manager: CLLocationManager!
    var isCall = Bool()
    var slooooooooooot = Int()
    var APICall = Bool()
    
    @IBOutlet weak var addsongImageview: UIImageView!
    @IBOutlet weak var addosngBtnHeightCons: NSLayoutConstraint!
    
    @objc func DiscoverSongListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.APICall = false
                self.EventSongTable.reloadData()
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
                self.EventSongTable.reloadData()
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongList"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         defaults = UserDefaults.standard
         userid = defaults.integer(forKey: "UserIDGet")
         bandID = defaults.integer(forKey: "BandID")
         banduserid = defaults.integer(forKey: "BandUserID")
        if banduserid == userid {
            self.addsongImageview.isHidden = false
            self.addosngBtnHeightCons.constant = 70
            
        }else {
            self.addsongImageview.isHidden = true
            self.addosngBtnHeightCons.constant = 0
        }
         NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("UploadSong1"), object: nil)
//         NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen2(_:)), name: NSNotification.Name("UpdateSong1"), object: nil)
//
//        if Reachability.isConnectedToNetwork() == true{
//            showWaitOverlay()
//            Parsing().DiscoverSongList(UserId: userid, AsType: "band", AstypeId: bandID, ListType: "all")
//            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongListAction), name: NSNotification.Name(rawValue: "DiscoverSongList"), object: nil)
//        }else{
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
//
//        }

        // Do any additional setup after loading the view.
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        if Reachability.isConnectedToNetwork() == true{
            slooooooooooot = 0
            APICall = true
            response.removeAllObjects()
            showWaitOverlay()
            Parsing().DiscoverSongList(UserId: userid, AsType: "band", AstypeId: bandID, ListType: "all", Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongList"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongListAction), name: NSNotification.Name(rawValue: "DiscoverSongList"), object: nil)
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
            self.present(test, animated: true)
            
        }
        
    }
    
    @objc func currencyItemChosen2(_ pNotification: Notification?) {
        if Reachability.isConnectedToNetwork() == true{
            slooooooooooot = 0
            APICall = true
            response.removeAllObjects()
            showWaitOverlay()
            Parsing().DiscoverSongList(UserId: userid, AsType: "artist", AstypeId: bandID, ListType: "all", Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongList"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongListAction), name: NSNotification.Name(rawValue: "DiscoverSongList"), object: nil)
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
            self.present(test, animated: true)
            
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
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
        let defaults = UserDefaults.standard
        defaults.set(str_lat, forKey: "LAT")
        defaults.set(str_long, forKey: "LONG")
        defaults.synchronize()
        
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
                    Parsing().DiscoverSongList(UserId: userid, AsType: "band", AstypeId: bandID, ListType: "all", Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongList"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongListAction), name: NSNotification.Name(rawValue: "DiscoverSongList"), object: nil)
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
                    self.EventSongTable.reloadData()
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
            noDataLabel.text          = "No Songs Found"
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventUserSongCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.songname.text = dict.value(forKey: "song_name") as? String
        var view:Int!
        view = dict.value(forKey: "viewer") as? Int
        var viewcou:String!
        viewcou = String(view)
        cell.views.text = viewcou + " " + "views"
        cell.songImage.sd_setImage(with: URL(string: (dict.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        var gen:String!
        gen =  dict.value(forKey: "genres") as? String
        cell.genre.text = "Genre:" + " " + gen
        
         var rating: NSNumber!
         rating = dict.value(forKey: "rating") as? NSNumber
         
         cell.ratingview.rating = Float(truncating: rating)
         var rateper:Int!
         rateper =  dict.value(forKey: "rating_percentage") as? Int
        
         var rate = String()
         rate = String(rateper)
        
         cell.ratingper.text =  rate + "%"
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
            showWaitOverlay()
            Parsing().DiscoverSongList(UserId: userid, AsType: "band", AstypeId: bandID, ListType: "all", Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongList"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongListAction), name: NSNotification.Name(rawValue: "DiscoverSongList"), object: nil)
            
            
        }
    }
    
    
    @IBAction func addNewSongBtnAction(_ sender: Any) {
        var str = String()
        str = "Add"
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "ADD")
        defaults.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNewSongViewController") as! AddNewSongViewController
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
