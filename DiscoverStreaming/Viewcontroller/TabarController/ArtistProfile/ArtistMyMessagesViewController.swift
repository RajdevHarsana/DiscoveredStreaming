//
//  ArtistMyMessagesViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class ArtistMyMessagesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    

    @IBOutlet weak var bandInviteTable: UITableView!
//    @IBOutlet weak var messageCell: UITableView!
    var userId:Int!
    var ArtistId:Int!
    var defaults:UserDefaults!
    var response:NSMutableArray!
    var postType:String!
    //MARK:- Login WebService
    @objc func DiscoverBandInvitaionAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.bandInviteTable.reloadData()
                 self.response.removeAllObjects()
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.bandInviteTable.reloadData()
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
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestNotification"), object: nil)
                self.bandInviteTable.reloadData()
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
                Parsing().DiscoverBandInvitation(user_Id: self.userId, ArtistId: self.ArtistId, Invitetype: self.postType)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBandInvitaionAction), name: NSNotification.Name(rawValue: "DiscoverBandInvitation"), object: nil)
                self.bandInviteTable.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestNotification"), object: nil)
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
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestNotification"), object: nil)
                self.bandInviteTable.reloadData()
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
                Parsing().DiscoverBandInvitation(user_Id: self.userId, ArtistId: self.ArtistId, Invitetype: self.postType)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBandInvitaionAction), name: NSNotification.Name(rawValue: "DiscoverBandInvitation"), object: nil)
                self.bandInviteTable.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestNotification"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        ArtistId = defaults.integer(forKey: "ARNewID")
        postType = defaults.value(forKey: "postType") as? String
        response = NSMutableArray()
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            Parsing().DiscoverBandInvitation(user_Id: userId, ArtistId: ArtistId, Invitetype: postType)
             NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBandInvitaionAction), name: NSNotification.Name(rawValue: "DiscoverBandInvitation"), object: nil)
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
        

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        if tableView == bandInviteTable {
        var numOfSections: Int = 0
        if response.count>0
        {
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Invites Found"
            
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
//        }else {
//            return 1
//        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == bandInviteTable {
            return response.count
//        }else {
//            return 8
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == bandInviteTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BandInvitationCell
            var dict = NSDictionary()
            dict = response.object(at: indexPath.row) as! NSDictionary
            cell.bandImageView.sd_setImage(with: URL(string: (dict.value(forKey: "band_image") as? String)!), placeholderImage: UIImage(named: "Artist_img_3"))
            cell.bandNameLbl.text = dict.value(forKey: "band_name") as? String
            cell.rejectBtn.tag = indexPath.row
            cell.rejectBtn.addTarget(self, action: #selector(HandleTap(_:)), for: .touchUpInside)
            cell.acceptBtbn.tag = indexPath.row
            cell.acceptBtbn.addTarget(self, action: #selector(HandleTap1(_:)), for: .touchUpInside)
            return cell
//        }else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArtistMessageCell
//            return cell
//        }
    }
    
    @objc func HandleTap(_ sender:UIButton) {
        var btn = sender as? UIButton
        let dict1 = response.object(at: (btn?.tag)!) as! NSDictionary
        
        let s_id = dict1.object(forKey: "id") ?? NSString()
        
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            Parsing().DiscoverAcceptRejectRequest(ID: s_id as? Int, ArtistId: ArtistId, JoinStatus: 0, UserId: userId, StatusType: "band")
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestNotification"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverRejectRequestAction), name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestNotification"), object: nil)
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
    @objc func HandleTap1(_ sender:UIButton) {
        var btn = sender as? UIButton
        let dict1 = response.object(at: (btn?.tag)!) as! NSDictionary
        
        let s_id = dict1.object(forKey: "id") ?? NSString()
        
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            Parsing().DiscoverAcceptRejectRequest(ID: s_id as? Int, ArtistId: ArtistId, JoinStatus: 1, UserId: userId, StatusType: "band")
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestNotification"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverAcceptRequestAction), name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestNotification"), object: nil)
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
    
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}
