//
//  ArtistCreateBandViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/09/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation

class ArtistCreateBandViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UISearchBarDelegate,UITextViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate  {

    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var InviteArtistTableview: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var BandNameLbl: FloatLabelTextField!
    
    @IBOutlet weak var phoneNumberLbl: FloatLabelTextField!
    @IBOutlet weak var cityLbl: FloatLabelTextField!
    @IBOutlet weak var stateLbl: FloatLabelTextField!
    @IBOutlet weak var zipCodeTxt: FloatLabelTextField! 
    @IBOutlet weak var searchtxt: UISearchBar!
    @IBOutlet weak var addressTxt: FloatLabelTextField!
    @IBOutlet weak var countryTxt: FloatLabelTextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionTxtview: UITextView!
    var picker = UIImagePickerController()
    var response:NSMutableArray!
    var response1:NSMutableArray!
    var pricearray:NSMutableArray!
    var genreArray:NSArray!
    var Genre_Id:Int!
    var ArtistId:Int!
    var selectedIndexes:NSMutableArray!
    var selectedIndexes1:NSMutableArray!
    var chosenImage = UIImage()
    var imagedata: Data!
    var defaults:UserDefaults!
    var user_Id:Int!
    var arryFav = NSMutableArray()
    var InviteArray:NSMutableArray!
    
    var str_BandName:NSString!
    var str_BandMobile:NSString!
    var str_City:NSString!
    var Str_State:NSString!
    var str_zipcode:NSString!
    var str_des:NSString!
    var str_address:NSString!
    var str_country:NSString!
    var userName = String()
    var userEmail = String()
    var searchplace = String()
    var searchActive = false
    var ArtistId1:Int!
    var artistUserId:Int!
    var city:String!
    var state:String!
    var country:String!
    var zipcode:String!
    var addres:String!
    
    @IBOutlet weak var viewProfileBtn: UIButton!
    var searchTextField: UITextField? {
        let subViews = self.searchtxt.subviews.first?.subviews.last?.subviews
        return subViews?.first as? UITextField
    }
    
