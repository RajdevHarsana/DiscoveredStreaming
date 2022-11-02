//
//  EventSearchViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 10/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation

class EventSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UISearchBarDelegate {

    @IBOutlet weak var eventTbaleview: UITableView!
    @IBOutlet weak var SearchTxt: UISearchBar!
    
    @IBOutlet weak var songTypeLbl: UILabel!
    var response: NSMutableArray!
    var defaults:UserDefaults!
    var user_Id:Int!
    var Manager: CLLocationManager!
    var str_lat:String!
    var str_long:String!
    var isCall = Bool()
    var searchplace = String()
    
    var eventRefreshControl: UIRefreshControl!
    var searchTextField: UITextField? {
              let subViews = self.SearchTxt.subviews.first?.subviews.last?.subviews
              return subViews?.first as? UITextField
      }
    
    var ordertype:String!
    var sortorder:String!
    var sortarray = NSMutableArray()
    var dict = [String: Any]()
    
    var genre:String!
    var rating:Int!
    var viewers:Int!
    var strdate:String!
    var enddate:String!
    var Price:String!
    var apicall:String!
    var distance:String!
    var eventid:Int!
    var evntuserid:Int!
    var slooooooooooot = Int()
    var APICall = Bool()
    var type:String!
    //MARK:- Login WebService
//    @objc func DiscoverEventListAction(_ notification: Notification) {
//
//        let status = (notification.userInfo?["status"] as? Int)!
//        let str_message = (notification.userInfo?["message"] as? String)!
//
//        DispatchQueue.main.async() {
//            if status == 0{
//                self.APICall = false
//                self.removeAllOverlays()
//                self.eventTbaleview.reloadData()
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
//
//                print("response: \(String(describing: self.response))")
//                self.eventTbaleview.reloadData()
//                self.removeAllOverlays()
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
//                self.eventTbaleview.reloadData()
//
//            }
//            else{
//                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
//                print("response: \(String(describing: self.response))")
//                self.eventTbaleview.reloadData()
//                self.removeAllOverlays()
//
//            }
//        }
//    }
    
    @objc func DiscoverSongFilterAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.APICall = false
               // self.response.removeAllObjects()
                self.eventTbaleview.reloadData()
                
            }
            else{
                var arr_data = NSMutableArray()
                arr_data = (notification.userInfo?["data"] as? NSMutableArray)!
                self.APICall = true
                if arr_data.count != 0 {
//                    self.response.removeAllObjects()
                    self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                    self.slooooooooooot = self.slooooooooooot + 10
//                    arr_data.removeAllObjects()
                }
                print("response: \(String(describing: self.response))")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
                self.eventTbaleview.reloadData()
                self.removeAllOverlays()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
        if #available(iOS 10.0, *) {
            self.eventRefreshControl = UIRefreshControl()
            self.eventRefreshControl.tintColor = UIColor.systemPink
//            self.venueRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.eventRefreshControl.addTarget(self,action: #selector(self.refreshEventList),for: .valueChanged)
            self.eventTbaleview.addSubview(self.eventRefreshControl)
        }
        }
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        str_lat = defaults.value(forKey: "LAT") as? String
        str_long = defaults.value(forKey: "LONG") as? String
        response = NSMutableArray()
        defaults.removeObject(forKey: "BUTTONIMGEV1")
        defaults.removeObject(forKey: "BUTTONIMGEV2")
        defaults.removeObject(forKey: "BUTTONIMGEV3")
        defaults.removeObject(forKey: "BUTTONIMGEV4")
        defaults.removeObject(forKey: "BUTTONIMGEV5")
        defaults.removeObject(forKey: "BUTTONIMGEV6")
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
            print("Ashish")
            slooooooooooot = 0
            APICall = true
            response.removeAllObjects()
            searchEventListApi()
        }else {
          
        }
         NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("EventFilter"), object: nil)
        songTypeLbl.isHidden = true
