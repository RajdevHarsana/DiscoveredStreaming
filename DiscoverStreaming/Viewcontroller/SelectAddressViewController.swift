//
//  SelectAddressViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 06/12/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import CoreLocation
import GooglePlaces

class SelectAddressViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var mapview: GMSMapView!
    var locationManager = CLLocationManager()
     var driverMarker: GMSMarker?
    var str_lat:String!
    var str_long:String!
    var centerMapCoordinate:CLLocationCoordinate2D!
    var city:String!
    var state:String!
    var country:String!
    var zipcode:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Your map initiation code
        mapview.delegate = self
        mapview?.isMyLocationEnabled = true
        determineMyCurrentLocation()
        //Location Manager code to fetch current location
       

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    
    
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        
        
        // self.map.setRegion(region, animated: true)
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        print("\(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
        
        str_lat = ((String(userLocation.coordinate.latitude)))
        str_long = ((String(userLocation.coordinate.longitude)))
        
        let morelat = Double(self.str_lat)!
        let morelong = Double(self.str_long)
        convertLatLongToAddress(latitude: morelat, longitude: morelong!)

        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in
        }
        let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 14.0)
        self.mapview?.animate(to: camera)
        
        if userLocation.coordinate.latitude>0  {
            manager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
//                    print(pm.country!)
//                    print(pm.locality!)
//                    print(pm.subLocality!)
//                    print(pm.thoroughfare!)
//                    print(pm.postalCode!)
                   // print(pm.subThoroughfare!)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                   self.addressLbl.text = addressString
                    print(addressString)
                }
        })
        
    }
    
    func convertLatLongToAddress(latitude:Double,longitude:Double){
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
       
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if placemarks == nil{
                print("No Location Available")
                print(location)
            }else {
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                var addressString : String = ""
                // Location name
                if let locationName = placeMark.location {
                    print(locationName)
                }
                //
                if let sublocal = placeMark.subLocality {
                    addressString = addressString + sublocal + ", "
                    print(sublocal)
                    
                }
                // Street address
                if let street = placeMark.thoroughfare {
                    addressString = addressString + street + ", "
                    print(street)
                    
                }
                // City
                if let city = placeMark.subAdministrativeArea {
                    addressString = addressString + city + ", "
                    self.city = city
                    print(city)
                }
                // State
                if let state = placeMark.administrativeArea {
                    addressString = addressString + state + ", "
                    print(state)
                    self.state = state
                }
                // Country
                if let country = placeMark.country {
                    addressString = addressString + country + ", "
                    print(country)
                    self.country = country
                }
                // Zip code
                if let zip = placeMark.postalCode {
                    addressString = addressString + zip + ", "
                    print(zip)
                    self.zipcode = zip
                }
                self.addressLbl.text = addressString
                print(addressString)
            }
           
        })
        
    }
    
    
    // Camera change Position this methods will call every time
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        var destinationLocation = CLLocation()
//        var desi = CLLocationCoordinate2D()
//        destinationLocation = CLLocation(latitude: position.target.latitude,  longitude: position.target.longitude)
//        print(position.target.latitude)
//        print(position.target.longitude)
//
//        desi = destinationLocation.coordinate
//        print(desi)
//        updateLocationoordinates(coordinates: desi)
        
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.placeMarkerOnCenter(centerMapCoordinate:centerMapCoordinate)

    }
    
    func placeMarkerOnCenter(centerMapCoordinate:CLLocationCoordinate2D) {
        if driverMarker == nil {
            driverMarker = GMSMarker()
        }
        driverMarker!.position = centerMapCoordinate
        var strlat = String()
        strlat = String(centerMapCoordinate.latitude)
        var strlong = String()
        strlong = String(centerMapCoordinate.longitude)
        let morelat = Double(strlat)
        let morelong = Double(strlong)
        convertLatLongToAddress(latitude: morelat!, longitude: morelong!)
        driverMarker?.map = mapview
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmBtnAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(addressLbl.text, forKey: "ADDRESS")
        defaults.set(city, forKey: "CITY")
        defaults.set(state, forKey: "STATE")
        defaults.set(country, forKey: "COUNTRY")
        defaults.set(zipcode, forKey: "ZIPCODE")
        defaults.synchronize()
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("BANDADD"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("ARTISTADD"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("PROFILESETUP"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("ARTISTUPDATE"), object: nil)
    }
    
}
