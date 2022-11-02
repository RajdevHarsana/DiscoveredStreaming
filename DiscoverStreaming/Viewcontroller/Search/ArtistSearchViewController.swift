//
//  ArtistSearchViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 10/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation

class ArtistSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var artistTableview: UITableView!
    
    @IBOutlet weak var SearchTxt: UISearchBar!
    @IBOutlet weak var songTypeLbl: UILabel!
    var response = NSMutableArray()
    var defaults:UserDefaults!
    var userId:Int!
    var searchplace = String()
    
    var artistRefreshControl: UIRefreshControl!
    var searchTextField: UITextField? {
            let subViews = self.SearchTxt.subviews.first?.subviews.last?.subviews
            return subViews?.first as? UITextField
    }
    
    var ordertype:String!
    var sortorder:String!
    var sortarray = NSMutableArray()
    var dict = [String: Any]()
    var type:String!
    var genre:String!
    var rating:String!
    var viewers:String!
    var songtype:String!
    var apicall:String!
    var distance:String!
    var anyallsts:Int!
    var saveValue:String!
    var ArtistId:Int!
    var ArtistUserId:Int!
    var artistName:String!
    
    var str_lat:String!
    var str_long:String!
    var Manager: CLLocationManager!
    var isCall = Bool()
    var slooooooooooot = Int()
    var APICall = Bool()
    var genAr:String!
    //MARK:- Login WebService
    @objc func DiscoverArtistListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                 self.APICall = false
                self.removeAllOverlays()
                self.artistTableview.reloadData()
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
                //print("response: \(String(describing: self.response))")
                self.artistTableview.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    @objc func DiscoverSongSearchFilterSortAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.APICall = false
               // self.response.removeAllObjects()
                self.artistTableview.reloadData()
                
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
               // self.response = (notification.userInfo?["data"] as? NSMutableArray)!
               // print("response: \(String(describing: self.response))")
                self.artistTableview.reloadData()
                self.removeAllOverlays()
                
            }
        }
    }
    
    @objc func DiscoverSongFilterAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.APICall = false
               // self.response.removeAllObjects()
                self.artistTableview.reloadData()
                
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
              NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
                self.artistTableview.reloadData()
                self.removeAllOverlays()
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        if #available(iOS 10.0, *) {
            self.artistRefreshControl = UIRefreshControl()
            self.artistRefreshControl.tintColor = UIColor.systemPink
