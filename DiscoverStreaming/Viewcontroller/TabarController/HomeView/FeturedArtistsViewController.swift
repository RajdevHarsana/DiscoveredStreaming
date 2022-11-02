//
//  FeturedArtistsViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftToast

class FeturedArtistsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {

    @IBOutlet weak var feturedArtistTableview: UITableView!
    var defaults:UserDefaults!
    var user_Id:Int!
    var response = NSMutableArray()
    var str_lat:String!
    var str_long:String!
    var Manager: CLLocationManager!
    var isCall = Bool()
    var slooooooooooot = Int()
    var APICall = Bool()
    var ArtistId:Int!
    var ArtistUserId:Int!
    var artistName:String!
    var featuredArtistRefreshControl: UIRefreshControl!
    
    @objc func DiscoverSongListAction(_ notification: Notification) {
           
           let status = (notification.userInfo?["status"] as? Int)!
           let str_message = (notification.userInfo?["message"] as? String)!
           
           DispatchQueue.main.async() {
               if status == 0{
                   self.removeAllOverlays()
                   self.feturedArtistTableview.reloadData()
               }
               else{
                   self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                   print("response: \(String(describing: self.response))")
                   self.feturedArtistTableview.reloadData()
                   self.removeAllOverlays()
               }
           }
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            self.featuredArtistRefreshControl = UIRefreshControl()
            self.featuredArtistRefreshControl.tintColor = UIColor.systemPink
//            self.venueRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.featuredArtistRefreshControl.addTarget(self,action: #selector(self.refreshFeaturedArtistList),for: .valueChanged)
            self.feturedArtistTableview.addSubview(self.featuredArtistRefreshControl)
        }
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        str_lat = defaults.value(forKey: "LAT") as? String
        str_long = defaults.value(forKey: "LONG") as? String
        slooooooooooot = 0
        APICall = true
        FeaturedArtistListApi()
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshFeaturedArtistList(sender: UIRefreshControl) {
       // Code to refresh table view
        self.feturedArtistTableview.reloadData()
        self.featuredArtistRefreshControl.endRefreshing()
        self.FeaturedArtistListApi()
    }
    
    func FeaturedArtistListApi(){
                
            if !isCall
            {
            if Reachability.isConnectedToNetwork() == true{
                showWaitOverlay()
                let parameterDictionary = NSMutableDictionary()
                parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
                parameterDictionary.setValue(DataManager.getVal("featured"), forKey: "list_type")
                parameterDictionary.setValue(DataManager.getVal(str_lat), forKey: "lat")
                parameterDictionary.setValue(DataManager.getVal(str_long), forKey: "lng")
                parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
                print(parameterDictionary)
                
                let methodName = "get_artist_list"
                
                DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                DispatchQueue.main.async(execute: {
                    let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                    let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
    //                let songCount = DataManager.getVal(responseData?.object(forKey: "song_count"))  as? Int ?? 0
    //                self.totalSongs = songCount
                    if status == "0" {
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
                        self.APICall = false
                        self.removeAllOverlays()
                        
                    }else{
                    var arr_data = NSMutableArray()
                      arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                      self.APICall = true
                      if arr_data.count != 0 {
                      self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                      self.slooooooooooot = self.slooooooooooot + 10
                      arr_data.removeAllObjects()
                    }
                      self.feturedArtistTableview.reloadData()
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
            self.feturedArtistTableview.addSubview(featuredArtistRefreshControl)
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Recently Added Song Found"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeturedArtistsCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.ArtistNameLbl.text = dict.value(forKey: "artist_name") as? String
        cell.ArtistImageView.layer.cornerRadius = 5
        cell.ArtistImageView.sd_setImage(with: URL(string: (dict.value(forKey: "artist_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        var Genre = String()
        Genre = dict.value(forKey: "genres") as! String
        cell.genreslbl.text =  Genre
        var dis = String()
        dis = dict.value(forKey: "distance") as! String
        cell.distanceLbl.text =  dis
        
        var viewCount = Int()
        viewCount =  (dict.value(forKey: "viewer") as? Int)!
        cell.follow_btn.tag = indexPath.row
        cell.follow_btn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        var artistuserid:Int!
        artistuserid = dict.value(forKey: "user_id") as? Int
        if artistuserid == user_Id {
            cell.follow_btn.isHidden = true
        }else {
            cell.follow_btn.isHidden = false
        }
        var followSt:Int!
        followSt = dict.value(forKey: "followStatus") as? Int

        if followSt == 0 {
           cell.follow_btn.setImage(UIImage(named: "Follow"), for: .normal)
        }else {
           cell.follow_btn.setImage(UIImage(named: "Un_Follow_button"), for: .normal)
        }
        var rateper = Int()
        rateper =  (dict.value(forKey: "rating_percentage") as? Int)!
        
        cell.ratingPercentacgelbl.text =  "\(rateper)" + "%"
    
        cell.viewLbl.text =  "\(viewCount)" + " views"
        
        var rating = NSNumber()
        rating = dict.value(forKey: "rating") as! NSNumber
        
        cell.rationView.rating = Float(truncating: rating as NSNumber)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        var arid = Int()
        arid = dict.value(forKey: "id") as? Int ?? 0
        
        var aruserid = Int()
        aruserid = dict.value(forKey: "user_id") as? Int ?? 0
        
        ArtistId = arid
        ArtistUserId = aruserid
        artistName = dict.value(forKey: "artist_name") as? String ?? ""
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
         FeaturedArtistListApi()
        }
    }
    
    @objc func handleTap(_ sender:UIButton) {
            
            let dict = DataManager.getVal(self.response[sender.tag]) as! NSDictionary
            let id = DataManager.getVal(dict["id"]) as? String ?? ""
            
            let index = IndexPath(row: sender.tag, section: 0)
            let cell = self.feturedArtistTableview.cellForRow(at: index) as? FeturedArtistsCell
            
            sender.isSelected = !sender.isSelected
            if cell?.follow_btn.currentImage == UIImage(named: "Follow"){
                
                
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
                            cell?.follow_btn.setImage(UIImage(named: "Un_Follow_button"), for: .normal)
//                            let test =  SwiftToast(
//                                text: message,
//                                textAlignment: .center,
//                                image: UIImage(named: "ic_alert"),
//                                backgroundColor: .purple,
//                                textColor: .white,
//                                font: .boldSystemFont(ofSize: 15.0),
//                                duration: 2.0,
//                                minimumHeight: CGFloat(100.0),
//                                statusBarStyle: .lightContent,
//                                aboveStatusBar: true,
//                                target: nil,
//                                style: .navigationBar)
//                            self.present(test, animated: true)
                        }else{
                            //Config().error(message: message)//error message
                        }
                        //self.clearAllNotice()//clear loader
                        self.removeAllOverlays()
                    })
                }
            }else{
                
                //self.pleaseWait()
                            
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
                            cell?.follow_btn.setImage(UIImage(named: "Follow"), for: .normal)
//                            let test =  SwiftToast(
//                                text: message,
//                                textAlignment: .center,
//                                image: UIImage(named: "ic_alert"),
//                                backgroundColor: .purple,
//                                textColor: .white,
//                                font: .boldSystemFont(ofSize: 15.0),
//                                duration: 2.0,
//                                minimumHeight: CGFloat(100.0),
//                                statusBarStyle: .lightContent,
//                                aboveStatusBar: true,
//                                target: nil,
//                                style: .navigationBar)
//                            self.present(test, animated: true)
                        }else{
                            //Config().error(message: message)
                        }
                        self.removeAllOverlays()
                    })
                }
            }
            
        }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
