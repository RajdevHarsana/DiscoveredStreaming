//
//  ArtistViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation
class ArtistViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
   
    @IBOutlet weak var artistTableview: UITableView!
    @IBOutlet weak var artist_btnHeightCons: NSLayoutConstraint!
    @IBOutlet weak var artist_Btn: UIButton!
    @IBOutlet weak var artistImageView: UIImageView!
   
    var artistRefreshControl: UIRefreshControl!
    var defaults:UserDefaults!
    var user_Id:Int!
    var response:NSMutableArray!
    var User_ID:Int!
    var useridArray:NSArray!
    var artist_sts:Int!
    var ArtistId:Int!
    var ArtistUserId:Int!
    var arryFav = NSMutableArray()
     var Data1 = Int()
    var followSts:Int!
    var artistName:String!
    var str_lat:String!
    var str_long:String!
    var Manager: CLLocationManager!
    var isCall = Bool()
    var slooooooooooot = Int()
    var APICall = Bool()
    //MARK:- Login WebService
    @objc func DiscoverArtistListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        self.artist_sts = notification.userInfo?["artist_status"] as? Int
        DispatchQueue.main.async() {
            if status == 0{
                self.APICall = false
               self.removeAllOverlays()
               self.response.removeAllObjects()
                if self.artist_sts == 1 {
                    self.artist_Btn.isHidden = true
                    self.artist_btnHeightCons.constant = 0
                    self.artistImageView.image = UIImage(named: "")
                }else {
                    self.artist_Btn.isHidden = false
                    self.artist_btnHeightCons.constant = 172
                    self.artistImageView.image = UIImage(named: "become_an_artist")
                }
               
               self.artistTableview.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: nil)
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
                
                self.useridArray = self.response.value(forKey: "user_id") as? NSArray
                self.followSts = self.response.value(forKey: "followStatus") as? Int
               
                for i in 0..<self.response.count {
                    
                    var dict = NSDictionary()
                    dict = self.response.object(at: i) as! NSDictionary
                    
                    let s_id = dict.object(forKey: "id") ?? NSString()
                    var isFav = Int()
                    isFav = dict.object(forKey: "followStatus") as! Int
                    //self.arryFav = []
                    if isFav == 1
                    {
                        self.arryFav.add(s_id)
                    }
                    
                }
                if self.artist_sts == 1 {
                    self.artist_Btn.isHidden = true
                    self.artist_btnHeightCons.constant = 0
                    self.artistImageView.image = UIImage(named: "")
                    var strsts:String!
                    strsts = "showartist"
                    let defaults = UserDefaults.standard
                    defaults.set(strsts, forKey: "SHOWAR")
                    defaults.synchronize()


                    }else{
                    var strsts:String!
                    strsts = nil
                    let defaults = UserDefaults.standard
                    defaults.set(strsts, forKey: "SHOWAR")
                    defaults.synchronize()
                        self.artist_Btn.isHidden = false
                       self.artist_btnHeightCons.constant = 172
                      self.artistImageView.image = UIImage(named: "become_an_artist")
                    }
                print("response: \(String(describing: self.response))")
                self.artistTableview.reloadData()
                self.artistTableview.isHidden = false
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    //MARK:- follow
    @objc func FollowArtistAction(_ notification: Notification) {
        
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
                self.Data1 = (notification.userInfo?["data"] as? Int)!
                //self.artistTableview.reloadData()
                Parsing().DiscoverArtistListing(user_Id: self.user_Id, List_type: "", Lat: self.str_lat as String?, Long:self.str_long as String?, Offset: self.slooooooooooot)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverArtistListAction), name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistFollowUnfollow"), object: nil)
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
                self.Data1 = (notification.userInfo?["data"] as? Int)!
               // self.artistTableview.reloadData()
                Parsing().DiscoverArtistListing(user_Id: self.user_Id, List_type: "", Lat: self.str_lat as String?, Long: self.str_long as String?, Offset: self.slooooooooooot)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverArtistListAction), name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistFollowUnfollow"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
        if #available(iOS 10.0, *) {
            self.artistRefreshControl = UIRefreshControl()
            self.artistRefreshControl.tintColor = UIColor.systemPink
//            self.artistRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.artistRefreshControl.addTarget(self,action: #selector(self.refreshArtistList),for: .valueChanged)
            self.artistTableview.addSubview(self.artistRefreshControl)
        }
        }
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        str_lat = defaults.value(forKey: "LAT") as? String
        str_long = defaults.value(forKey: "LONG") as? String
        response = NSMutableArray()
        arryFav = NSMutableArray()
        slooooooooooot = 0
        APICall = true
