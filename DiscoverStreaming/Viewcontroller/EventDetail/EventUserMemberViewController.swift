//
//  EventUserMemberViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class EventUserMemberViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var eventMembertable: UITableView!
    var response:NSMutableArray!
    var defaults:UserDefaults!
    var userId:Int!
    var BandId:Int!
    var ArtistId:Int!
    var ArtistUserId: Int!
    var artistName: String!
    
    //MARK:- Login WebService
    @objc func DiscoverBandMemberAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.eventMembertable.reloadData()
            }
            else{
                self.response = (notification.userInfo?["artist_list"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.eventMembertable.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        BandId = defaults.integer(forKey: "BandID")
        
        response = NSMutableArray()
        
        if Reachability.isConnectedToNetwork() == true {
            
            showWaitOverlay()
            Parsing().DiscoverGetMemberList(UserId: userId, GetType: "artist_band", GetTypeId: BandId)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBandMemberAction), name: NSNotification.Name(rawValue: "DiscoverGetMemberList"), object: nil)
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
        

        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
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
            noDataLabel.text          = "No Member Found"
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventUserMemberCell
        cell.layer.cornerRadius = 10
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        var listype:String!
        listype = dict.value(forKey: "list_type") as? String
        if listype == "artist" {
            cell.memberImageview.sd_setImage(with: URL(string: (dict.value(forKey: "artist_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.membernameLbl.text = dict.value(forKey: "artist_name") as? String
            var viewer:Int!
            viewer = dict.value(forKey: "viewer") as? Int
            var viewlb:String!
            viewlb = String(viewer)
            cell.viewLbl.text = viewlb
            var rating: NSNumber!
            rating = dict.value(forKey: "rating") as? NSNumber
             
            cell.ratingView.rating = Float(truncating: rating)
            var rateper:Int!
            rateper =  dict.value(forKey: "rating_percentage") as? Int
            
             var rate = String()
             rate = String(rateper)
            
             cell.ratingperLbl.text =  rate + "%"
        }else {
            cell.memberImageview.sd_setImage(with: URL(string: (dict.value(forKey: "band_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.membernameLbl.text = dict.value(forKey: "band_name") as? String
            var viewer:Int!
            viewer = dict.value(forKey: "viewer") as? Int
            var viewlb:String!
            viewlb = String(viewer)
            cell.viewLbl.text = viewlb
            var rating: NSNumber!
            rating = dict.value(forKey: "rating") as? NSNumber
            
            cell.ratingView.rating = Float(truncating: rating)
            var rateper:Int!
            rateper =  dict.value(forKey: "rating_percentage") as? Int
           
             var rate = String()
             rate = String(rateper)
           
             cell.ratingperLbl.text =  rate + "%"
        }
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

}
