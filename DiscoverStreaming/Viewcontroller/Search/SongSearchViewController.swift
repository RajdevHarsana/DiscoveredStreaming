//
//  SongSearchViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 10/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation
import AVFoundation

class SongSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,CLLocationManagerDelegate,AVAudioPlayerDelegate {
   
    @IBOutlet weak var songTableview: UITableView!
    
    var defaults:UserDefaults!
    var user_Id:Int!
    var response = NSMutableArray()
    var searchplace = String()
    var ordertype:String!
    var sortorder:String!
    var sortarray = NSMutableArray()
    var dict = [String: Any]()
    @IBOutlet weak var SearchTxt: UISearchBar!
    @IBOutlet weak var sortTypelbl: UILabel!
    
    var myCustomView: PlayerView?
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var dataArray = [Any]()
    var updateTimer = Timer()
    var likeSts:Int!
    var likeCount:Int!
    var UnlikeSts:Int!
    var UnlikeCount:Int!
    var audioPlayer = AVAudioPlayer()
    var selectedMusic = 0
    var SongID:Int!
    var currentAudioPath:URL!
    
     var searchTextField: UITextField? {
         let subViews = self.SearchTxt.subviews.first?.subviews.last?.subviews
         return subViews?.first as? UITextField
     }
     
    var songRefreshControl: UIRefreshControl!
    var genre:String!
    var rating:String!
    var viewers:String!
    var distance:String!
    var strdate:String!
    var enddate:String!
    var songtype:String!
    var apicall:String!
    var anyallsts:Int!
    var type:String!
    var str_lat:String!
    var str_long:String!
    var Manager: CLLocationManager!
    var isCall = Bool()
    var slooooooooooot = Int()
    var APICall = Bool()
    var totalSongs = Int()
    var genAr:String!
     let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SongSearchViewController.dismissView))

    
//    @objc func DiscoverSongSearchFilterSortAction(_ notification: Notification) {
//
//        let status = (notification.userInfo?["status"] as? Int)!
//        let str_message = (notification.userInfo?["message"] as? String)!
//
//        DispatchQueue.main.async() {
//            if status == 0{
//                self.APICall = false
//                self.removeAllOverlays()
//                self.songTableview.reloadData()
//                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchFilterSort"), object: nil)
//            }
//            else{
//
//                var arr_data = NSMutableArray()
//                arr_data = (notification.userInfo?["data"] as? NSMutableArray)!
//                self.APICall = true
//                if arr_data.count != 0 {
//                    self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
//                    self.slooooooooooot = self.slooooooooooot + 10
//                    arr_data.removeAllObjects()
//                }
//                self.songTableview.reloadData()
//                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchFilterSort"), object: nil)
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
                 self.APICall = false
                self.removeAllOverlays()
//                self.response.removeAllObjects()
                self.songTableview.reloadData()
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
            }
            else{
               
                var arr_data = NSMutableArray()
                arr_data = (notification.userInfo?["data"] as? NSMutableArray)!
                self.APICall = true
//                self.response.removeAllObjects()
                if arr_data.count != 0 {
                    self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                    self.slooooooooooot = self.slooooooooooot + 10
                    arr_data.removeAllObjects()
                }
               
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
                 self.songTableview.reloadData()
                self.removeAllOverlays()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        if #available(iOS 10.0, *) {
            self.songRefreshControl = UIRefreshControl()
            self.songRefreshControl.tintColor = UIColor.systemPink
//            self.venueRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.songRefreshControl.addTarget(self,action: #selector(self.refreshSongList),for: .valueChanged)
            self.songTableview.addSubview(self.songRefreshControl)
        }
        

        
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        str_lat = defaults.value(forKey: "LAT") as? String
        str_long = defaults.value(forKey: "LONG") as? String
        
          defaults.removeObject(forKey: "BUTTONIMG1")
          defaults.removeObject(forKey: "BUTTONIMG2")
          defaults.removeObject(forKey: "BUTTONIMG3")
          defaults.removeObject(forKey: "BUTTONIMG4")
          defaults.removeObject(forKey: "BUTTONIMG5")
          defaults.removeObject(forKey: "BUTTONIMG6")
        
        
        SearchTxt.delegate = self
       if #available(iOS 13.0, *) {
           searchTextField?.placeholder = "Search..."
           self.searchTextField?.textAlignment = NSTextAlignment.left
           searchTextField?.textColor = UIColor.white
           searchTextField?.backgroundColor = UIColor.clear
           searchTextField?.borderStyle = .none
           searchTextField?.clearButtonMode = .never
           searchTextField?.textAlignment = NSTextAlignment.left
       } else {
       let searchfield = self.SearchTxt.subviews[0].subviews.last as! UITextField
           searchfield.placeholder = " Search..."
           searchfield.textColor = UIColor.white
           searchfield.backgroundColor = UIColor.clear
           searchfield.borderStyle = .none
           searchfield.clearButtonMode = .never
           searchfield.textAlignment = NSTextAlignment.left
       }
        
        apicall = defaults.value(forKey: "APICALL") as? String
        viewers = defaults.value(forKey: "Viws3") as? String
        rating = defaults.value(forKey: "Rating3") as? String
        distance = defaults.value(forKey: "Distance3") as? String
        genre = defaults.value(forKey: "GENER") as? String
        strdate = defaults.value(forKey: "STRDATE") as? String
        enddate = defaults.value(forKey: "ENDDATE") as? String
        songtype = defaults.value(forKey: "SONGTY") as? String
        anyallsts = defaults.integer(forKey: "ANYALLSTS")
        ordertype = defaults.value(forKey: "ORDERTYPE") as? String
        sortorder = defaults.value(forKey: "SORTORDER") as? String
        
