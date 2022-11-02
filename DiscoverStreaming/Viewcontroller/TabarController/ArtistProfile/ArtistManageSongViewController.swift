//
//  ArtistManageSongViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation

class ArtistManageSongViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
  
    

    @IBOutlet weak var managesongCell: UITableView!
    var defaults:UserDefaults!
    var user_Id:Int!
    var response = NSMutableArray()
    var artistUserId:Int!
    var arid:Int!
    var myindexpath = NSIndexPath()
    var songId:Int!
    
    var str_lat:String!
    var str_long:String!
    var Manager: CLLocationManager!
    var isCall = Bool()
    var slooooooooooot = Int()
    var APICall = Bool()
    var flag = String()
    var manageSongRefreshControl: UIRefreshControl!
    
    @objc func DiscoverSongListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.APICall = false
                self.managesongCell.reloadData()
                
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
                self.managesongCell.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongList"), object: nil)
                self.removeAllOverlays()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
        if #available(iOS 10.0, *) {
            self.manageSongRefreshControl = UIRefreshControl()
            self.manageSongRefreshControl.tintColor = UIColor.systemPink
//            self.venueRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.manageSongRefreshControl.addTarget(self,action: #selector(self.refreshVenueList),for: .valueChanged)
            self.managesongCell.addSubview(self.manageSongRefreshControl)
        }
        }
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        artistUserId = defaults.integer(forKey: "ArUserId")
        arid = defaults.integer(forKey: "ARNewID")
        str_lat = defaults.value(forKey: "LAT") as? String
        str_long = defaults.value(forKey: "LONG") as? String
        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
        self.ManagesongListApi()
      
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshVenueList(sender: UIRefreshControl) {
       // Code to refresh table view
        self.managesongCell.reloadData()
        self.manageSongRefreshControl.endRefreshing()
        self.ManagesongListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        defaults = UserDefaults.standard
        flag = defaults.value(forKey: "song_Featured") as? String ?? ""
        if flag == "true"{
            slooooooooooot = 0
            APICall = true
            response.removeAllObjects()
            self.ManagesongListApi()
        }else{
            //Nothing Happen
        }
    }
    
    func ManagesongListApi(){
          if !isCall
          {
              if Reachability.isConnectedToNetwork() == true{
                  showWaitOverlay()
                  let parameterDictionary = NSMutableDictionary()
                  parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
                  parameterDictionary.setValue(DataManager.getVal("artist"), forKey: "as_type")
                  parameterDictionary.setValue(DataManager.getVal(self.arid), forKey: "as_type_id")
                  parameterDictionary.setValue(DataManager.getVal("all"), forKey: "list_type")
                  parameterDictionary.setValue(DataManager.getVal(str_lat), forKey: "lat")
                  parameterDictionary.setValue(DataManager.getVal(str_long), forKey: "lng")
                  parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
                  print(parameterDictionary)
                  
                  let methodName = "song_list"
                  
                  DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                  DispatchQueue.main.async(execute: {
                      let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                      let songCount = DataManager.getVal(responseData?.object(forKey: "song_count"))  as? Int ?? 0
    
                      if status == "1" {
                      var arr_data = NSMutableArray()
                      arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                      self.APICall = true
                      self.response.removeAllObjects()
                      if arr_data.count != 0 {
                      self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                      self.slooooooooooot = self.slooooooooooot + 10
                      arr_data.removeAllObjects()
                      }
                      self.managesongCell.reloadData()
                      self.removeAllOverlays()

                      }else{
                      if songCount <= 10{
//                          self.response.removeAllObjects()
                          self.managesongCell.reloadData()
                          self.removeAllOverlays()
                      }else{
                          self.managesongCell.reloadData()
                          self.removeAllOverlays()
                      }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if response.count>0
        {
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
            self.managesongCell.addSubview(manageSongRefreshControl)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArtistSongCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.songNAme.text = dict.value(forKey: "song_name") as? String
        var view:Int!
        view = dict.value(forKey: "viewer") as? Int
        var viewcou:String!
        viewcou = String(view)
        cell.views.text = viewcou + " " + "views"
        cell.songImage.layer.cornerRadius = 5
        cell.songImage.sd_setImage(with: URL(string: (dict.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        
        var gen:String!
        gen =  dict.value(forKey: "genres") as? String
        cell.Genres.text = "Genre:" + " " + gen
       // cell.songTime.text = dict.value(forKey: "duration") as? String
        cell.songTime.isHidden = true
        var rating1:NSNumber!
        rating1 = dict.value(forKey: "rating") as? NSNumber
        
        var rate = Float()
        rate = Float(truncating: rating1)
        cell.rating.rating = Float(truncating: NSNumber(value: rate))
        
        var ratingper:NSNumber!
        ratingper = dict.value(forKey: "rating_percentage") as? NSNumber
        cell.ratingPer.text = ratingper.stringValue + "%"
        var featuredSong:Int!
        featuredSong = dict.value(forKey: "featured_song") as? Int
        if featuredSong == 1 {
            cell.featuredSong_img.isHidden = false
            cell.editBtn.isHidden = true
            cell.deleteBtn.isHidden = true
        }else{
            cell.featuredSong_img.isHidden = true
            cell.editBtn.isHidden = false
            cell.deleteBtn.isHidden = false
        }
        
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(HandleTap(_:)), for: .touchUpInside)
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(HandleTap1(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        var songID:Int!
        songID = dict.value(forKey:"id") as? Int
        let defaults = UserDefaults.standard
        defaults.set(songID, forKey: "Song_Id")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "ManageSongDetailViewController") as! ManageSongDetailViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true {
            Parsing().DiscoverSongList(UserId: user_Id, AsType: "artist", AstypeId: arid, ListType: "all", Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongList"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongListAction), name: NSNotification.Name(rawValue: "DiscoverSongList"), object: nil)
//            self.ManagesongListApi()
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !APICall){
//            self.APICall = true
//            self.ManagesongListApi()
//        }
//    }

    @objc func HandleTap(_ sender:UIButton){
        let buttonPosition = sender.convert(CGPoint.zero, to: managesongCell)
        myindexpath = managesongCell.indexPathForRow(at: buttonPosition)! as NSIndexPath
        var dict1 = NSDictionary()
        dict1  = (response.object(at: myindexpath.row) as? NSDictionary)!
        songId = dict1.value(forKey: "id") as? Int
        var str = String()
        str = "Edit"
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "ADD")
        defaults.set(songId, forKey: "Song_Id")
        defaults.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNewSongViewController") as! AddNewSongViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func HandleTap1(_ sender:UIButton){
           let nextview = Deletesongview.intitiateFromNib()
           let model = NewPopModel()
           nextview.buttonDoneHandler = {
               let buttonPosition = sender.convert(CGPoint.zero, to: self.managesongCell)
               self.myindexpath = self.managesongCell.indexPathForRow(at: buttonPosition)! as NSIndexPath
               var dict1 = NSDictionary()
               dict1  = (self.response.object(at: self.myindexpath.row) as? NSDictionary)!
               self.songId = dict1.value(forKey: "id") as? Int
               
               if Reachability.isConnectedToNetwork() == true {
                   self.showWaitOverlay()
                let parameterDictionary = NSMutableDictionary()
                parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
                parameterDictionary.setValue(DataManager.getVal(self.songId), forKey: "song_id")
                print(parameterDictionary)
                
                let methodName = "songDelete"
                
                DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                DispatchQueue.main.async(execute: {
                    let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                    let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                    if status == "1" {
                        self.slooooooooooot = 0
                        self.ManagesongListApi()
                    }else{
                        self.managesongCell.reloadData()
                        self.removeAllOverlays()
                    }
                    self.removeAllOverlays()
                })
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
            model.closewithAnimation()
           }
           nextview.buttonCancleHandler = {
               model.closewithAnimation()
           }
           model.show(view: nextview)
       
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addBtnAction(_ sender: Any) {
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