//        response.removeAllObjects()
        ArtistListApi()
//          NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("ArtistLIstingView"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshArtistList(sender: UIRefreshControl) {
       // Code to refresh table view
        self.artistTableview.reloadData()
        self.artistRefreshControl.endRefreshing()
        self.ArtistListApi()
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
       
        if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().DiscoverArtistListing(user_Id: user_Id, List_type: "", Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverArtistListAction), name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: nil)
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
            self.response.removeAllObjects()
            self.artistTableview.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    func ArtistListApi(){
                
            if !isCall
            {
            if Reachability.isConnectedToNetwork() == true{
                showWaitOverlay()
                let parameterDictionary = NSMutableDictionary()
                parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
                parameterDictionary.setValue(DataManager.getVal(""), forKey: "list_type")
                parameterDictionary.setValue(DataManager.getVal(str_lat), forKey: "lat")
                parameterDictionary.setValue(DataManager.getVal(str_long), forKey: "lng")
                parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
                print(parameterDictionary)
                
                let methodName = "get_artist_list"
                
                DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                DispatchQueue.main.async(execute: {
                    let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                    let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                    let artist_status = DataManager.getVal(responseData?.object(forKey: "artist_status"))  as? String ?? ""
                    self.artist_sts = Int(artist_status)
                    if status == "0" {
                    self.APICall = false
                    self.removeAllOverlays()
//                    self.response.removeAllObjects()
                     if self.artist_sts == 1 {
                         self.artist_Btn.isHidden = true
                         self.artist_btnHeightCons.constant = 0
                         self.artistImageView.image = UIImage(named: "")
                         }else {
                         self.artist_Btn.isHidden = false
                         self.artist_btnHeightCons.constant = 172
                         self.artistImageView.image = UIImage(named: "become_an_artist")
                         }
                    self.artistTableview.reloadData()
                        
                    }else{
                    var arr_data = NSMutableArray()
                      arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                      self.APICall = true
                      if arr_data.count != 0 {
                      self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                      self.slooooooooooot = self.slooooooooooot + 10
//                      arr_data.removeAllObjects()
                    }
                    if self.artist_sts == 1 {
                    self.artist_Btn.isHidden = true
                    self.artist_btnHeightCons.constant = 0
                    self.artistImageView.image = UIImage(named: "")
                    var strsts:String!
                    strsts = "showartist"
                    let defaults = UserDefaults.standard
                    defaults.set(strsts, forKey: "SHOWAR")
                    defaults.synchronize()
                    }else{
                    var strsts:String!
                    strsts = nil
                    let defaults = UserDefaults.standard
                    defaults.set(strsts, forKey: "SHOWAR")
                    defaults.synchronize()
                    self.artist_Btn.isHidden = false
                    self.artist_btnHeightCons.constant = 172
                    self.artistImageView.image = UIImage(named: "become_an_artist")
                    }
                    self.useridArray = self.response.value(forKey: "user_id") as? NSArray
                    self.followSts = self.response.value(forKey: "followStatus") as? Int
                    self.artistTableview.reloadData()
                    self.removeAllOverlays()
                  }
                    //self.clearAllNotice()
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
            self.artistTableview.addSubview(artistRefreshControl)
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Artist Found"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ArtistSponsoredCell
      
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.ArtistName.text = dict.value(forKey: "artist_name") as? String
        cell.ArtistImageView.layer.cornerRadius = 5
        cell.ArtistImageView.sd_setImage(with: URL(string: (dict.value(forKey: "artist_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        var Genre = String()
        Genre = dict.value(forKey: "genres") as! String
        cell.ArtistGenre.text = "Genre:" + Genre
        var dis = String()
        dis = dict.value(forKey: "distance") as! String
        cell.DistanceLbl.text = "Distance:" + " " + dis
        
        var rating1 = NSNumber()
        rating1 = dict.value(forKey: "rating") as! NSNumber
        cell.ratingView.rating = Float(truncating: rating1)
        var viewCount = Int()
        viewCount =  (dict.value(forKey: "viewer") as? Int)!
        
        var rateper = Int()
        rateper =  (dict.value(forKey: "rating_percentage") as? Int)!
        
        var rate = String()
        rate = String(rateper)
        
        cell.ratingPerLbl.text = rate + "%"
        
        
        let viewCountStr = String(viewCount)
        cell.ViewLBl.text =  viewCountStr + "  Views"
        cell.followBtn.tag = indexPath.row
        cell.followBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        var artistuserid:Int!
        artistuserid = dict.value(forKey: "user_id") as? Int
        if artistuserid == user_Id {
            cell.followBtn.isHidden = true
        }else {
            cell.followBtn.isHidden = false
           
        }
        var featuredArtist:Int!
        featuredArtist = dict.value(forKey: "featured_artist") as? Int
        if featuredArtist == 0 {
            cell.featuredArtist_img.isHidden = true
        }else{
            cell.featuredArtist_img.isHidden = false
        }
        
        var followSt:Int!
        followSt = dict.value(forKey: "followStatus") as? Int

        if followSt == 0 {
            cell.followBtn.setImage(UIImage(named: "Follow"), for: .normal)
        }else {
           cell.followBtn.setImage(UIImage(named: "Un_Follow_button"), for: .normal)
        }
        
        var rating = NSNumber()
        rating = dict.value(forKey: "rating") as! NSNumber
        
        cell.ratingView.rating = Float(truncating: rating)
      
        

      
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        ArtistId = dict.value(forKey: "id") as? Int
        ArtistUserId = dict.value(forKey: "user_id") as? Int
        artistName = dict.value(forKey: "artist_name") as? String
        let defaults = UserDefaults.standard
        defaults.set(ArtistId, forKey: "ArtistID")
        defaults.set(ArtistUserId, forKey: "ArUserId")
        defaults.set(artistName, forKey: "ArName")
        defaults.synchronize()
        let isComingFrom = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArtistDetailViewController") as! ArtistDetailViewController
        vc.isComingFrom = isComingFrom
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
            ArtistListApi()
        }
    }
   
    
    @objc func handleTap(_ sender:UIButton) {
        
        let dict = DataManager.getVal(self.response[sender.tag]) as! NSDictionary
        let id = DataManager.getVal(dict["id"]) as? String ?? ""
        
        let index = IndexPath(row: sender.tag, section: 0)
        let cell = self.artistTableview.cellForRow(at: index) as? ArtistSponsoredCell
        
        sender.isSelected = !sender.isSelected
        if cell?.followBtn.currentImage == UIImage(named: "Follow"){
                        
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
            parameterDictionary.setValue(DataManager.getVal(id), forKey: "follower_id")
            parameterDictionary.setValue(DataManager.getVal("artists"), forKey: "follow_type")
            print(parameterDictionary)
            
            let methodName = "followUnfollow"//change name
            
            DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                
                DispatchQueue.main.async(execute: {
                    
                    let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                    let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                    
                    if status == "1" {
                        cell?.followBtn.setImage(UIImage(named: "Un_Follow_button"), for: .normal)
//                        let test =  SwiftToast(
//                            text: message,
//                            textAlignment: .center,
//                            image: UIImage(named: "ic_alert"),
//                            backgroundColor: .purple,
//                            textColor: .white,
//                            font: .boldSystemFont(ofSize: 15.0),
//                            duration: 2.0,
//                            minimumHeight: CGFloat(100.0),
//                            statusBarStyle: .lightContent,
//                            aboveStatusBar: true,
//                            target: nil,
//                            style: .navigationBar)
//                        self.present(test, animated: true)
                    }else{
                        //Config().error(message: message)//error message
                    }
                    self.removeAllOverlays()
                })
            }
        }else{
                                    
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
            parameterDictionary.setValue(DataManager.getVal(id), forKey: "follower_id")
            parameterDictionary.setValue(DataManager.getVal("artists"), forKey: "follow_type")
            print(parameterDictionary)
            
            let methodName = "followUnfollow"
            
            DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                
                DispatchQueue.main.async(execute: {
                    
                    let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                    let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                    
                    if status == "0" {
                        cell?.followBtn.setImage(UIImage(named: "Follow"), for: .normal)
//                        let test =  SwiftToast(
//                            text: message,
//                            textAlignment: .center,
//                            image: UIImage(named: "ic_alert"),
//                            backgroundColor: .purple,
//                            textColor: .white,
//                            font: .boldSystemFont(ofSize: 15.0),
//                            duration: 2.0,
//                            minimumHeight: CGFloat(100.0),
//                            statusBarStyle: .lightContent,
//                            aboveStatusBar: true,
//                            target: nil,
//                            style: .navigationBar)
//                        self.present(test, animated: true)
                    }else{
                        //Config().error(message: message)
                    }
                    self.removeAllOverlays()
                })
            }
        }
        
    }
    
    
    @IBAction func becomeArtistBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BecomeAnArtist1ViewController") as! BecomeAnArtist1ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
