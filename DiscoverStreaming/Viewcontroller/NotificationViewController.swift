//
//  NotificationViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 05/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var notificationTableview: UITableView!
    var data_Array = [Any]()
    var slooooooooooot = Int()
    var APICall = Bool()
    var defaults:UserDefaults!
    var user_Id = Int()
    var notiType = String()
    var notiTypeId = Int()
    var notificationRefreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            self.notificationRefreshControl = UIRefreshControl()
            self.notificationRefreshControl.tintColor = UIColor.systemPink
//            self.venueRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.notificationRefreshControl.addTarget(self,action: #selector(self.refreshNotificationList),for: .valueChanged)
            self.notificationTableview.addSubview(self.notificationRefreshControl)
        }
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        slooooooooooot = 0
        APICall = true
        self.NotificationMsg_API()
        self.notificationTableview.estimatedRowHeight = 90
        self.notificationTableview.rowHeight = 90
        self.notificationTableview.dataSource = self
        self.notificationTableview.delegate = self
        self.notificationTableview.tableFooterView = UIView()
        self.notificationTableview.sectionHeaderHeight = 0
        self.notificationTableview.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshNotificationList(sender: UIRefreshControl) {
       // Code to refresh table view
        self.notificationTableview.reloadData()
        self.notificationRefreshControl.endRefreshing()
        self.NotificationMsg_API()
    }
    
    func NotificationMsg_API(){
        
        self.showWaitOverlay()
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
        parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
        print(parameterDictionary)
        
        let methodName = "notification_list"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                DispatchQueue.main.async {
                    if status == "0" {
                        self.APICall = false
                        self.removeAllOverlays()
                        self.notificationTableview.reloadData()
                    }else{
                        self.data_Array = DataManager.getVal(responseData?.object(forKey: "data")) as? [Any] ?? []
                        self.notificationTableview.reloadData()
                        self.removeAllOverlays()
                    }
                    
                }
                self.removeAllOverlays()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if data_Array.count>0
        {
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
            self.notificationTableview.addSubview(notificationRefreshControl)
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Notification Found"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationCell
        let dict = DataManager.getVal(self.data_Array[indexPath.row]) as! NSDictionary
        cell.msg_Lbl.text = dict.value(forKey: "message") as? String
        cell.time_lbl.text = dict.value(forKey: "notification_date") as? String
        cell.msg_Img.image = UIImage(named: "chat_icon")
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 60
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = DataManager.getVal(self.data_Array[indexPath.row]) as! NSDictionary
        self.notiType = dict.value(forKey: "type") as? String ?? ""
        self.notiTypeId = dict.value(forKey: "type_id") as? Int ?? 0
        if self.notiType == "song_download"{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ManageSongDetailViewController") as! ManageSongDetailViewController
            let flag = true
            vc.flag = flag
            vc.typeID = notiTypeId
            navigationController?.pushViewController(vc, animated: true)
        }else if self.notiType == "ticket_booking"{
            let vc = storyboard?.instantiateViewController(withIdentifier: "EventAllDetailsViewController") as! EventAllDetailsViewController
            let flag = true
            vc.flag = flag
            vc.typeID = notiTypeId
            navigationController?.pushViewController(vc, animated: true)
        }else if self.notiType == "register"{
            let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if self.notiType == "subscription_plan"{
//            let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationSettingViewController") as! NotificationSettingViewController
//            navigationController?.pushViewController(vc, animated: true)
        }else if self.notiType == "featured_artist"{
//            let vc = storyboard?.instantiateViewController(withIdentifier: "FeturedArtistsViewController") as! FeturedArtistsViewController
//            navigationController?.pushViewController(vc, animated: true)
        }else if self.notiType == "featured_song_package"{
            let vc = storyboard?.instantiateViewController(withIdentifier: "FeaturedSongPackageViewController") as! FeaturedSongPackageViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if self.notiType == "featured_song"{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ManageSongDetailViewController") as! ManageSongDetailViewController
            let flag = true
            vc.flag = flag
            vc.typeID = notiTypeId
            navigationController?.pushViewController(vc, animated: true)
        }else if self.notiType == "active_promotional_package"{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ActiveVenuePlanViewController") as! ActiveVenuePlanViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if self.notiType == "song_like"{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ManageSongDetailViewController") as! ManageSongDetailViewController
            let flag = true
            vc.flag = flag
            vc.typeID = notiTypeId
            navigationController?.pushViewController(vc, animated: true)
        }else if self.notiType == "venue_approved"{
            let vc = storyboard?.instantiateViewController(withIdentifier: "VenueDetailViewController") as! VenueDetailViewController
            let flag = true
            vc.notiFrom = flag
            vc.notiId = notiTypeId
            navigationController?.pushViewController(vc, animated: true)
        }else if self.notiType == "venue_rejected"{
//            let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationSettingViewController") as! NotificationSettingViewController
//            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func nackBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationSettingViewController") as! NotificationSettingViewController
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
