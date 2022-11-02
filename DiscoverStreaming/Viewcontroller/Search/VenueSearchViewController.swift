//
//  VenueSearchViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 10/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation
class VenueSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UISearchBarDelegate {

    @IBOutlet weak var venueTableview: UITableView!
    @IBOutlet weak var SearchTxt: UISearchBar!
    @IBOutlet weak var songTypeLbl: UILabel!
    var userID:Int!
    var defaults:UserDefaults!
    var response = NSMutableArray()
    var Manager: CLLocationManager!
    var str_lat:String!
    var str_long:String!
    var isCall = Bool()
    var venueId:String!
    var venueName:String!
    var searchplace = String()
    var venueRefreshControl: UIRefreshControl!
    
    var searchTextField: UITextField? {
        let subViews = self.SearchTxt.subviews.first?.subviews.last?.subviews
        return subViews?.first as? UITextField
    }
    
    var ordertype:String!
    var sortorder:String!
    var sortarray = NSMutableArray()
    var dict = [String: Any]()
    
   
    var distance:String!
    var rating:String!
    var capcity:String!
    var apicall:String!
    var venueId1:String!
    var venueName1:String!
    var slooooooooooot = Int()
    var APICall = Bool()
    var type:String!
//    //MARK:- Login WebService
//    @objc func DiscoverVenueListAction(_ notification: Notification) {
//
//        let status = (notification.userInfo?["status"] as? Int)!
//        let str_message = (notification.userInfo?["message"] as? String)!
//
//        DispatchQueue.main.async() {
//            if status == 0{
//                self.APICall = false
//                self.removeAllOverlays()
//                self.venueTableview.reloadData()
//            }
//            else{
//                var arr_data = NSMutableArray()
//                arr_data = (notification.userInfo?["data"] as? NSMutableArray)!
//                self.APICall = true
//                if arr_data.count != 0 {
//                    self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
//                    self.slooooooooooot = self.slooooooooooot + 10
//                    arr_data.removeAllObjects()
//                }
//                print("response: \(String(describing: self.response))")
//                self.venueTableview.reloadData()
//                self.removeAllOverlays()
//
//
//            }
//        }
//    }
//
//    @objc func DiscoverSongSearchFilterSortAction(_ notification: Notification) {
//
//        let status = (notification.userInfo?["status"] as? Int)!
//        let str_message = (notification.userInfo?["message"] as? String)!
//
//        DispatchQueue.main.async() {
//            if status == 0{
//                self.removeAllOverlays()
//                self.response.removeAllObjects()
//                self.venueTableview.reloadData()
//
//            }
//            else{
//                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
//                print("response: \(String(describing: self.response))")
//                self.venueTableview.reloadData()
//                self.removeAllOverlays()
//
//            }
//        }
//    }
//
    @objc func DiscoverSongFilterAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.venueTableview.reloadData()
                self.APICall = false
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
                print("response: \(String(describing: self.response))")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
                self.venueTableview.reloadData()
                self.removeAllOverlays()
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            self.venueRefreshControl = UIRefreshControl()
            self.venueRefreshControl.tintColor = UIColor.systemPink
//            self.venueRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.venueRefreshControl.addTarget(self,action: #selector(self.refreshSearchVenueList),for: .valueChanged)
            self.venueTableview.addSubview(self.venueRefreshControl)
        }
        defaults = UserDefaults.standard
        userID = defaults.integer(forKey: "UserIDGet")
        str_lat = defaults.value(forKey: "LAT") as? String
        str_long = defaults.value(forKey: "LONG") as? String
        
        defaults.removeObject(forKey: "BUTTONIMGVE1")
        defaults.removeObject(forKey: "BUTTONIMGVE2")
        defaults.removeObject(forKey: "BUTTONIMGVE3")
        defaults.removeObject(forKey: "BUTTONIMGVE4")
        
        SearchTxt.delegate = self
        if #available(iOS 13.0, *) {
           searchTextField?.placeholder = "Search..."
           self.searchTextField?.textAlignment = NSTextAlignment.left
           searchTextField?.textColor = UIColor.white
           searchTextField?.backgroundColor = UIColor.clear
           searchTextField?.borderStyle = .none
           searchTextField?.clearButtonMode = .never
           searchTextField?.textAlignment = NSTextAlignment.left
       }else {
       let searchfield = self.SearchTxt.subviews[0].subviews.last as! UITextField
           searchfield.placeholder = " Search..."
           searchfield.textColor = UIColor.white
           searchfield.backgroundColor = UIColor.clear
           searchfield.borderStyle = .none
           searchfield.clearButtonMode = .never
           searchfield.textAlignment = NSTextAlignment.left
        }
        
        if apicall == nil || apicall == "APINOTCall" {
            slooooooooooot = 0
            APICall = true
            response.removeAllObjects()
            searchVenueListApi()
        }else {
           // NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("VenueFilter"), object: nil)
            
        }
       
        songTypeLbl.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("VenueFilter"), object: nil)
        // Do any additional setup after loading the view.
        
    }
    
    @objc func refreshSearchVenueList(sender: UIRefreshControl) {
       // Code to refresh table view
        self.slooooooooooot = 0
        self.response.removeAllObjects()
        self.searchVenueListApi()
//        self.venueTableview.reloadData()
        self.venueRefreshControl.endRefreshing()
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        apicall = defaults.value(forKey: "APICALLVENUE") as? String
        distance = defaults.value(forKey: "Disatnce") as? String
        rating = defaults.value(forKey: "Rating") as? String
        capcity = defaults.value(forKey: "Capcity") as? String
        if Reachability.isConnectedToNetwork() == true {
            slooooooooooot = 0
            APICall = true
            response.removeAllObjects()
            showWaitOverlay()
            Parsing().DiscoverSearchVenueFilter(UserId: userID, FilterType: "venue", SearchKeyword: SearchTxt.text, Sort: "", Limit: 10, Offset: slooooooooooot, Rating: rating, Distance: distance, Size: capcity, Lat: str_lat as String?, Long: str_long as String?)
             NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
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
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
        
        searchBar.resignFirstResponder()
        if SearchTxt.text == "" {
            if Reachability.isConnectedToNetwork() == true{
                showWaitOverlay()
                 Parsing().DiscoverSearchVenueFilter(UserId: userID, FilterType: "venue", SearchKeyword: "", Sort: "", Limit: 10, Offset: slooooooooooot, Rating: "", Distance: "", Size: "", Lat: str_lat as String?, Long: str_long as String?)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
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
            
        }else {
            if Reachability.isConnectedToNetwork() == true{
                showWaitOverlay()
                Parsing().DiscoverSearchVenueFilter(UserId: userID, FilterType: "venue", SearchKeyword: SearchTxt.text, Sort: "", Limit: 10, Offset: slooooooooooot, Rating: "", Distance: "", Size: "", Lat: str_lat as String?, Long: str_long as String?)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
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
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchplace = searchText
        if searchplace == ""{
        self.slooooooooooot = 0
        self.response.removeAllObjects()
        self.searchVenueListApi()
        self.venueTableview.reloadData()
        }
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        defaults = UserDefaults.standard
        apicall = defaults.value(forKey: "APICALLVENUE") as? String
        distance = defaults.value(forKey: "Disatnce") as? String
        rating = defaults.value(forKey: "Rating") as? String
        capcity = defaults.value(forKey: "Capcity") as? String
        
        
    }
    
    func searchVenueListApi(){
            
        if !isCall
        {
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setObject(DataManager.getVal(self.userID), forKey: "user_id" as NSCopying)
            parameterDictionary.setValue(DataManager.getVal("venue"), forKey: "filter_type")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "search_keyword")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "sort")
            parameterDictionary.setValue(DataManager.getVal(10), forKey: "limit")
            parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "rating")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "distance")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "capacity")
            parameterDictionary.setValue(DataManager.getVal(str_lat), forKey: "lat")
            parameterDictionary.setValue(DataManager.getVal(str_long), forKey: "lng")
            print(parameterDictionary)

            let methodName = "filter"
            
            DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                if status == "0" {
                    self.APICall = false
                    self.removeAllOverlays()
                    self.response.removeAllObjects()
                    self.venueTableview.reloadData()
                }else{
                var arr_data = NSMutableArray()
                  arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                  self.APICall = true
                  if arr_data.count != 0 {
                  self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                  self.slooooooooooot = self.slooooooooooot + 10
                  arr_data.removeAllObjects()
                }
                  self.venueTableview.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if response.count>0
        {
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
            self.venueTableview.addSubview(venueRefreshControl)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VenueSearchCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.VenueImage.sd_setImage(with: URL(string: (dict.value(forKey: "venue_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        cell.venueName.text = dict.value(forKey: "venue_name") as? String
        cell.VenueAddress.text = dict.value(forKey: "address") as? String
        var rating1:Int!
        rating1 = dict.value(forKey: "rating") as? Int
        var rate = Float()
        rate = Float(rating1)
        cell.ratingview.rating = Float(truncating: NSNumber(value: rate))
        var ratingper:NSNumber!
        ratingper = dict.value(forKey: "rating_percentage") as? NSNumber
        cell.ratingper.text = ratingper.stringValue + "%"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        //venueId1 = dict.value(forKey: "id") as? String
        var venid:Int!
        venid = dict.value(forKey: "id") as? Int
        venueName1 = dict.value(forKey: "venue_name") as? String
        let defaults = UserDefaults.standard
        defaults.set(venid, forKey: "VenueID")
        defaults.set(venueName1, forKey: "VenueNam")
        defaults.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VenueDetailViewController") as! VenueDetailViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
            if ordertype == nil && sortorder ==  nil && apicall == nil {
//                Parsing().DiscoverSearchVenueFilter(UserId: userID, FilterType: "venue", SearchKeyword: SearchTxt.text, Sort: "", Limit: 10, Offset: slooooooooooot, Rating: rating, Distance: distance, Size: capcity, Lat: str_lat as String?, Long: str_long as String?)
//                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
//                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)

                self.searchVenueListApi()
            }else if apicall == "APICallVenue" {
                Parsing().DiscoverSearchVenueFilter(UserId: userID, FilterType: "venue", SearchKeyword: SearchTxt.text, Sort: "", Limit: 10, Offset: slooooooooooot, Rating: rating, Distance: distance, Size: capcity, Lat: str_lat as String?, Long: str_long as String?)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
            }else if apicall == "APINOTCall" {
                self.searchVenueListApi()
            }
            else {
                self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
                self.sortarray.add(self.dict)
                print(self.sortarray)
                let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
                print(typeIdArrayString)
                self.searchVenueListApi()
            }
        }
    }
    
    
    @IBAction func filterBtnAction(_ sender: Any) {
        var str:String!
        str = "APINOTCall"
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "APICALLVENUE")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "VenueFilterViewController") as! VenueFilterViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func sortBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        let nextview = VenueSortView.intitiateFromNib()
        let model = BackModel()
        nextview.buttonViewHighhandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW3") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchVenueFilter(UserId: self.userID, FilterType: "venue", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Distance: "", Size: "", Lat: self.str_lat as String?, Long: self.str_long as String?)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
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
            model.closewithAnimation()
        }
        nextview.buttonViewLowhandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW3") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchVenueFilter(UserId: self.userID, FilterType: "venue", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Distance: "", Size: "", Lat: self.str_lat as String?, Long: self.str_long as String?)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
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
            model.closewithAnimation()
        }
        nextview.buttonRatingHighhandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW3") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchVenueFilter(UserId: self.userID, FilterType: "venue", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Distance: "", Size: "", Lat: self.str_lat as String?, Long: self.str_long as String?)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
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
            model.closewithAnimation()
        }
        nextview.buttonRatingLowhandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW3") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchVenueFilter(UserId: self.userID, FilterType: "venue", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Distance: "", Size: "", Lat: self.str_lat as String?, Long: self.str_long as String?)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: nil)
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
            model.closewithAnimation()
        }
        model.show(view: nextview)
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
