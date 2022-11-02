//
//  ArtistManageEventsViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation

class ArtistManageEventsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,CLLocationManagerDelegate {
    

    @IBOutlet weak var eventInviteTable: UITableView!
    @IBOutlet weak var upcomingEventCollection: UICollectionView!
    @IBOutlet weak var passEventCollection: UICollectionView!
    
    var response = NSMutableArray()
    var response1 = NSMutableArray()
    var defaults:UserDefaults!
    var user_Id:Int!
    var arid:Int!
    var Manager: CLLocationManager!
    var str_lat:NSString!
    var str_long:NSString!
    var isCall = Bool()
    var relatedType:String!
    var inviteArray = NSMutableArray()
    var bandid:Int!
    var eventid:Int!
    var evntuserid:Int!
    @IBOutlet weak var pastViewAllBtn: UIButton!
    @IBOutlet weak var upcomingViewAllBtn: UIButton!
    //MARK:- Login WebService
    @objc func DiscoverEventListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
               // self.upcomingEventCollection.isHidden = true
                self.upcomingViewAllBtn.isHidden = true
                self.pastViewAllBtn.isHidden = true
                self.upcomingEventCollection.reloadData()
                
            }
            else{
                var dict = NSMutableDictionary()
                dict  = (notification.userInfo?["data"] as? NSMutableDictionary)!
                self.response = dict.value(forKey: "upcoming") as! NSMutableArray
                self.response1 = dict.value(forKey: "past") as! NSMutableArray
                if self.response.count == 0 {
                    self.upcomingViewAllBtn.isHidden = true
                }else {
                    self.upcomingViewAllBtn.isHidden = false
                }
                if self.response1.count == 0 {
                    self.pastViewAllBtn.isHidden = true
                }else {
                    self.pastViewAllBtn.isHidden = false
                }
                self.upcomingEventCollection.reloadData()
                self.passEventCollection.reloadData()
                self.removeAllOverlays()
                self.upcomingEventCollection.isHidden = false
                
            }
        }
    }
    
    //MARK:- Login WebService
    @objc func DiscoverEventInviteListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                // self.upcomingEventCollection.isHidden = true
                self.upcomingEventCollection.reloadData()
            }
            else{
                self.inviteArray  = (notification.userInfo?["data"] as? NSMutableArray)!
                self.eventInviteTable.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    @objc func DiscoverAcceptRequestAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                let test =  SwiftToast(
                    text: str_message,
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
                self.removeAllOverlays()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestEvent"), object: nil)
                self.eventInviteTable.reloadData()
                self.response.removeAllObjects()
            }
            else{
                let test =  SwiftToast(
                    text: str_message,
                    textAlignment: .center,
                    image: UIImage(named: "shield (2)"),
                    backgroundColor: .purple,
                    textColor: .white,
                    font: .boldSystemFont(ofSize: 15.0),
                    duration: 2.0,
                    minimumHeight: CGFloat(80.0),
                    aboveStatusBar: false,
                    target: nil,
                    style: .navigationBar)
                self.present(test, animated: true)
                Parsing().DiscoverEventInvites(UserId: self.user_Id, InviteType: self.relatedType, Invite_TypeId: self.arid, InviteForm: "event")
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverEventInviteListAction), name: NSNotification.Name(rawValue: "DiscoverEventInvites"), object: nil)
                self.eventInviteTable.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestEvent"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    @objc func DiscoverRejectRequestAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                let test =  SwiftToast(
                    text: str_message,
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
                self.removeAllOverlays()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestEvent"), object: nil)
                self.eventInviteTable.reloadData()
                self.response.removeAllObjects()
            }
            else{
                let test =  SwiftToast(
                    text: str_message,
                    textAlignment: .center,
                    image: UIImage(named: "shield (2)"),
                    backgroundColor: .purple,
                    textColor: .white,
                    font: .boldSystemFont(ofSize: 15.0),
                    duration: 2.0,
                    minimumHeight: CGFloat(80.0),
                    aboveStatusBar: false,
                    target: nil,
                    style: .navigationBar)
                 self.present(test, animated: true)
                Parsing().DiscoverEventInvites(UserId: self.user_Id, InviteType: self.relatedType, Invite_TypeId: self.arid, InviteForm: "event")
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverEventInviteListAction), name: NSNotification.Name(rawValue: "DiscoverEventInvites"), object: nil)
                self.eventInviteTable.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestEvent"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        arid = defaults.integer(forKey: "ARNewID")
        relatedType = defaults.value(forKey: "postType") as? String
        
        if relatedType == "artist" {
            arid = defaults.integer(forKey: "ARNewID")
            //bandid = 0
        }else {
            //arid = 0
            bandid = defaults.integer(forKey: "ARNewID")
        }
        
        if Reachability.isConnectedToNetwork(){
            showWaitOverlay()
            Parsing().DiscoverUpcomingPastEvents(UserId: user_Id, RelatedType: relatedType, Related_TypeId: arid)
             NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverEventListAction), name: NSNotification.Name(rawValue: "DiscoverUpcomingPastEvents"), object: nil)
            
            Parsing().DiscoverEventInvites(UserId: user_Id, InviteType: relatedType, Invite_TypeId: arid, InviteForm: "event")
             NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverEventInviteListAction), name: NSNotification.Name(rawValue: "DiscoverEventInvites"), object: nil)
        }
        else{
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
            // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Internet Connection not Available!" , buttonTitle: "OK")
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
       {
           var numOfSections: Int = 0
           if inviteArray.count>0
           {
               tableView.separatorStyle = .none
               numOfSections            = 1
               tableView.backgroundView = nil
           }
           else
           {
               let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
               noDataLabel.text = "No Invites Found."
               noDataLabel.textColor     = UIColor.white
               noDataLabel.textAlignment = .center
               tableView.backgroundView  = noDataLabel
               tableView.separatorStyle  = .none
           }
           return numOfSections
       }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inviteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArtistEventInviteCell
        var dict = NSDictionary()
        dict = inviteArray.object(at: indexPath.row) as! NSDictionary
        cell.evnetImage.sd_setImage(with: URL(string: (dict.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        cell.nameLbl.text = dict.value(forKey: "event_title") as? String
        var dateTime = String()
        dateTime = (dict.value(forKey: "event_date") as? String)!
        
        var Time = String()
        Time = (dict.value(forKey: "event_time") as? String)!
        
        cell.venuenamelbl.text = dateTime + " " + Time
        var venuedic = NSDictionary()
        venuedic = dict.value(forKey: "venue") as! NSDictionary
        cell.venLbl.text = venuedic.value(forKey: "venue_name") as? String
        var city:String!
        city = venuedic.value(forKey: "city") as? String
        
        var state:String!
        state = venuedic.value(forKey: "state") as? String
        cell.addressLbl.text = city + " " + state
        
        cell.accpetBtn.tag = indexPath.row
        cell.accpetBtn.addTarget(self, action: #selector(HandleAccept(_:)), for: .touchUpInside)
        
        cell.rejectBtn.tag = indexPath.row
        cell.rejectBtn.addTarget(self, action: #selector(HandleReject(_:)), for: .touchUpInside)
        
    
        return cell
    }
    
    @objc func HandleAccept(_ sender: UIButton) {
        var btn = sender as? UIButton
        let dict1 = inviteArray.object(at: (btn?.tag)!) as! NSDictionary
        
        let s_id = dict1.object(forKey: "id") ?? NSString()
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            Parsing().DiscoverAcceptRejectRequestEvent(ID: s_id as? Int, ArtistId: arid, JoinStatus: 1, UserId: user_Id, StatusType: "event", bandId: bandid)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestEvent"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverAcceptRequestAction), name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestEvent"), object: nil)
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
    
    @objc func HandleReject(_ sender: UIButton) {
        var btn = sender as? UIButton
        let dict1 = inviteArray.object(at: (btn?.tag)!) as! NSDictionary
        
        let s_id = dict1.object(forKey: "id") ?? NSString()
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            Parsing().DiscoverAcceptRejectRequestEvent(ID: s_id as? Int, ArtistId: arid, JoinStatus: 0, UserId: user_Id, StatusType: "event", bandId: bandid)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestEvent"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverRejectRequestAction), name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestEvent"), object: nil)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == upcomingEventCollection {
           return response.count
        }else {
            return response1.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == upcomingEventCollection {
        var numOfSections: Int = 0
        if response.count>0
        {
            numOfSections            = 1
            collectionView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            noDataLabel.text          = "No Upcoming Events Found"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            collectionView.backgroundView  = noDataLabel
        }
        return numOfSections
        }else {
            var numOfSections: Int = 0
            if response1.count>0
            {
                numOfSections            = 1
                collectionView.backgroundView = nil
            }
            else
            {
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
                noDataLabel.text          = "No Past Events Found"
                noDataLabel.textColor     = UIColor.white
                noDataLabel.textAlignment = .center
                collectionView.backgroundView  = noDataLabel
            }
            return numOfSections
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == upcomingEventCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ArtistUpcomingEvents1Cell
            var dict = NSDictionary()
            dict = response.object(at: indexPath.row) as! NSDictionary
            cell.evnetImage.sd_setImage(with: URL(string: (dict.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.eventNamaLbl.text = dict.value(forKey: "event_title") as? String
            var dateTime = String()
            dateTime = (dict.value(forKey: "event_date") as? String)!
            
            var Time = String()
            Time = (dict.value(forKey: "event_time") as? String)!
            
            cell.eventDateLbl.text = dateTime + " " + Time
            var price = Int()
            price = dict.value(forKey: "price_per_sit") as! Int
            
            var eventprice = String()
            eventprice = String(price)
            
            cell.eventPriceLbl.text =  "$" + eventprice
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ArtistPastEvents1Cell
            cell.layer.cornerRadius = 5
            var dict = NSDictionary()
            dict = response1.object(at: indexPath.row) as! NSDictionary
            cell.evnetImage.layer.cornerRadius = 5
            cell.evnetImage.sd_setImage(with: URL(string: (dict.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.eventNamelbl.text = dict.value(forKey: "event_title") as? String
            var dateTime = String()
            dateTime = (dict.value(forKey: "event_date") as? String)!
            
            var Time = String()
            Time = (dict.value(forKey: "event_time") as? String)!
            
            cell.eventdateLbl.text = dateTime + " " + Time
            var price = Int()
            price = dict.value(forKey: "price_per_sit") as! Int
            
            var eventprice = String()
            eventprice = String(price)
            
            cell.evnentPriceLbl.text =  "$" + eventprice
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == upcomingEventCollection {
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
        }else {
            var dict = NSDictionary()
            dict = response1.object(at: indexPath.row) as! NSDictionary
            eventid = dict.value(forKey: "id") as? Int
            evntuserid = dict.value(forKey: "user_id") as? Int
            let defaults = UserDefaults.standard
            defaults.set(eventid, forKey: "EventID")
            defaults.set(evntuserid, forKey: "EventUserID")
            defaults.synchronize()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventAllDetailsViewController") as! EventAllDetailsViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated:  true)
    }
    @IBAction func evnetViewAllBtnAction(_ sender: Any) {
    }
    @IBAction func upcomingViewAllBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UpcomingEventsViewController") as! UpcomingEventsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func pastViewAllBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PastViewController") as! PastViewController
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