//        if apicall == nil || apicall == "APINOTCall" {
//        slooooooooooot = 0
//        APICall = true
//        response.removeAllObjects()
//        searchSongListApi()
//        }else {
         NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("SongFilter"), object: nil)
            
       // }
        if apicall == nil || apicall == "APINOTCall" {
        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
        searchSongListApi()
        }else {
        // NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("SongFilter"), object: nil)
            
        }
        
       
        self.sortTypelbl.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @objc func refreshSongList(sender: UIRefreshControl) {
       // Code to refresh table view
        self.songTableview.reloadData()
        self.songRefreshControl.endRefreshing()
        self.searchSongListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        defaults = UserDefaults.standard
        apicall = defaults.value(forKey: "APICALL") as? String
        viewers = defaults.value(forKey: "Viws3") as? String
        rating = defaults.value(forKey: "Rating3") as? String
        distance = defaults.value(forKey: "Distance3") as? String
        genre = defaults.value(forKey: "GENER") as? String
        strdate = defaults.value(forKey: "STRDATE") as? String
        enddate = defaults.value(forKey: "ENDDATE") as? String
        songtype = defaults.value(forKey: "SONGTY") as? String
        anyallsts = defaults.integer(forKey: "ANYALLSTS")
        ordertype = defaults.value(forKey: "ORDERTYPE") as? String
        sortorder = defaults.value(forKey: "SORTORDER") as? String
        
    }
    
    func searchSongListApi(){
            
        if !isCall
        {
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
            parameterDictionary.setValue(DataManager.getVal("songs"), forKey: "filter_type")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "search_keyword")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "sort")
            parameterDictionary.setValue(DataManager.getVal(10), forKey: "limit")
            parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "rating")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "genres")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "start_date")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "end_date")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "views")
            parameterDictionary.setValue(DataManager.getVal(""), forKey: "song_type")
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
                    self.response.removeAllObjects()
                    self.songTableview.reloadData()
                }else{
                var arr_data = NSMutableArray()
                  arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                  self.APICall = true
                  if arr_data.count != 0 {
                  self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                  self.slooooooooooot = self.slooooooooooot + 10
                  arr_data.removeAllObjects()
                }
                  self.songTableview.reloadData()
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
        apicall = defaults.value(forKey: "APICALL") as? String
        viewers = defaults.value(forKey: "Viws3") as? String
        rating = defaults.value(forKey: "Rating3") as? String
        distance = defaults.value(forKey: "Distance3") as? String
        genre = defaults.value(forKey: "GENER") as? String
        strdate = defaults.value(forKey: "STRDATE") as? String
        enddate = defaults.value(forKey: "ENDDATE") as? String
        songtype = defaults.value(forKey: "SONGTY") as? String
        anyallsts = defaults.integer(forKey: "ANYALLSTS")
        
        if genre == "[]" {
            print("Ashish")
            genAr = ""
        }else {
            genAr = genre
        }
        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
//        if Reachability.isConnectedToNetwork() == true {
            var str = String()
            if songtype == nil {
                str =  ""
            }else {
                str = songtype
            }          
            showWaitOverlay()
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
            parameterDictionary.setValue(DataManager.getVal("songs"), forKey: "filter_type")
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
            parameterDictionary.setValue(DataManager.getVal(str), forKey: "song_type")
            
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
                        self.songTableview.reloadData()
                        self.removeAllOverlays()
                    }else{
                        print("data nhi aayega ")
                        self.APICall = false
                        self.removeAllOverlays()
                        self.response.removeAllObjects()
                        self.songTableview.reloadData()
                    }
                    self.removeAllOverlays()
                })
            }
