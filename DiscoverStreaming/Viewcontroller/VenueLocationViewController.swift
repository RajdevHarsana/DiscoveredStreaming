//
//  VenueLocationViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/11/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import MapKit
class VenueLocationViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

    @IBOutlet weak var mapview: GMSMapView!
    var defaults:UserDefaults!
    var strlat:String!
    var strlong:String!
      var driverMarker: GMSMarker?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        defaults = UserDefaults.standard
        strlat = defaults.value(forKey: "lati") as? String
        strlong = defaults.value(forKey: "long") as? String
        
        
        let morelat = Double(self.strlat)
        let morelong = Double(self.strlong)
        
        print(self.strlat!)
        print(self.strlong!)
        self.driverMarker = GMSMarker()
        self.driverMarker?.position = CLLocationCoordinate2DMake(morelat!, morelong!)
        self.driverMarker?.icon = UIImage(named: "")
        self.driverMarker?.map = self.mapview
        let updatedCamera = GMSCameraUpdate.setTarget((self.driverMarker?.position)!, zoom: 14.0)
        self.mapview.animate(with: updatedCamera)
    }
    
    @IBAction func cancleBtnAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
    }
    
   

}