//            self.venueRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.artistRefreshControl.addTarget(self,action: #selector(self.refreshArtistList),for: .valueChanged)
            self.artistTableview.addSubview(self.artistRefreshControl)
        }
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        str_lat = defaults.value(forKey: "LAT") as? String
        str_long = defaults.value(forKey: "LONG") as? String
        defaults.removeObject(forKey: "BUTTONIMGAR1")
        defaults.removeObject(forKey: "BUTTONIMGAR2")
        defaults.removeObject(forKey: "BUTTONIMGAR3")
        defaults.removeObject(forKey: "BUTTONIMGAR4")
        defaults.removeObject(forKey: "BUTTONIMGAR5")
        defaults.removeObject(forKey: "BUTTONIMGAR6")
        apicall = defaults.value(forKey: "APICALLAR") as? String
        genre = defaults.value(forKey: "GENER") as? String
        viewers = defaults.value(forKey: "Viws") as? String
        distance =  defaults.value(forKey: "Disatnce2") as? String
        rating = defaults.value(forKey: "Rating2") as? String
        anyallsts = defaults.integer(forKey: "ANYALLSTS")
        saveValue = defaults.value(forKey: "FilterValue1") as? String

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
    if saveValue == "savevalue"{
       // Nothing happen
    }else{
        if apicall == nil || apicall == "APINOTCall" {
        songTypeLbl.isHidden = true
        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
        searchArtistListApi()
        }else {
        // NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("SongFilter"), object: nil)
         
        }
        
    }
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("ArtistFilter"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func refreshArtistList(sender: UIRefreshControl) {
       // Code to refresh table view
        self.artistTableview.reloadData()
        self.artistRefreshControl.endRefreshing()
        self.slooooooooooot = 0
        self.response.removeAllObjects()
        self.searchArtistListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        defaults = UserDefaults.standard
//        apicall = defaults.value(forKey: "APICALLAR") as? String
//        genre = defaults.value(forKey: "GENER") as? String
//        viewers = defaults.value(forKey: "Viws") as? String
//        distance =  defaults.value(forKey: "Disatnce") as? String
//        rating = defaults.value(forKey: "Rating") as? String
//        anyallsts = defaults.integer(forKey: "ANYALLSTS")
//
//        if genre == "[]" {
//            print("Ashish")
//            genAr = ""
//        }else {
//            genAr = genre
//        }
//
//
//        if apicall == nil || apicall == "APINOTCall" {
//
//        }else {
//
//
//        }
        
    }
    
    func searchArtistListApi(){
            
        if !isCall
        {
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setObject(DataManager.getVal(self.userId), forKey: "user_id" as NSCopying)
            parameterDictionary.setValue(DataManager.getVal("artists"), forKey: "filter_type")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "search_keyword")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "sort")
            parameterDictionary.setValue(DataManager.getVal(10), forKey: "limit")
            parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "rating")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "genres")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "views")
            parameterDictionary.setValue(DataManager.getVal(anyallsts), forKey: "include_genres")
            parameterDictionary.setValue(DataManager.getVal(str_lat), forKey: "lat")
            parameterDictionary.setValue(DataManager.getVal(str_long), forKey: "lng")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "distance")
            print(parameterDictionary)

            let methodName = "filter"
            
            DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                if status == "0" {
                    self.APICall = false
                    self.removeAllOverlays()
//                    self.response.removeAllObjects()
                    self.artistTableview.reloadData()
                }else{
                var arr_data = NSMutableArray()
                  arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                  self.APICall = true
                  if arr_data.count != 0 {
                  self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                  self.slooooooooooot = self.slooooooooooot + 10
                  arr_data.removeAllObjects()
                }
                  self.artistTableview.reloadData()
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
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        apicall = defaults.value(forKey: "APICALLAR") as? String
        genre = defaults.value(forKey: "GENER") as? String
        viewers = defaults.value(forKey: "Viws") as? String
        distance =  defaults.value(forKey: "Disatnce2") as? String
        rating = defaults.value(forKey: "Rating2") as? String
        anyallsts = defaults.integer(forKey: "ANYALLSTS")
        saveValue = defaults.value(forKey: "FilterValue1") as? String
        
        if genre == "[]" {
            print("Ashish")
            genAr = ""
        }else {
            genAr = genre
        }
        
        slooooooooooot = 0
        //APICall = true
        
        showWaitOverlay()
        //            Parsing().DiscoverSearchSongFilter1(UserId: userId, FilterType: "artists", SearchKeyword: "", Sort: "", Limit: 10, Offset: slooooooooooot, Rating: rating, Geners: genAr, StrDate: "", EndDate: "", Views: viewers, SongType: "", AnyAllSts: anyallsts, Lat: str_lat as String?, Long: str_long as String?, Distance: distance)
        //              NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
        //            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.userId), forKey: "user_id" as NSCopying)
        parameterDictionary.setValue(DataManager.getVal("artists"), forKey: "filter_type")
        parameterDictionary.setValue(DataManager.getVal(""), forKey: "search_keyword")
        parameterDictionary.setValue(DataManager.getVal(""), forKey: "sort")
        parameterDictionary.setValue(DataManager.getVal(10), forKey: "limit")
        parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
        parameterDictionary.setValue(DataManager.getVal(rating), forKey: "rating")
        parameterDictionary.setValue(DataManager.getVal(genAr), forKey: "genres")
        parameterDictionary.setValue(DataManager.getVal(viewers), forKey: "views")
        parameterDictionary.setValue(DataManager.getVal(anyallsts), forKey: "include_genres")
        parameterDictionary.setValue(DataManager.getVal(str_lat), forKey: "lat")
        parameterDictionary.setValue(DataManager.getVal(str_long), forKey: "lng")
        parameterDictionary.setValue(DataManager.getVal(distance), forKey: "distance")
        print(parameterDictionary)
        
        let methodName = "filter"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                //let message = DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                if status == "1" {
                    var arr_data = NSMutableArray()
                    arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                    //self.APICall = true
                    if arr_data.count != 0 {
                        self.response.removeAllObjects()
                        self.response = arr_data
                        self.slooooooooooot = self.slooooooooooot + 10
//                        arr_data.removeAllObjects()
                    }
                    self.artistTableview.reloadData()
                    self.removeAllOverlays()
                }else{
                    print("data nhi aayega ")
                    self.APICall = false
                    self.removeAllOverlays()
                    self.response.removeAllObjects()
                    self.artistTableview.reloadData()
                }
                self.removeAllOverlays()
            })
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
                Parsing().DiscoverSearchSongFilter1(UserId: userId, FilterType: "artists", SearchKeyword: "", Sort: "", Limit: 10, Offset: slooooooooooot, Rating: "", Geners: "", Views: "", AnyAllSts: anyallsts, Lat: str_lat as String?, Long: str_long as String?, Distance: "")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
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
                Parsing().DiscoverSearchSongFilter1(UserId: userId, FilterType: "artists", SearchKeyword: SearchTxt.text, Sort: "", Limit: 10, Offset: slooooooooooot, Rating: "", Geners: "", Views: "", AnyAllSts: anyallsts, Lat: str_lat as String?, Long: str_long as String?, Distance: "")
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
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
        self.searchArtistListApi()
        self.artistTableview.reloadData()
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
            self.artistTableview.addSubview(artistRefreshControl)
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Record Found"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArtistsSearchCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        print(dict)
        cell.ArtistNameLbl.text = dict.value(forKey: "name") as? String
        cell.ArtistImage.layer.cornerRadius = 5
        cell.ArtistImage.sd_setImage(with: URL(string: (dict.value(forKey: "image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        var Genre = String()
        Genre = dict.value(forKey: "genres") as! String
        cell.GenreLbl.text =  Genre
        var dis = String()
        dis = dict.value(forKey: "distance") as! String
        cell.distanceLbl.text =  dis

        var viewCount = String()
        viewCount =  (dict.value(forKey: "viewer") as? String)!
        
        var rateper = String()
        rateper =  (dict.value(forKey: "rating_percentage") as? String)!
        
//        var rate = String()
//        rate = String(rateper)
        
        cell.RatingPer.text =  rateper + "%"
        
       // let viewCountStr = String(viewCount)
        cell.ViewLbl.text =  viewCount + "  Views"
        
        var rating = String()
        rating = dict.value(forKey: "rating") as! String
        var rat:Float!
        rat = Float(rating)
        
        cell.RatingView.rating = Float(truncating: rat! as NSNumber)
        
        var DateType:String!
        DateType =  dict.value(forKey: "data_type") as? String
        
        if DateType  == "1" {
            cell.artistlbl.text = "Band"
        }else {
             cell.artistlbl.text = "Artist"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        var arid:String!
        arid = dict.value(forKey: "artist_id") as? String
        
        var aruserid:String!
        aruserid = dict.value(forKey: "user_id") as? String
        
        ArtistId = Int(arid)
        ArtistUserId = Int(aruserid)
        artistName = dict.value(forKey: "name") as? String
        let defaults = UserDefaults.standard
        defaults.set(ArtistId, forKey: "ArtistID")
        defaults.set(ArtistUserId, forKey: "ArUserId")
        defaults.set(artistName, forKey: "ArName")
        defaults.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArtistDetailViewController") as! ArtistDetailViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
            if ordertype == nil && sortorder ==  nil && apicall == nil {
                showWaitOverlay()
                Parsing().DiscoverSearchSongFilter1(UserId: userId, FilterType: "artists", SearchKeyword: "", Sort: "", Limit: 10, Offset: slooooooooooot, Rating: "", Geners: "", Views: "", AnyAllSts: anyallsts, Lat: str_lat as String?, Long: str_long as String?, Distance: "")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)

            } else if apicall == "APICallArtist" {
                showWaitOverlay()
                Parsing().DiscoverSearchSongFilter1(UserId: userId, FilterType: "artists", SearchKeyword: "", Sort: "", Limit: 10, Offset: slooooooooooot, Rating: rating, Geners: genAr, Views: viewers, AnyAllSts: anyallsts, Lat: str_lat as String?, Long: str_long as String?, Distance: distance)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)

            } else if apicall == "APINOTCall" {
                showWaitOverlay()
                Parsing().DiscoverSearchSongFilter1(UserId: userId, FilterType: "artists", SearchKeyword: "", Sort: "", Limit: 10, Offset: slooooooooooot, Rating: "", Geners: "", Views: "", AnyAllSts: anyallsts, Lat: str_lat as String?, Long: str_long as String?, Distance: "")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)

            }
            else {
                self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
                self.sortarray.add(self.dict)
                print(self.sortarray)
                let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
                print(typeIdArrayString)
                showWaitOverlay()
                Parsing().DiscoverSearchSongFilter1(UserId: userId, FilterType: "artists", SearchKeyword: "", Sort: "", Limit: 10, Offset: slooooooooooot, Rating: "", Geners: "", Views: "", AnyAllSts: anyallsts, Lat: str_lat as String?, Long: str_long as String?, Distance: "")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)

            }
        }
    }
   
    @IBAction func filterBtnAction(_ sender: Any) {
        var str:String!
        str = "APINOTCall"
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "APICALLAR")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "ArtistFilterViewController") as! ArtistFilterViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func sortBtnAction(_ sender: Any) {
           self.view.endEditing(true)
        let nextview = ArtistSortview.intitiateFromNib()
        let model = BackModel()
        nextview.buttonViewsHighhandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW1") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchSongFilter1(UserId: self.userId, FilterType: "artists", SearchKeyword: "", Sort:typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", Views: "", AnyAllSts: self.anyallsts, Lat: self.str_lat as String?, Long: self.str_long as String?, Distance: "")
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
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
        nextview.buttonViewsLowhandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW1") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchSongFilter1(UserId: self.userId, FilterType: "artists", SearchKeyword: "", Sort:typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", Views: "", AnyAllSts: self.anyallsts, Lat: self.str_lat as String?, Long: self.str_long as String?, Distance: "")
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
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
            self.type = self.defaults.value(forKey: "TYPEVIEW1") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchSongFilter1(UserId: self.userId, FilterType: "artists", SearchKeyword: "", Sort:typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", Views: "", AnyAllSts: self.anyallsts, Lat: self.str_lat as String?, Long: self.str_long as String?, Distance: "")
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
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
            self.type = self.defaults.value(forKey: "TYPEVIEW1") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchSongFilter1(UserId: self.userId, FilterType: "artists", SearchKeyword: "", Sort:typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", Views: "", AnyAllSts: self.anyallsts, Lat: self.str_lat as String?, Long: self.str_long as String?, Distance: "")
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
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
            self.type = self.defaults.value(forKey: "TYPEVIEW1") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchSongFilter1(UserId: self.userId, FilterType: "artists", SearchKeyword: "", Sort:typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", Views: "", AnyAllSts: self.anyallsts, Lat: self.str_lat as String?, Long: self.str_long as String?, Distance: "")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
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
            self.type = self.defaults.value(forKey: "TYPEVIEW1") as? String
            self.songTypeLbl.isHidden = false
            self.songTypeLbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                self.showWaitOverlay()
                Parsing().DiscoverSearchSongFilter1(UserId: self.userId, FilterType: "artists", SearchKeyword: "", Sort:typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", Views: "", AnyAllSts: self.anyallsts, Lat: self.str_lat as String?, Long: self.str_long as String?, Distance: "")
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: nil)
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
