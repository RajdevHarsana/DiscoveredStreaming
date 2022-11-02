//
//  UpcomingEventsViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftToast

class UpcomingEventsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
   

    @IBOutlet weak var upcomingEventTableview: UITableView!
    var Manager: CLLocationManager!
    var response = NSMutableArray()
    var defaults:UserDefaults!
    var user_Id:Int!
    var event_id:Int!
    var str_lat:String!
    var str_long:String!
    var isCall = Bool()
    var venueid:Int!
    var posttype:String!
    var eventid:Int!
    var evntuserid:Int!
    var upcomingEventRefreshControl: UIRefreshControl!
    
    var slooooooooooot = Int()
    var APICall = Bool()
    
    @objc func DiscoverEventListAction(_ notification: Notification) {
        
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
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverEventListing"), object: nil)
                self.removeAllOverlays()
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
                               
//                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
//                print("response: \(String(describing: self.response))")
                self.upcomingEventTableview.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverEventListing"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            self.upcomingEventRefreshControl = UIRefreshControl()
            self.upcomingEventRefreshControl.tintColor = UIColor.systemPink
//            self.venueRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.upcomingEventRefreshControl.addTarget(self,action: #selector(self.refreshUpcominEventList),for: .valueChanged)
            self.upcomingEventTableview.addSubview(self.upcomingEventRefreshControl)
        }
         defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        posttype = defaults.value(forKey: "postType") as? String
        str_lat = defaults.value(forKey: "LAT") as? String
        str_long = defaults.value(forKey: "LONG") as? String
        if posttype == "artist" {
            venueid = defaults.integer(forKey: "ARNewID")
        }else if posttype ==  "band" {
            venueid = defaults.integer(forKey: "ARNewID")
        }else {
            venueid = defaults.integer(forKey: "ARVenID")
        }
       slooooooooooot = 0
       APICall = true
       response.removeAllObjects()
       eventListApi()
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshUpcominEventList(sender: UIRefreshControl) {
       // Code to refresh table view
        self.upcomingEventTableview.reloadData()
        self.upcomingEventRefreshControl.endRefreshing()
        self.eventListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    func eventListApi(){
                
            if !isCall
            {
            if Reachability.isConnectedToNetwork() == true{
                showWaitOverlay()
                let parameterDictionary = NSMutableDictionary()
                parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
                parameterDictionary.setValue(DataManager.getVal("home"), forKey: "related_type")
    //            parameterDictionary.setValue(DataManager.getVal(""), forKey: "as_type_id")
                parameterDictionary.setValue(DataManager.getVal(venueid), forKey: "related_type_id")
                parameterDictionary.setValue(DataManager.getVal(str_lat), forKey: "lat")
                parameterDictionary.setValue(DataManager.getVal(str_long), forKey: "lng")
                parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
    //            parameterDictionary.setValue(DataManager.getVal(list_type_id), forKey: "list_type_id")
                print(parameterDictionary)
                
                let methodName = "event_list"
                
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
                      self.upcomingEventTableview.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if response.count>0
        {
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
            self.upcomingEventTableview.addSubview(upcomingEventRefreshControl)
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Upcoming Events Found"
            
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UpcomingEventsTableCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.eventImage.sd_setImage(with: URL(string: (dict.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        cell.EventNameLbl.text = dict.value(forKey: "event_title") as? String
        cell.addressLbl.text = dict.value(forKey: "address") as? String
        
        var venueName = String()
        venueName = (dict.value(forKey: "venue_name") as? String)!
        
        var dateTime = String()
        dateTime = (dict.value(forKey: "event_date") as? String)!
        
        
        var Time = String()
        Time = (dict.value(forKey: "event_time") as? String)!
        
        cell.datetimeLbl.text = venueName + " " + dateTime  + "  " + Time
        
        var eventprice = NSNumber()
        eventprice = dict.value(forKey: "price_per_sit") as! NSNumber
        cell.priceLbl.text =  "$" + eventprice.stringValue
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
            eventListApi()
               
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
