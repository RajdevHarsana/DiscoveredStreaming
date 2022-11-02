//
//  ActiveFeaturedArtistViewController.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 06/08/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import Popover
import CoreLocation
import SwiftToast

class ActiveFeaturedArtistViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,CLLocationManagerDelegate {

    @IBOutlet weak var activeArtistPlanCollectionView: UICollectionView!

        let screenWidth = UIScreen.main.bounds.size.width
        let screenheight = UIScreen.main.bounds.size.height
        var defaults :UserDefaults!
        var Arsts:String!
        var user_id:Int!
        var artist_id:Int!
        var response = NSMutableDictionary()
        var Manager: CLLocationManager!
        var isCall = Bool()
        var str_lat:NSString!
        var str_long:NSString!
        
        @objc func DiscoveredFeaturedArtistPlanAction (_ notification: Notification){
            let status = (notification.userInfo?["status"] as? Int)!
            let str_message = (notification.userInfo?["message"] as? String)!
    //        let proStatus = Int(status)
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
                    self.activeArtistPlanCollectionView.reloadData()
                    self.removeAllOverlays()
                    //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                    
                }
                else{
                    
                    self.response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                    print("response: \(self.response)")
                    self.activeArtistPlanCollectionView.reloadData()
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverFeaturedCurrentPlan"), object: nil)
                    self.removeAllOverlays()
                }
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()

            defaults = UserDefaults.standard
            user_id = defaults.integer(forKey: "UserIDGet")
            artist_id = defaults.integer(forKey: "ArtistID")
            self.activeArtistPlanCollectionView.delegate = self
            self.activeArtistPlanCollectionView.dataSource = self
            
    //        let LiberaryLayOut = UICollectionViewFlowLayout()
    //        LiberaryLayOut.itemSize = CGSize(width: 260, height: 400)
    //        LiberaryLayOut.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    //        LiberaryLayOut.minimumInteritemSpacing = 0
     //       LiberaryLayOut.minimumLineSpacing = 30
    //        LiberaryLayOut.scrollDirection = .horizontal
            
    //        activePlanCollectionView.collectionViewLayout = LiberaryLayOut
            
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
                Manager.requestLocation()
                
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
                            Parsing().DiscoverFeaturedCurrentPlan(user_Id: user_id, PlanTypeid: artist_id, PlanType: "featured_artist")
                             NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverFeaturedCurrentPlan"), object: nil)
                             NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoveredFeaturedArtistPlanAction), name: NSNotification.Name(rawValue: "DiscoverFeaturedCurrentPlan"), object: nil)
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
        //                    self.response.removeAllObjects()
        //                    self.artistTableview.reloadData()
                        }
                    }
                    manager.stopUpdatingLocation()
                }
                
            }
            
            func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
            {
                print("Error \(error)")
            }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            1
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ActiveFetauredArtistCell
    //        var dict = NSDictionary()
    //        dict = response.object(forKey: indexPath.row) as! NSDictionary
            cell.layer.cornerRadius = 10
            let createDate = response.value(forKey: "created_date") as? String ?? ""
            cell.startDate_lbl.text = "Purchased on : \(createDate)"
            let expierDate = response.value(forKey: "expire_date") as? String ?? ""
            cell.endDate_lbl.text = "Valid till : \(expierDate)"
            cell.artistPlanName_lbl.text = response.value(forKey: "package_name") as? String ?? ""
            cell.description_txt.text = response.value(forKey: "custom_text") as? String ?? ""
    //        var id = dict.value(forKey: "id") as? String ?? ""
            let price = response.value(forKey: "amount") as? Int ?? 0
            let amount = String("$ \(price)")
            let myColor : UIColor = UIColor.white
            cell.amount_lbl.layer.borderWidth = 2
            cell.amount_lbl.layer.borderColor = myColor.cgColor
            cell.amount_lbl.layer.cornerRadius = 10
            cell.amount_lbl.text = amount
            return cell
        }
        
        
        @IBAction func backBtnAction(_ sender: Any) {
            navigationController?.popViewController(animated: true)
        }

}