//         NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("EventFilter"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshEventList(sender: UIRefreshControl) {
       // Code to refresh table view
        self.eventTbaleview.reloadData()
        self.eventRefreshControl.endRefreshing()
        self.slooooooooooot = 0
        self.searchEventListApi()
    }

    override func viewWillAppear(_ animated: Bool) {
//        defaults = UserDefaults.standard
//        apicall = defaults.value(forKey: "APICALLEVENT") as? String
//        Price = defaults.value(forKey: "Price") as? String
//        distance = defaults.value(forKey: "Distance") as? String
//        strdate = defaults.value(forKey: "STRDATE") as? String
//        enddate = defaults.value(forKey: "ENDDATE") as? String
//        apicall = defaults.value(forKey: "APICALLEVENT") as? String
//        genre = defaults.value(forKey: "GENER") as? String
//        if apicall == nil || apicall == "APINOTCall" {
//            print("Ashish")
//        }else {
//           NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("EventFilter"), object: nil)
//        }
    }

    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        apicall = defaults.value(forKey: "APICALLEVENT") as? String
        Price = defaults.value(forKey: "Price") as? String
        distance = defaults.value(forKey: "Distance1") as? String
        strdate = defaults.value(forKey: "STRDATE") as? String
        enddate = defaults.value(forKey: "ENDDATE") as? String
        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
        if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().DiscoverSearchEventFilter(UserId: user_Id, FilterType: "events", SearchKeyword: "", Sort: "", Limit: 10, Offset: slooooooooooot, Rating: "", Geners: "", Distance: distance, Price: Price, StartDate: strdate, EndDate: enddate, Lat: str_lat as String?, Long: str_long as String?)
             NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
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
            Parsing().DiscoverSearchEventFilter(UserId: user_Id, FilterType: "events", SearchKeyword: "", Sort: "", Limit: 10, Offset: slooooooooooot, Rating: "", Geners: "", Distance: "", Price: "", StartDate: "", EndDate: "", Lat: str_lat as String?, Long: str_long as String?)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
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
            Parsing().DiscoverSearchEventFilter(UserId: user_Id, FilterType: "events", SearchKeyword: SearchTxt.text, Sort: "", Limit: 10, Offset: slooooooooooot, Rating: "", Geners: "", Distance: "", Price: "", StartDate: "", EndDate: "", Lat: str_lat as String?, Long: str_long as String?)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
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
        self.searchEventListApi()
        self.eventTbaleview.reloadData()
        }
    }
    
    func searchEventListApi(){
            
        if !isCall
        {
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
            parameterDictionary.setValue(DataManager.getVal("events"), forKey: "filter_type")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "search_keyword")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "sort")
            parameterDictionary.setValue(DataManager.getVal(10), forKey: "limit")
            parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "rating")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "genres")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "distance")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "price")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "start_date")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "end_date")
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
                    self.eventTbaleview.reloadData()
                }else{
                var arr_data = NSMutableArray()
                  arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                  self.APICall = true
//                  self.response.removeAllObjects()
                  if arr_data.count != 0 {
                  self.response.removeAllObjects()
                  self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                  self.slooooooooooot = self.slooooooooooot + 10
//                  arr_data.removeAllObjects()
                }
                  self.eventTbaleview.reloadData()
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
            self.eventTbaleview.addSubview(eventRefreshControl)
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Events Found"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventSearchCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.EventImage.sd_setImage(with: URL(string: (dict.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        cell.EventNamnLbl.text = dict.value(forKey: "event_title") as? String
        cell.locationLbl.text = dict.value(forKey: "address") as? String
        var venueName = String()
        venueName = (dict.value(forKey: "event_title") as? String)!
        
        var dateTime = String()
        dateTime = (dict.value(forKey: "event_date") as? String)!
        
        var Time = String()
        Time = (dict.value(forKey: "event_time") as? String)!
        
        
        
        cell.venuenamedateTimeLbl.text = venueName + "  " + dateTime + "  " + Time
        
        var price = NSNumber()
        price = dict.value(forKey: "price_per_sit") as! NSNumber
       
       
        cell.priceLbl.text =  "$" + price.stringValue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
           if ordertype == nil && sortorder ==  nil && apicall == nil {
            self.searchEventListApi()
            }else if apicall == "APICallevent" {
            Parsing().DiscoverSearchEventFilter(UserId: user_Id, FilterType: "events", SearchKeyword: "", Sort: "", Limit: 10, Offset: slooooooooooot, Rating: "", Geners: "", Distance: distance, Price: Price, StartDate: strdate, EndDate: enddate, Lat: str_lat as String?, Long: str_long as String?)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
            }else if apicall == "APINOTCall" {
            self.searchEventListApi()
           }
           else {
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            self.searchEventListApi()
          }
        }
    }
    
    @IBAction func filterBtnAction(_ sender: Any) {
        var str:String!
        str = "APINOTCall"
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "APICALLEVENT")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "EventFilterViewController") as! EventFilterViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func sorrtBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        let nextview = EventSortView.intitiateFromNib()
        let model = BackModel()
        nextview.buttonPriceHighhandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW2") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchEventFilter(UserId: self.user_Id, FilterType: "events", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", Distance: "", Price: "", StartDate: "", EndDate: "", Lat: self.str_lat as String?, Long: self.str_long as String?)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
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
        nextview.buttonPriceLowhandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW2") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchEventFilter(UserId: self.user_Id, FilterType: "events", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", Distance: "", Price: "", StartDate: "", EndDate: "", Lat: self.str_lat as String?, Long: self.str_long as String?)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
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
        nextview.buttonDateHighhandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW2") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchEventFilter(UserId: self.user_Id, FilterType: "events", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", Distance: "", Price: "", StartDate: "", EndDate: "", Lat: self.str_lat as String?, Long: self.str_long as String?)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
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
        nextview.buttonDateLowhandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW2") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchEventFilter(UserId: self.user_Id, FilterType: "events", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", Distance: "", Price: "", StartDate: "", EndDate: "", Lat: self.str_lat as String?, Long: self.str_long as String?)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
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
        nextview.buttonDistanceHighhandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW2") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchEventFilter(UserId: self.user_Id, FilterType: "events", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", Distance: "", Price: "", StartDate: "", EndDate: "", Lat: self.str_lat as String?, Long: self.str_long as String?)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
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
        nextview.buttonDistanceLowhandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW2") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchEventFilter(UserId: self.user_Id, FilterType: "events", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", Distance: "", Price: "", StartDate: "", EndDate: "", Lat: self.str_lat as String?, Long: self.str_long as String?)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: nil)
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

   
}