    var str_lat:NSString!
    var str_long:NSString!
    var Manager: CLLocationManager!
    var isCall = Bool()
    var str:String!
    var bandid:Int!
    var banduserid:Int!
    var idArray = NSArray()
    var updateimage:String!
    var inAridArray = NSArray()
    var slooooooooooot = Int()
    var APICall = Bool()
    //MARK:- Login WebService
    @objc func DiscoverGenresAction(_ notification: Notification) {
        
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
                self.removeAllOverlays()
            }
            else{
               
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.genreArray = self.response.value(forKey: "id") as? NSArray
                // self.pricearray.add(self.genreArray!)
                self.genreCollectionView.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    //MARK:- Login WebService
    @objc func DiscoverArtistListAction(_ notification: Notification) {
        
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
                self.APICall = false
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: nil)
                self.removeAllOverlays()
            }
            else{
                var arr_data = NSMutableArray()
                arr_data = (notification.userInfo?["data"] as? NSMutableArray)!
                self.APICall = true
                if arr_data.count != 0 {
                    self.response1.addObjects(from: arr_data as NSMutableArray? as! [Any])
                    self.slooooooooooot = self.slooooooooooot + 10
                    arr_data.removeAllObjects()
                }
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: nil)
               // self.response1 = (notification.userInfo?["data"] as? NSMutableArray)!
               // print("response: \(String(describing: self.response))")
                self.InviteArtistTableview.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    //MARK:- Login WebService
    @objc func DiscoverSearchArtistListAction(_ notification: Notification) {
        
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
                self.response1.removeAllObjects()
                self.InviteArtistTableview.reloadData()
                self.APICall = false
                //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else{
                var arr_data = NSMutableArray()
                arr_data = (notification.userInfo?["data"] as? NSMutableArray)!
                self.APICall = true
                if arr_data.count != 0 {
                    self.response1.addObjects(from: arr_data as NSMutableArray? as! [Any])
                    self.slooooooooooot = self.slooooooooooot + 10
                    arr_data.removeAllObjects()
                }
               // self.response1 = (notification.userInfo?["data"] as? NSMutableArray)!
               // print("response: \(String(describing: self.response))")
                self.InviteArtistTableview.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    //MARK:- Create Artist WebService
    @objc func InviteArtistAction(_ notification: Notification) {
        
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
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateBand"), object: nil)
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
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name("CreateBand"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateBand"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    //MARK:- Create Artist WebService
    @objc func UpdateBandAction(_ notification: Notification) {
        
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
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUpdateBand"), object: nil)
                self.removeAllOverlays()
            }
            else{
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(response)")
                
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUpdateBand"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    
    //MARK:- Artist Detail WebService
    @objc func DiscoverBnadDetailAction(_ notification: Notification) {
        
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
                self.removeAllOverlays()
            }
            else{
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(response)")
                self.BandNameLbl.text = response.value(forKey: "band_name") as? String
                self.phoneNumberLbl.text = response.value(forKey: "mobile_no") as? String
                self.addressTxt.text = response.value(forKey: "address") as? String
                self.cityLbl.text = response.value(forKey: "city") as? String
                self.stateLbl.text = response.value(forKey: "state") as? String
                self.countryTxt.text = response.value(forKey: "country") as? String
                self.nameLbl.text = response.value(forKey: "band_name") as? String
                var zipcode = Int()
                zipcode = response.value(forKey: "zipcode") as! Int
                var zip = String()
                zip = String(zipcode)
                self.zipCodeTxt.text = zip
                self.descriptionTxtview.text = response.value(forKey: "description") as? String
                //self.NameLBl.text = response.value(forKey: "artist_name") as? String
               // self.EmailLbl.text = response.value(forKey: "email") as? String
                self.updateimage = response.value(forKey: "band_image") as? String
                self.profileImageView.sd_setImage(with: URL(string: (response.value(forKey: "band_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                var genArr = NSMutableArray()
                genArr = response.value(forKey: "genres") as! NSMutableArray
                self.idArray = genArr.value(forKey: "id") as! NSArray
                self.pricearray = NSMutableArray(array: self.idArray)
                print(self.pricearray!)
                self.genreArray = genArr.value(forKey: "genre_name") as? NSArray
                var InviteArr = NSMutableArray()
                InviteArr = response.value(forKey: "joined_artist") as! NSMutableArray
                self.inAridArray = InviteArr.value(forKey: "id") as! NSArray
                self.InviteArray = NSMutableArray(array: self.inAridArray)
                print(self.InviteArray!)
                self.genreCollectionView.reloadData()
                self.InviteArtistTableview.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverBandDetail"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBtn.layer.cornerRadius = 25
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        userName = (defaults.value(forKey: "FullName") as? String)!
        userEmail = (defaults.value(forKey: "Forgotemail") as? String)!
        ArtistId1 = defaults.integer(forKey: "ArtistID")
        str = defaults.value(forKey: "AREDIT") as? String
        bandid = defaults.integer(forKey: "BANDID")
        banduserid = defaults.integer(forKey: "BNDID")
        
        if str == "Edit" {
            viewProfileBtn.isHidden = false
        }else {
             viewProfileBtn.isHidden = true
        }
        
        addressTxt.delegate = self
       // nameLbl.text = userName
        emailLbl.text = userEmail
        response = NSMutableArray()
        response1 = NSMutableArray()
        pricearray = NSMutableArray()
        genreArray = NSArray()
        selectedIndexes = NSMutableArray()
        InviteArray = NSMutableArray()
        arryFav = NSMutableArray()
        selectedIndexes1 = NSMutableArray()
        
        descriptionTxtview.delegate = self
        descriptionTxtview.text = "Tell us more about band"
        
        self.searchtxt.delegate = self
        if #available(iOS 13.0, *) {
          searchTextField?.placeholder = "Search..."
          self.searchTextField?.textAlignment = NSTextAlignment.left
          searchTextField?.textColor = UIColor.white
          searchTextField?.backgroundColor = UIColor.clear
          searchTextField?.borderStyle = .none
          searchTextField?.clearButtonMode = .never
          searchTextField?.textAlignment = NSTextAlignment.left
        } else {
            let searchfield = self.searchtxt.subviews[0].subviews.last as! UITextField
                  searchfield.placeholder = "Search..."
                  searchfield.textColor = UIColor.white
                  searchfield.backgroundColor = UIColor.clear
                //  searchfield.becomeFirstResponder()
                  searchfield.borderStyle = .none
                  searchfield.textAlignment = NSTextAlignment.left
        }
        
      

        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        
       
        

        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("BANDADD"), object: nil)
        
        if Reachability.isConnectedToNetwork() == true {
        Parsing().GetGenresList()
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverGenresAction), name: NSNotification.Name(rawValue: "GetGenresListNotification"), object: nil)
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
            self.response1.removeAllObjects()
        }
        
        if str == "Add" {
            
        }else {
            if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().DiscoverBandDetail(BandId: bandid, UserId: user_Id, BandUserId: banduserid)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverBandDetail"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBnadDetailAction), name: NSNotification.Name(rawValue: "DiscoverBandDetail"), object: nil)
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
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        slooooooooooot = 0
        APICall = true
        response1.removeAllObjects()
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
                    Parsing().DiscoverArtistListing(user_Id: user_Id, List_type: "", Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverArtistListAction), name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: nil)
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
                    self.InviteArtistTableview.reloadData()
                }
            }
            manager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
       defaults = UserDefaults.standard
       city = defaults.value(forKey: "CITY") as? String
       state = defaults.value(forKey: "STATE") as? String
       country = defaults.value(forKey: "COUNTRY") as? String
       zipcode = defaults.value(forKey: "ZIPCODE") as? String
       addres = defaults.value(forKey: "ADDRESS") as? String
       addressTxt.text = addres
       cityLbl.text = city
       stateLbl.text = state
       countryTxt.text = country
       zipCodeTxt.text = zipcode
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addressTxt {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SelectAddressViewController") as! SelectAddressViewController
            navigationController?.pushViewController(vc, animated: true)
        }else {
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
  
    // textview delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Tell us more about band" {
            textView.text = ""
            textView.textColor = UIColor.white
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Tell us more about band"
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
  
    @IBAction func viewprofileBtnAction(_ sender: UIButton) {
        var dict = NSDictionary()
        dict = response.object(at: sender.tag) as! NSDictionary
        bandid = dict.value(forKey: "id") as? Int
        banduserid = dict.value(forKey: "user_id") as? Int
        let defaults = UserDefaults.standard
        defaults.set(bandid, forKey: "BandID")
        defaults.set(banduserid, forKey: "BandUserID")
        defaults.set(self.nameLbl.text, forKey: "BandName")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
  
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
       searchBar.resignFirstResponder()
        showWaitOverlay()
        Parsing().DiscoverArtistListing(user_Id: user_Id, List_type: "", Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverArtistListAction), name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: nil)
        searchBar.resignFirstResponder()
        searchActive = false
    }
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if Reachability.isConnectedToNetwork() == true {
        if searchBar.text == "" {
            slooooooooooot = 0
            APICall = true
            response.removeAllObjects()
            searchBar.resignFirstResponder()
            Parsing().DiscoverArtistListing(user_Id: user_Id, List_type: "", Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverArtistListAction), name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: nil)
        }else {
            slooooooooooot = 0
            APICall = true
            response1.removeAllObjects()
         searchBar.resignFirstResponder()
        showWaitOverlay()
            Parsing().DiscoverSearch(UserId: user_Id, SearchType: "artist_search", SearchKetword: searchBar.text, Offset: slooooooooooot)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSearchArtistListAction), name: NSNotification.Name(rawValue: "DiscoverSearchNotification"), object: nil)
        }
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
        }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchplace = searchText
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
             return true
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        if response.count>0
        {
            numOfSections            = 1
            collectionView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            noDataLabel.text          = "No Genres Found"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            collectionView.backgroundView  = noDataLabel
        }
        return numOfSections
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return response.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ArtistGenresCell
        
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        
        cell.genreBtn.setTitle(dict.value(forKey: "genre_name") as? String, for: .normal)
        if pricearray.contains(dict.object(forKey: "id")!) {
            cell.genreBtn.backgroundColor = UIColor(red: 210/255, green: 20/255, blue: 114/255, alpha: 1.0)
        } else {
            cell.genreBtn.backgroundColor = UIColor.clear
        }
        cell.genreBtn.layer.cornerRadius = 5
        cell.genreBtn.layer.borderColor = UIColor.gray.cgColor
        cell.genreBtn.layer.borderWidth = 1
        cell.genreBtn.tag = indexPath.row
        cell.genreBtn.addTarget(self, action: #selector(HandleTap(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func HandleTap(_ sender: UIButton){
        var btn = sender as? UIButton
        let dict1 = response.object(at: (btn?.tag)!) as! NSDictionary
        
        Genre_Id = dict1.value(forKey: "id") as? Int
        if selectedIndexes == nil {
            
            selectedIndexes = [AnyHashable]() as? NSMutableArray
        }
        if selectedIndexes.contains((btn?.tag)!) {
            selectedIndexes.remove((btn?.tag)!)
            pricearray.remove(Genre_Id!)
            
            
        }
        else {
            selectedIndexes.add((btn?.tag)!)
            pricearray.add(Genre_Id!)
            
        }
        let indexPath = NSIndexPath(row: (btn?.tag)!, section: 0)
        genreCollectionView.reloadItems(at: [indexPath as IndexPath])
        genreCollectionView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
            noDataLabel.text          = "No Artist/Bands Found"
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InviteBecomeArtistCell
        var dict = NSDictionary()
        dict = response1.object(at: indexPath.row) as! NSDictionary
        var userID:Int!
        userID = dict.value(forKey: "user_id") as? Int
        if userID == user_Id{
            cell.ArtistName.text = dict.value(forKey: "artist_name") as? String
            cell.ArtistImage.sd_setImage(with: URL(string: (dict.value(forKey: "artist_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            var city:String!
            city = dict.value(forKey: "city") as? String
            var state:String!
            state = dict.value(forKey: "state") as? String
            cell.ArtistDes.text = city + " " + state
            cell.inviteBtn.isHidden = true
            if InviteArray.contains(dict.object(forKey: "id")!) {
               cell.inviteBtn.setTitle("Joined", for: .normal)
               //cell.inviteBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
           } else {
               cell.inviteBtn.setTitle("Invite", for: .normal)
           }
        }else {
        cell.ArtistName.text = dict.value(forKey: "artist_name") as? String
        cell.ArtistImage.sd_setImage(with: URL(string: (dict.value(forKey: "artist_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            var city:String!
            city = dict.value(forKey: "city") as? String
            var state:String!
            state = dict.value(forKey: "state") as? String
            cell.ArtistDes.text = city + " " + state
        if InviteArray.contains(dict.object(forKey: "id")!) {
            cell.inviteBtn.setTitle("Joined", for: .normal)
            //cell.inviteBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        } else {
            cell.inviteBtn.setTitle("Invite", for: .normal)
        }
        cell.inviteBtn.isHidden = false
        cell.inviteBtn.tag = indexPath.row
        cell.inviteBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
            if searchtxt.text == "" {
                showWaitOverlay()
                Parsing().DiscoverArtistListing(user_Id: user_Id, List_type: "", Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverArtistListAction), name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: nil)
            }else {
                showWaitOverlay()
                Parsing().DiscoverSearch(UserId: user_Id, SearchType: "artist_search", SearchKetword: searchtxt.text, Offset: slooooooooooot)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchNotification"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSearchArtistListAction), name: NSNotification.Name(rawValue: "DiscoverSearchNotification"), object: nil)
            }
           
            
        }
    }
    
    @objc func handleTap(_ sender:UIButton) {
        
        /// Bharti
        
        var btn = sender as? UIButton
        let dict1 = response1.object(at: (btn?.tag)!) as! NSDictionary
        ArtistId = dict1.value(forKey: "id") as? Int
        
        let myIP = IndexPath(row: sender.tag, section: 0)
        let cell1 = InviteArtistTableview.cellForRow(at: myIP) as? InviteBecomeArtistCell
        
        if selectedIndexes1 == nil {
            
            selectedIndexes1 = [AnyHashable]() as? NSMutableArray
        }
        if selectedIndexes1.contains((btn?.tag)!) {
            selectedIndexes1.remove((btn?.tag)!)
            InviteArray.remove(ArtistId!)
            //cell1!.inviteBtn.setTitle("Invite", for: .normal)
            
        }
        else {
            selectedIndexes1.add((btn?.tag)!)
            InviteArray.add(ArtistId!)
            //cell1!.inviteBtn.setTitle("Joined", for: .normal)
        }
        

        
        let indexPath = NSIndexPath(row: (btn?.tag)!, section: 0)
        InviteArtistTableview.reloadRows(at: [indexPath as IndexPath], with: .none)
        InviteArtistTableview.reloadData()
      
    }
    
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func uploadImageBtnAction(_ sender: Any) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerController.SourceType.camera
        present(picker, animated: true, completion: nil)
    }
    func openGallary()
    {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        chosenImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        profileImageView.image = chosenImage
        profileImageView.image = self.resizeImage(chosenImage)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY hh:mm:ss"
        let dateExtension = formatter.string(from: date)
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dateExtension).appending(".png")
        print(paths)
        
        imagedata = chosenImage.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: paths as String, contents: imagedata, attributes: nil)
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    func resizeImage(_ image:UIImage) -> UIImage
    {
        let actualHeight = Int(image.size.height);
        let actualWidth = Int(image.size.width);
        let compressionQuality:CGFloat = 0.3;//50 percent compression
        
        let newsizeWidth = CGFloat( actualWidth ) * CGFloat(compressionQuality)
        let newsizeHeight = CGFloat( actualHeight ) * CGFloat(compressionQuality)
        let newSize = CGSize(width: newsizeWidth , height: newsizeHeight);
        
        // Scale the original image to match the new size.
        UIGraphicsBeginImageContext(newSize);
        image.draw(in: CGRect(x: 0, y: 0 , width: newSize.width , height: newSize.height))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        return compressedImage!
        
    }
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        if str == "Add" {
        str_BandName = BandNameLbl.text as NSString?
        str_BandMobile  = phoneNumberLbl.text as NSString?
        str_City = cityLbl.text as NSString?
        Str_State = stateLbl.text as NSString?
        str_zipcode = zipCodeTxt.text as NSString?
        str_des = descriptionTxtview.text as NSString?
        str_address = addressTxt.text as NSString?
        str_country = countryTxt.text as NSString?
        if str_BandName .isEqual(to: ""){
            let test =  SwiftToast(
                text: "Please Enter Band Name",
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
        }else if str_BandMobile .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Band Mobile Number",
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
        }else if str_BandMobile.length < 7 || str_BandMobile.length > 15 {
            let test =  SwiftToast(
                text: "Enter Artist Mobile Number Should be 7-15 digits.",
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
        }else if str_address .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Address",
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
        else if str_City .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter City",
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
        }else if Str_State .isEqual(to:  "") {
            let test =  SwiftToast(
                text: "Please Enter State",
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
        }else if str_country .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Country",
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
        else if str_zipcode .isEqual(to:  "") {
            let test =  SwiftToast(
                text: "Please Enter Zipcode",
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
        }else if str_des .isEqual(to:  "Description") {
            let test =  SwiftToast(
                text: "Please Enter Description",
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
        } else if pricearray.count == 0 {
            let test =  SwiftToast(
                text: "Please Select Genres",
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
        } else if InviteArray.count == 0 {
            let test =  SwiftToast(
                text: "Please Select Invited Artist",
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
        
        
        else {
            if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            let data = CreateBandModel()
            if imagedata == nil {
                
            }
            else {
                data.Band_Image = imagedata as NSData
            }
            
            
            
            data.UserId = user_Id
            data.BandName = str_BandName as String
            data.MobileNo = str_BandMobile as String
            data.Address = str_address as String
            data.City = str_City as String
            data.State = Str_State as String
            data.Country = str_country as String
            data.Zipcode = str_zipcode as String
            data.Description = str_des as String
            data.ArtistId = ArtistId1
            
            let  typeIdArrayString = self.JSONStringify(value: pricearray as AnyObject)
            print(typeIdArrayString)
            
            data.Genres = typeIdArrayString as String
            let  typeIdArrayString1 = self.JSONStringify(value: InviteArray as AnyObject)
            print(typeIdArrayString1)
            data.InviteArtist = typeIdArrayString1
            
            Parsing().DiscoverCreateBand(data: data)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateBand"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.InviteArtistAction), name: NSNotification.Name(rawValue: "DiscoverCreateBand"), object: nil)
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
            }
        }
        }else {
            str_BandName = BandNameLbl.text as NSString?
            str_BandMobile  = phoneNumberLbl.text as NSString?
            str_City = cityLbl.text as NSString?
            Str_State = stateLbl.text as NSString?
            str_zipcode = zipCodeTxt.text as NSString?
            str_des = descriptionTxtview.text as NSString?
            str_address = addressTxt.text as NSString?
            str_country = countryTxt.text as NSString?
            if str_BandName .isEqual(to: ""){
                let test =  SwiftToast(
                    text: "Please Enter Band Name",
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
            }else if str_BandMobile .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Band Mobile Number",
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
            }else if str_BandMobile.length < 7 || str_BandMobile.length > 15 {
                let test =  SwiftToast(
                    text: "Band Mobile Number Should be 7-15 digits.",
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
            }else if str_address .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Address",
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
            else if str_City .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter City",
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
            }else if Str_State .isEqual(to:  "") {
                let test =  SwiftToast(
                    text: "Please Enter State",
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
            }else if str_country .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Country",
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
            else if str_zipcode .isEqual(to:  "") {
                let test =  SwiftToast(
                    text: "Please Enter Zipcode",
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
            }else if str_des .isEqual(to:  "Description") {
                let test =  SwiftToast(
                    text: "Please Enter Description",
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
            } else if pricearray.count == 0 {
                let test =  SwiftToast(
                    text: "Please Select Genres",
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
            } else if InviteArray.count == 0 {
                let test =  SwiftToast(
                    text: "Please Select Invited Artist",
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
                
                
            else {
                if Reachability.isConnectedToNetwork() == true {
                    showWaitOverlay()
                    let data = UpdateBandModel()
                    if imagedata == nil {
                        let AddPicture_url: NSURL = NSURL(string: self.updateimage)!
                        let testImage = NSData(contentsOf: AddPicture_url as URL)
                        data.Band_Image = testImage!
                    }
                    else {
                        data.Band_Image = imagedata as NSData
                    }
                    
                    
                    data.Id = bandid
                    data.UserId = user_Id
                    data.BandName = str_BandName as String
                    data.MobileNo = str_BandMobile as String
                    data.Address = str_address as String
                    data.City = str_City as String
                    data.State = Str_State as String
                    data.Country = str_country as String
                    data.Zipcode = str_zipcode as String
                    data.Description = str_des as String
                    data.ArtistId = ArtistId1
                    
                    let  typeIdArrayString = self.JSONStringify(value: pricearray as AnyObject)
                    print(typeIdArrayString)
                    
                    data.Genres = typeIdArrayString as String
                    let  typeIdArrayString1 = self.JSONStringify(value: InviteArray as AnyObject)
                    print(typeIdArrayString1)
                    data.InviteArtist = typeIdArrayString1
                    
                    Parsing().DiscoverUpdateBand(data: data)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUpdateBand"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateBandAction), name: NSNotification.Name(rawValue: "DiscoverUpdateBand"), object: nil)
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
                }
            }
        }
        
    }
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        if JSONSerialization.isValidJSONObject(value) {
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                print("error")
            }
        }
        return ""
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