//        }else {
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
//            self.response.removeAllObjects()
//        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
        
        searchBar.resignFirstResponder()
        if SearchTxt.text == "" {
            if Reachability.isConnectedToNetwork() == true{
                var str = String()
                if songtype == nil {
                    str =  ""
                }else {
                    str = songtype
                }
                showWaitOverlay()
                Parsing().DiscoverSearchSongFilter(UserId: user_Id, FilterType: "songs", SearchKeyword: "", Sort: "", Limit: 10, Offset: slooooooooooot, Rating: "", Geners: "", StrDate: "", EndDate: "", Views: "", SongType: "", AnyAllSts: anyallsts, Lat: str_lat as String?, Long: str_long as String?, Distance: "")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
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
                var str = String()
                if songtype == nil {
                    str =  ""
                }else {
                    str = songtype
                }
                showWaitOverlay()
                Parsing().DiscoverSearchSongFilter(UserId: user_Id, FilterType: "songs", SearchKeyword: SearchTxt.text, Sort: "", Limit: 10, Offset: slooooooooooot, Rating: "", Geners: "", StrDate: "", EndDate: "", Views: "", SongType: "", AnyAllSts: anyallsts, Lat: str_lat as String?, Long: str_long as String?, Distance: "")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
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
        searchBar.resignFirstResponder()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchplace = searchText
        if searchplace == ""{
        self.slooooooooooot = 0
        self.response.removeAllObjects()
        self.searchSongListApi()
        self.songTableview.reloadData()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.myCustomView?.NewSongTblView {
            return self.dataArray.count
        }else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.myCustomView?.NewSongTblView{
            return 60
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == songTableview{
            return response.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.myCustomView?.NewSongTblView{
            let dict = DataManager.getVal(self.dataArray[section]) as! NSDictionary
            let image = DataManager.getVal(dict["song_image"]) as? String ?? ""
            let artistName = DataManager.getVal(dict["as_type_name"]) as? String ?? ""
            let songName = DataManager.getVal(dict["song_name"]) as? String ?? ""
            let header = UIView()
            header.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 60)
            header.backgroundColor = UIColor.red
            
            let sngImg = UIImageView()
            sngImg.frame = CGRect(x: 8, y: 8, width: 44, height: 44)
            sngImg.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "Group 4-1"))
            header.addSubview(sngImg)
            
            let moreBtn = UIButton()
            moreBtn.frame = CGRect(x: screenWidth-52, y: 8, width: 44, height: 44)
            let Moreimage = UIImage(named: "more_icon")
            moreBtn.setImage(Moreimage, for: .normal)
            header.addSubview(moreBtn)
            
            let downloadBtn = UIButton()
            downloadBtn.frame = CGRect(x: screenWidth-104, y: 8, width: 44, height: 44)
            let Downimage = UIImage(named: "download_icon_bg")
            downloadBtn.setImage(Downimage, for: .normal)
            header.addSubview(downloadBtn)
            
            let titleLbl = UILabel()
            titleLbl.frame = CGRect(x: 60, y: 8, width: screenWidth-172, height: 20)
            titleLbl.text = songName
            titleLbl.textColor = UIColor.white
            header.addSubview(titleLbl)
            
            let titleLbl1 = UILabel()
            titleLbl1.frame = CGRect(x: 60, y: 30, width: screenWidth-172, height: 18)
            titleLbl1.text = artistName
            titleLbl1.textColor = UIColor.white
            header.addSubview(titleLbl1)
            
            let headerButton = UIButton()
            headerButton.frame = CGRect(x: 0, y: 0, width: screenWidth-104, height: 60)
            headerButton.tag = section
            headerButton.addTarget(self, action: #selector(headerButtonAction), for: .touchUpInside)
            
            
            header.addSubview(headerButton)
            return header
        }else{
            return nil
        }
    }
    
    @objc func headerButtonAction(_ sender: UIButton){
        print("Tap on Header")
        let musicPlay = sender.tag
        let dict = DataManager.getVal(self.dataArray[musicPlay]) as! NSDictionary
        print(dict)
        let artistName = DataManager.getVal(dict["as_type_name"]) as? String ?? ""
        let songName = DataManager.getVal(dict["song_name"]) as? String ?? ""
        let songimg = DataManager.getVal(dict["song_image"]) as? String ?? ""
        let song_file = DataManager.getVal(dict["song_file"]) as? String ?? ""
        let duration = DataManager.getVal(dict["duration"]) as? String ?? ""
        let like_unlike_status = DataManager.getVal(dict["like_unlike_status"]) as? String ?? ""
        let favouriteStatus = DataManager.getVal(dict["favouriteStatus"]) as? String ?? ""
        let total_likes = DataManager.getVal(dict["total_likes"]) as? String ?? ""
        let total_unlikes = DataManager.getVal(dict["total_unlikes"]) as? String ?? ""
        self.myCustomView?.LikeCountLbl.text = total_likes
        self.myCustomView?.DislikeCountLbl.text = total_unlikes
        if like_unlike_status == "1"{
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs_up"), for: .normal)
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs_down"), for: .normal)
        }else {
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
        }
        
        if favouriteStatus == "1"{
            self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart-1"), for: .normal)
        }else{
            self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart"), for: .normal)
        }
        //Mini View
        self.myCustomView?.ArtistNameLbl.text = artistName
        self.myCustomView?.MiniSongNameLbl.text = songName
        
        self.myCustomView?.MiniImgView.sd_setImage(with: URL(string: songimg), placeholderImage: UIImage(named: "Group 4-1"))
        
        self.myCustomView?.BottomSongNameLbl.text = songName
        self.myCustomView?.BottomArtistNameLbl.text = artistName
        self.myCustomView?.MaximumTimeLbl.text = duration
        
        self.myCustomView?.BottomImgView.sd_setImage(with: URL(string: songimg), placeholderImage: UIImage(named: "Group 4-1"))
        
        let vc =  song_file.replacingOccurrences(of: " ", with: "")
        let AddPicture_url = URL.init(string: vc)
        print(AddPicture_url!)
        self.currentAudioPath = AddPicture_url
        
        self.downloadFileFromURL3(url: self.currentAudioPath as NSURL)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SongSearchCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.SongNameLbl.text = dict.value(forKey: "song_name") as? String
        cell.songImage.sd_setImage(with: URL(string: (dict.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        cell.artistNameLbl.text = dict.value(forKey: "as_type_name") as? String
        var Genre = String()
        Genre = dict.value(forKey: "genres") as! String
        cell.songDesLbl.text =  "Genres:" + " " + Genre
        var viewCount:Int!
        viewCount =  dict.value(forKey: "viewer") as? Int
        
        var dis:String!
        dis = dict.value(forKey: "distance") as? String
        cell.distanceLbl.text =  dis + " Miles"
        
        var rateper:Int!
        rateper =  dict.value(forKey: "rating_percentage") as? Int
        
        var rate = String()
        rate = String(rateper)
        
        cell.ratingperLbl.text =  rate + "%"
        
        let viewCountStr = String(viewCount)
        cell.viewLbl.text =  viewCountStr + "  Views"
        cell.TimeLbl.text = dict.value(forKey: "Duration") as? String
        
        var rating: NSNumber!
        rating = dict.value(forKey: "rating") as? NSNumber
        
        cell.ratingview.rating = Float(truncating: rating)
        
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = DataManager.getVal(self.response[indexPath.row]) as! NSDictionary
        print(dict)
        self.dataArray = self.response as! [Any]
        let artistName = DataManager.getVal(dict["as_type_name"]) as? String ?? ""
        let songName = DataManager.getVal(dict["song_name"]) as? String ?? ""
        let songimg = DataManager.getVal(dict["song_image"]) as? String ?? ""
        let song_file = DataManager.getVal(dict["song_file"]) as? String ?? ""
        let duration = DataManager.getVal(dict["duration"]) as? String ?? ""
        let songid = DataManager.getVal(dict["id"]) as? String ?? ""
        let like_unlike_status = DataManager.getVal(dict["like_unlike_status"]) as? String ?? ""
        let favouriteStatus = DataManager.getVal(dict["favouriteStatus"]) as? String ?? ""
        let total_likes = DataManager.getVal(dict["total_likes"]) as? String ?? ""
        let total_unlikes = DataManager.getVal(dict["total_unlikes"]) as? String ?? ""
        self.myCustomView?.LikeCountLbl.text = total_likes
        self.myCustomView?.DislikeCountLbl.text = total_unlikes
        if like_unlike_status == "1"{
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs_up"), for: .normal)
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
        }else {
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs_down"), for: .normal)
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
        }
        
        if favouriteStatus == "1"{
            self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart-1"), for: .normal)
        }else{
            self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart"), for: .normal)
        }
        
        self.SongID = Int(songid) ?? 0
        self.selectedMusic = indexPath.row
        //            self.SongListAPi(songType:"hot_music")
        let vc =  song_file.replacingOccurrences(of: " ", with: "")
        let AddPicture_url = URL.init(string: vc)
        print(AddPicture_url!)
        self.currentAudioPath = AddPicture_url
        
        var windowz = UIApplication.shared.windows
        windowz.removeLast()
        self.myCustomView?.removeFromSuperview() // code 1
        self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
        self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-90, width: self.screenWidth, height: 60)
        self.myCustomView?.BottomView.isHidden = true
        
        //Mini View
        self.myCustomView?.MiniViewHeightConstraint.constant = 60
        self.myCustomView?.ArtistNameLbl.text = artistName
        self.myCustomView?.MiniSongNameLbl.text = songName
        
        self.myCustomView?.MiniImgView.sd_setImage(with: URL(string: songimg), placeholderImage: UIImage(named: "Group 4-1"))
        //Bottom View
        self.myCustomView?.BottomSongNameLbl.text = songName
        self.myCustomView?.BottomArtistNameLbl.text = artistName
        self.myCustomView?.MaximumTimeLbl.text = duration
        
        self.myCustomView?.BottomImgView.sd_setImage(with: URL(string: songimg), placeholderImage: UIImage(named: "Group 4-1"))
        
        self.downloadFileFromURL3(url:currentAudioPath! as NSURL)
        
        
        self.myCustomView?.BigButton.addTarget(self, action: #selector(BigButtonAction), for: .touchUpInside)
        self.myCustomView?.PlayButton.addTarget(self, action: #selector(PlayButtonAction), for: .touchUpInside)
        self.myCustomView?.CrossButton.addTarget(self, action: #selector(CrossButtonAction), for: .touchUpInside)
        self.myCustomView?.SongSlider.addTarget(self, action: #selector(SliderAction), for: .touchUpInside)
        
        self.myCustomView?.PreviousButton.addTarget(self, action: #selector(PreviousButtonAction), for: .touchUpInside)
        self.myCustomView?.PauseAndPlayButton.addTarget(self, action: #selector(PauseAndPlayButtonAction), for: .touchUpInside)
        self.myCustomView?.NextButton.addTarget(self, action: #selector(NextButtonAction), for: .touchUpInside)
        self.myCustomView?.Like_btn.addTarget(self, action: #selector(LikeSongAction), for: .touchUpInside)
        self.myCustomView?.Dislike_btn.addTarget(self, action: #selector(DislikeSongAction), for: .touchUpInside)
        self.myCustomView?.Fav_btn.addTarget(self, action: #selector(FavSongAction), for: .touchUpInside)
        
        self.view.window?.addSubview(self.myCustomView!)
    }
    
    // MARK: - Custtom view Action
    
    @objc func BigButtonAction(_ sender: UIButton){
        print("Big Button")
        self.myCustomView!.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: screenHeight)
        self.myCustomView?.MiniView.isHidden = true
        self.myCustomView?.MiniViewHeightConstraint.constant = 0
        self.myCustomView?.BottomView.isHidden = false
        if self.audioPlayer.isPlaying{
            let pause = UIImage(named: "pause")
            self.myCustomView?.PauseAndPlayButton.setImage(pause, for: .normal)
        }else{
            let pause = UIImage(named: "play-1")
            self.myCustomView?.PauseAndPlayButton.setImage(pause, for: .normal)
        }
    }
    
    @objc func PlayButtonAction(_ sender: UIButton){
        print("Play Button")
        var dict = NSDictionary()
        dict = DataManager.getVal(self.response[sender.tag]) as! NSDictionary
        let song_file = DataManager.getVal(dict["song_file"]) as? String ?? ""
        let vc =  song_file.replacingOccurrences(of: " ", with: "")
        let AddPicture_url = URL.init(string: vc)
        print(AddPicture_url!)
        currentAudioPath = AddPicture_url
        
        //        sender.isSelected = !sender.isSelected
        if self.audioPlayer.isPlaying{
            let pause = UIImage(named: "play-1")
            self.myCustomView?.PlayButton.setImage(pause, for: .normal)
            self.audioPlayer.pause()
        }else{
            let play = UIImage(named: "pause")
            self.myCustomView?.PlayButton.setImage(play, for: .normal)
            self.audioPlayer.play()
        }
        
    }
    
    @objc func CrossButtonAction(_ sender: UIButton){
        print("Cross Button")
        self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-90, width: self.screenWidth, height: 60)
        self.myCustomView?.MiniView.isHidden = false
        self.myCustomView?.MiniViewHeightConstraint.constant = 60
        self.myCustomView?.BottomView.isHidden = true
        if self.audioPlayer.isPlaying{
            let pause = UIImage(named: "pause")
            self.myCustomView?.PlayButton.setImage(pause, for: .normal)
        }else{
            let pause = UIImage(named: "play-1")
            self.myCustomView?.PlayButton.setImage(pause, for: .normal)
        }
        if self.likeSts == 1 {
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs_up"), for: .normal)
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
        }else {
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
        }
        if self.UnlikeSts == 1 {
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs_down"), for: .normal)
        }else {
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
        }
    }
    @objc func SliderAction(_ sender: UISlider){
        print("Slider")
        self.audioPlayer.currentTime = TimeInterval(sender.value)
        //print(sender.value)
    }
    
    @objc func PreviousButtonAction(_ sender: UIButton){
        DispatchQueue.main.async() {
            if self.selectedMusic != 0 {
                self.selectedMusic = self.selectedMusic - 1
                self.loadUrl()
            }
        }
    }
    
    @objc func PauseAndPlayButtonAction(_ sender: UIButton){
        if self.audioPlayer.isPlaying{
            let pause = UIImage(named: "play-1")
            self.myCustomView?.PauseAndPlayButton.setImage(pause, for: .normal)
            self.audioPlayer.pause()
        }else{
            let play = UIImage(named: "pause")
            self.myCustomView?.PauseAndPlayButton.setImage(play, for: .normal)
            self.audioPlayer.play()
        }
        
    }
    
    @objc func NextButtonAction(_ sender: UIButton){
        DispatchQueue.main.async() {
            if self.selectedMusic + 1 < self.dataArray.count {
                self.selectedMusic = self.selectedMusic + 1
                self.loadUrl()
                if self.audioPlayer.isPlaying{
                    let pause = UIImage(named: "pause")
                    self.myCustomView?.PauseAndPlayButton.setImage(pause, for: .normal)
                }else{
                    let pause = UIImage(named: "play-1")
                    self.myCustomView?.PauseAndPlayButton.setImage(pause, for: .normal)
                }
            }
        }
    }
    
    @objc func LikeSongAction(_ sender: UIButton){
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
        parameterDictionary.setValue(DataManager.getVal(self.SongID), forKey: "song_id")
        parameterDictionary.setValue(DataManager.getVal(1), forKey: "status")
        print(parameterDictionary)
        
        let methodName = "songLikeUnlike"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                //            let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                if status == "1" {
                    self.likeSts = (responseData?.object(forKey: "like_status")) as? Int
                    self.likeCount = (responseData?.object(forKey: "likecount")) as? Int
                    self.UnlikeSts = (responseData?.object(forKey: "unlike_status")) as? Int
                    self.UnlikeCount = (responseData?.object(forKey: "unlikecount")) as? Int
                    var likecou:String!
                    likecou = String(self.likeCount)
                    var Unlikecou:String!
                    Unlikecou = String(self.UnlikeCount)
                    self.myCustomView?.LikeCountLbl.text = likecou
                    self.myCustomView?.DislikeCountLbl.text = Unlikecou
                    if self.likeSts == 1 {
                        self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs_up"), for: .normal)
                        self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
                    }else {
                        self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                    }
                    self.removeAllOverlays()
                }else{
                    self.likeCount = (responseData?.object(forKey: "likecount")) as? Int
                    self.UnlikeCount = (responseData?.object(forKey: "unlikecount")) as? Int
                    var likecou:String!
                    likecou = String(self.likeCount)
                    var Unlikecou:String!
                    Unlikecou = String(self.UnlikeCount)
                    self.myCustomView?.LikeCountLbl.text = likecou
                    self.myCustomView?.DislikeCountLbl.text = Unlikecou
                    self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                    self.removeAllOverlays()
                }
            })
        }
    }
    
    @objc func DislikeSongAction(_ sender: UIButton){
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
        parameterDictionary.setValue(DataManager.getVal(self.SongID), forKey: "song_id")
        parameterDictionary.setValue(DataManager.getVal(2), forKey: "status")
        print(parameterDictionary)
        
        let methodName = "songLikeUnlike"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                //            let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                if status == "1" {
                    self.likeSts = (responseData?.object(forKey: "like_status")) as? Int
                    self.likeCount = (responseData?.object(forKey: "likecount")) as? Int
                    self.UnlikeSts = (responseData?.object(forKey: "unlike_status")) as? Int
                    self.UnlikeCount = (responseData?.object(forKey: "unlikecount")) as? Int
                    if self.UnlikeSts == 1 {
                        self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                        self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs_down"), for: .normal)
                    }else {
                        self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
                    }
                    var likecou:String!
                    likecou = String(self.likeCount)
                    var Unlikecou:String!
                    Unlikecou = String(self.UnlikeCount)
                    self.myCustomView?.LikeCountLbl.text = likecou
                    self.myCustomView?.DislikeCountLbl.text = Unlikecou
                    self.removeAllOverlays()
                }else{
                    self.likeCount = (responseData?.object(forKey: "likecount")) as? Int
                    self.UnlikeCount = (responseData?.object(forKey: "unlikecount")) as? Int
                    var likecou:String!
                    likecou = String(self.likeCount)
                    var Unlikecou:String!
                    Unlikecou = String(self.UnlikeCount)
                    self.myCustomView?.LikeCountLbl.text = likecou
                    self.myCustomView?.DislikeCountLbl.text = Unlikecou
                    self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
                    self.removeAllOverlays()
                }
            })
        }
    }
    
    @objc func FavSongAction(_ sender: UIButton){
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
        parameterDictionary.setValue(DataManager.getVal(self.SongID), forKey: "favourite_id")
        parameterDictionary.setValue(DataManager.getVal("song"), forKey: "favourite_type")
        print(parameterDictionary)
        
        let methodName = "favourite"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                //                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                if status == "1" {
                    self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart-1"), for: .normal)
                    self.removeAllOverlays()
                }else{
                    self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart"), for: .normal)
                    self.removeAllOverlays()
                }
            })
        }
        
    }
    
    func loadUrl(){
        let dict = DataManager.getVal(self.dataArray[self.selectedMusic]) as! NSDictionary
        print(dict)
        let artistName = DataManager.getVal(dict["as_type_name"]) as? String ?? ""
        let songName = DataManager.getVal(dict["song_name"]) as? String ?? ""
        let songimg = DataManager.getVal(dict["song_image"]) as? String ?? ""
        let song_file = DataManager.getVal(dict["song_file"]) as? String ?? ""
        let duration = DataManager.getVal(dict["duration"]) as? String ?? ""
        let like_unlike_status = DataManager.getVal(dict["like_unlike_status"]) as? String ?? ""
        let favouriteStatus = DataManager.getVal(dict["favouriteStatus"]) as? String ?? ""
        let total_likes = DataManager.getVal(dict["total_likes"]) as? String ?? ""
        let total_unlikes = DataManager.getVal(dict["total_unlikes"]) as? String ?? ""
        self.myCustomView?.LikeCountLbl.text = total_likes
        self.myCustomView?.DislikeCountLbl.text = total_unlikes
        if like_unlike_status == "1"{
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs_up"), for: .normal)
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs_down"), for: .normal)
        }else {
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
        }
        
        if favouriteStatus == "1"{
            self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart-1"), for: .normal)
        }else{
            self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart"), for: .normal)
        }
        //Mini View
        self.myCustomView?.ArtistNameLbl.text = artistName
        self.myCustomView?.MiniSongNameLbl.text = songName
        
        self.myCustomView?.MiniImgView.sd_setImage(with: URL(string: songimg), placeholderImage: UIImage(named: "Group 4-1"))
        
        self.myCustomView?.BottomSongNameLbl.text = songName
        self.myCustomView?.BottomArtistNameLbl.text = artistName
        self.myCustomView?.MaximumTimeLbl.text = duration
        
        self.myCustomView?.BottomImgView.sd_setImage(with: URL(string: songimg), placeholderImage: UIImage(named: "Group 4-1"))
        
        let vc =  song_file.replacingOccurrences(of: " ", with: "")
        let AddPicture_url = URL.init(string: vc)
        print(AddPicture_url!)
        self.currentAudioPath = AddPicture_url
        
        if audioPlayer.isPlaying{
            audioPlayer.stop()
        }
        
        self.downloadFileFromURL3(url: self.currentAudioPath as NSURL)
    }
    
    
    func downloadFileFromURL3(url:NSURL){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            self?.prepareAudio(url: URL!)
        })
        
        downloadTask.resume()
    }
    // MARK: - Prepare audio for playing
    func prepareAudio(url : URL){
        
        print("playing \(url)")
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.volume = 1.0
            if audioPlayer.isPlaying{
            self.audioPlayer.stop()
            }else{
            self.audioPlayer.play()
            }
            DispatchQueue.main.async() {
                let pause = UIImage(named: "pause")
                self.myCustomView?.PlayButton.setImage(pause, for: .normal)
                self.myCustomView?.PauseAndPlayButton.setImage(pause, for: .normal)
                self.updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                self.updateTimer.fire()
            }
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        self.audioPlayer.delegate = self
        
        DispatchQueue.main.async {
            self.myCustomView?.SongSlider.maximumValue = CFloat(self.audioPlayer.duration)
            self.myCustomView?.SongSlider.minimumValue = 0.0
            self.myCustomView?.MinimumTimeLbl.text = "00:00"
            self.myCustomView?.SongSlider.value = 0.0
            self.audioPlayer.prepareToPlay()
        }
    }
    
    @objc func update(_ timer: Timer){
        if !audioPlayer.isPlaying{
            return
        }
        DispatchQueue.main.async() {
            let time = self.calculateTimeFromNSTimeInterval(self.audioPlayer.currentTime)
            self.myCustomView?.MinimumTimeLbl.text  = "\(time.minute):\(time.second)"
            self.myCustomView?.SongSlider.value = CFloat(self.audioPlayer.currentTime)
        }
    }
    
    func calculateTimeFromNSTimeInterval(_ duration:TimeInterval) ->(minute:String, second:String){
        //let hour_   = abs(Int(duration)/3600)
        let minute_ = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
        let second_ = abs(Int(duration.truncatingRemainder(dividingBy: 60)))
        
        let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
        let second = second_ > 9 ? "\(second_)" : "0\(second_)"
        
        return (minute,second)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
            
            if ordertype == nil && sortorder ==  nil && apicall == nil {
                var str = String()
                if songtype == nil {
                    str =  ""
                }else {
                    str = songtype
                }
                showWaitOverlay()
                Parsing().DiscoverSearchSongFilter(UserId: user_Id, FilterType: "songs", SearchKeyword: "", Sort: "", Limit: 10, Offset: slooooooooooot, Rating: "", Geners: "", StrDate: "", EndDate: "", Views: "", SongType: "", AnyAllSts: anyallsts, Lat: str_lat as String?, Long: str_long as String?, Distance: "")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
            } else if apicall == "APICall" {
                var str = String()
                if songtype == nil {
                    str =  ""
                }else {
                    str = songtype
                }
                showWaitOverlay()
                Parsing().DiscoverSearchSongFilter(UserId: self.user_Id, FilterType: "songs", SearchKeyword: "", Sort: "", Limit: 10, Offset: slooooooooooot, Rating: rating, Geners: genAr, StrDate: strdate, EndDate: enddate, Views: viewers, SongType: str, AnyAllSts: anyallsts, Lat: str_lat as String?, Long: str_long as String?, Distance: distance)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
            }else if apicall == "APINOTCall" {
                var str = String()
                if songtype == nil {
                    str =  ""
                }else {
                    str = songtype
                }
                showWaitOverlay()
                Parsing().DiscoverSearchSongFilter(UserId: user_Id, FilterType: "songs", SearchKeyword: "", Sort: "", Limit: 10, Offset: slooooooooooot, Rating: "", Geners: "", StrDate: "", EndDate: "", Views: "", SongType: "", AnyAllSts: anyallsts, Lat: str_lat as String?, Long: str_long as String?, Distance: "")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
            }
            else {
                if self.dict.count == 0 {
                    
                }else{
                    self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
                    self.sortarray.add(self.dict)
                    print(self.sortarray)
                    let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
                    print(typeIdArrayString)
                    var str = String()
                    if songtype == nil {
                        str =  ""
                    }else {
                        str = songtype
                    }
                    showWaitOverlay()
                    Parsing().DiscoverSearchSongFilter(UserId: user_Id, FilterType: "songs", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: slooooooooooot, Rating: "", Geners: "", StrDate: "", EndDate: "", Views: "", SongType: str, AnyAllSts: anyallsts, Lat: str_lat as String?, Long: str_long as String?, Distance: "")
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
                }
            }
           
           
            
        }
    }
    
    
    @IBAction func filterBtnAction(_ sender: Any) {
        var str:String!
        str = "APINOTCall"
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "APICALL")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "SongFilterViewController") as! SongFilterViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nextview = SongCornerView.intitiateFromNib()
        nextview.isHidden = false
        self.view.addGestureRecognizer(tap)
    }
  
    @objc func dismissView() {
        let nextview = SongCornerView.intitiateFromNib()
        nextview.isHidden = true
        self.view.removeGestureRecognizer(tap)
    }
    @IBAction func sortBtnAction(_ sender: Any) {
           self.view.endEditing(true)
        let nextview = SongCornerView.intitiateFromNib()
        let model = BackModel()
        nextview.buttonViewHighHandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW") as? String
            self.sortTypelbl.isHidden = false
            self.sortTypelbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                var str = String()
                if self.songtype == nil {
                    str =  ""
                }else {
                    str = self.songtype
                }
                self.showWaitOverlay()
                Parsing().DiscoverSearchSongFilter(UserId: self.user_Id, FilterType: "songs", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", StrDate: "", EndDate: "", Views: "", SongType: "", AnyAllSts: self.anyallsts, Lat: self.str_lat as String?, Long: self.str_long as String?, Distance: "")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
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
        nextview.buttonViewLowHandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW") as? String
            self.sortTypelbl.isHidden = false
            self.sortTypelbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                var str = String()
                if self.songtype == nil {
                    str =  ""
                }else {
                    str = self.songtype
                }
                self.showWaitOverlay()
                Parsing().DiscoverSearchSongFilter(UserId: self.user_Id, FilterType: "songs", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", StrDate: "", EndDate: "", Views: "", SongType: "", AnyAllSts: self.anyallsts, Lat: self.str_lat as String?, Long: self.str_long as String?, Distance: "")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
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
        nextview.buttonRatingHighHandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW") as? String
            self.sortTypelbl.isHidden = false
            self.sortTypelbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                var str = String()
                if self.songtype == nil {
                    str =  ""
                }else {
                    str = self.songtype
                }
                self.showWaitOverlay()
                Parsing().DiscoverSearchSongFilter(UserId: self.user_Id, FilterType: "songs", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", StrDate: "", EndDate: "", Views: "", SongType: "", AnyAllSts: self.anyallsts, Lat: self.str_lat as String?, Long: self.str_long as String?, Distance: "")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
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
        nextview.buttonRatingLowHandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW") as? String
            self.sortTypelbl.isHidden = false
            self.sortTypelbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                var str = String()
                if self.songtype == nil {
                    str =  ""
                }else {
                    str = self.songtype
                }
                self.showWaitOverlay()
                Parsing().DiscoverSearchSongFilter(UserId: self.user_Id, FilterType: "songs", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", StrDate: "", EndDate: "", Views: "", SongType: "", AnyAllSts: self.anyallsts, Lat: self.str_lat as String?, Long: self.str_long as String?, Distance: "")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
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
        nextview.buttonOrderNewesthandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW") as? String
            self.sortTypelbl.isHidden = false
            self.sortTypelbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                var str = String()
                if self.songtype == nil {
                    str =  ""
                }else {
                    str = self.songtype
                }
                self.showWaitOverlay()
                Parsing().DiscoverSearchSongFilter(UserId: self.user_Id, FilterType: "songs", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", StrDate: "", EndDate: "", Views: "", SongType: "", AnyAllSts: self.anyallsts, Lat: self.str_lat as String?, Long: self.str_long as String?, Distance: "")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
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
        nextview.buttonOrderOldesthandler = {
            self.slooooooooooot = 0
            self.APICall = true
            self.response.removeAllObjects()
            self.ordertype = self.defaults.value(forKey: "ORDERTYPE") as? String
            self.sortorder = self.defaults.value(forKey: "SORTORDER") as? String
            self.type = self.defaults.value(forKey: "TYPEVIEW") as? String
            self.sortTypelbl.isHidden = false
            self.sortTypelbl.text = ":" + " " + self.type
            self.dict = ["order_type":self.ordertype!,"order":self.sortorder!]
            self.sortarray.add(self.dict)
            print(self.sortarray)
            let  typeIdArrayString = self.JSONStringify(value: self.dict as AnyObject)
            print(typeIdArrayString)
            if Reachability.isConnectedToNetwork() == true{
                var str = String()
                if self.songtype == nil {
                    str =  ""
                }else {
                    str = self.songtype
                }
                self.showWaitOverlay()
                Parsing().DiscoverSearchSongFilter(UserId: self.user_Id, FilterType: "songs", SearchKeyword: "", Sort: typeIdArrayString, Limit: 10, Offset: self.slooooooooooot, Rating: "", Geners: "", StrDate: "", EndDate: "", Views: "", SongType: "", AnyAllSts: self.anyallsts, Lat: self.str_lat as String?, Long: self.str_long as String?, Distance: "")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFilterAction), name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: nil)
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
