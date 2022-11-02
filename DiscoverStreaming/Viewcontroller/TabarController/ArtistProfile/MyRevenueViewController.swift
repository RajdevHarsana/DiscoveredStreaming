//
//  MyRevenueViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class MyRevenueViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

   
    @IBOutlet weak var Searchtxt: UISearchBar!
    @IBOutlet weak var short_btn: UIButton!
    @IBOutlet weak var songRevenueTable: UITableView!
    
    
    @IBOutlet weak var shortView: UIView!
    @IBOutlet weak var shortViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var revenueEventListHieghtCons: NSLayoutConstraint!
    @IBOutlet weak var ascending_btn: UIButton!
    @IBOutlet weak var descending_btn: UIButton!
    @IBOutlet weak var apply_btn: UIButton!
    @IBOutlet weak var clear_btn: UIButton!
    
    var response = NSMutableArray()
    var defaults:UserDefaults!
    var user_Id:Int!
    var str_lat:String!
    var str_long:String!
    var isCall = Bool()
    var searchplace = String()
    
    
    var searchTextField: UITextField? {
              let subViews = self.Searchtxt.subviews.first?.subviews.last?.subviews
              return subViews?.first as? UITextField
      }
    
    var ordertype:String!
    var sortorder:String!
    var sortarray = NSMutableArray()
    var dict = [String: Any]()
    
    var genre:String!
    var rating:Int!
    var viewers:Int!
    var strdate:String!
    var enddate:String!
    var Price:String!
    var apicall:String!
    var distance:String!
    var venueid:Int!
    var venueName:String!
    var eventid:Int!
    var slooooooooooot = Int()
    var APICall = Bool()
    var type:String!
    var shortType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        venueid = defaults.integer(forKey: "ARVenID")
        slooooooooooot = 0
        self.shortType = ""
        self.songRevenueTable.delegate = self
        self.songRevenueTable.dataSource = self
        self.revenueArtistListApi()
        self.shortView.isHidden = true
        self.revenueEventListHieghtCons.constant = 571
        self.shortViewHeightCons.constant = 0
        let myColor : UIColor = UIColor.gray
        self.shortView.layer.borderWidth = 1
        self.shortView.layer.borderColor = myColor.cgColor
        self.shortView.layer.cornerRadius = 10
        self.apply_btn.layer.cornerRadius = 10
        self.clear_btn.layer.cornerRadius = 10
        self.Searchtxt.delegate = self
        if #available(iOS 13.0, *) {
            searchTextField?.placeholder = "Search..."
            self.searchTextField?.textAlignment = NSTextAlignment.left
            searchTextField?.textColor = UIColor.white
            searchTextField?.backgroundColor = UIColor.clear
            searchTextField?.borderStyle = .none
            searchTextField?.clearButtonMode = .never
            searchTextField?.textAlignment = NSTextAlignment.left
        } else {
        let searchfield = self.Searchtxt.subviews[0].subviews.last as! UITextField
            searchfield.placeholder = " Search..."
            searchfield.textColor = UIColor.white
            searchfield.backgroundColor = UIColor.clear
            searchfield.borderStyle = .none
            searchfield.clearButtonMode = .never
            searchfield.textAlignment = NSTextAlignment.left
        }
        // Do any additional setup after loading the view.
    }
    
    func revenueArtistListApi(){
        if !isCall
        {
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
            parameterDictionary.setValue(DataManager.getVal(self.slooooooooooot), forKey: "offset")
            parameterDictionary.setValue(DataManager.getVal(self.Searchtxt.text), forKey: "search")
            parameterDictionary.setValue(DataManager.getVal(self.shortType), forKey: "filter")
            print(parameterDictionary)
            
            let methodName = "songsRevenue"
            
            DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                if status == "0" {
                    self.APICall = false
                    self.removeAllOverlays()
                    self.response.removeAllObjects()
                    self.songRevenueTable.reloadData()
                }else{
                var arr_data = NSMutableArray()
                  arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                  self.APICall = true
                  if arr_data.count != 0 {
                  self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                  self.slooooooooooot = self.slooooooooooot + 10
                }
                self.songRevenueTable.reloadData()
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            slooooooooooot = 0
            APICall = true
            self.response.removeAllObjects()
        if self.Searchtxt.text == "" {
            self.revenueArtistListApi()
            }else {
            self.revenueArtistListApi()
            }
            searchBar.resignFirstResponder()
        }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchplace = searchText
            if searchplace == searchText{
            self.slooooooooooot = 0
            self.response.removeAllObjects()
            self.revenueArtistListApi()
            self.songRevenueTable.reloadData()
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
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Event Found"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SongRevenueCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.revenueSong_Img.sd_setImage(with: URL(string: (dict.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        cell.revenueSongName_Lbl.text = dict.value(forKey: "song_name") as? String
        cell.revenueSongDate_Lbl.text = dict.value(forKey: "release_date") as? String
        var price = String()
        price = dict.value(forKey: "total_revenue") as? String ?? ""
        cell.revenueSongPrice_Lbl.text =  "$ " + price
        cell.layer.cornerRadius = 10
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var dict = NSDictionary()
//        dict = response.object(at: indexPath.row) as! NSDictionary
//        eventid = dict.value(forKey: "event_id") as? Int
//        venueName = dict.value(forKey: "event_title") as? String ?? ""
//        let defaults = UserDefaults.standard
//        defaults.set(eventid, forKey: "EventID")
//        defaults.set(venueName, forKey: "EventTitle")
//        defaults.synchronize()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventRevenueTicketViewController") as! EventRevenueTicketViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
            revenueArtistListApi()
        }
    }
    
    @IBAction func ascendingBtnAction(_ sender: UIButton) {
        self.ascending_btn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        self.descending_btn.setImage(UIImage(named: "radio_icon"), for: .normal)
        if ascending_btn.isSelected == false{
            self.shortType = "ASC"
        }else{
            self.shortType = ""
        }
        
    }
    
    
    @IBAction func descendingBtnAction(_ sender: UIButton) {
        self.descending_btn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        self.ascending_btn.setImage(UIImage(named: "radio_icon"), for: .normal)
        if descending_btn.isSelected == false{
            self.shortType = "DESC"
        }else{
            self.shortType = ""
        }
    }
    
    @IBAction func applyBtnAction(_ sender: UIButton) {
        self.slooooooooooot = 0
        self.response.removeAllObjects()
        self.revenueArtistListApi()
        self.shortView.isHidden = true
        self.revenueEventListHieghtCons.constant = 571
        self.shortViewHeightCons.constant = 0
    }
    
    @IBAction func clearBtnAction(_ sender: UIButton) {
        self.shortType = ""
        self.slooooooooooot = 0
        self.response.removeAllObjects()
        self.revenueArtistListApi()
        self.shortView.isHidden = true
        self.revenueEventListHieghtCons.constant = 571
        self.shortViewHeightCons.constant = 0
        self.descending_btn.setImage(UIImage(named: "radio_icon"), for: .normal)
        self.ascending_btn.setImage(UIImage(named: "radio_icon"), for: .normal)
    }
    
    @IBAction func short_btn_Action(_ sender: UIButton) {
        self.shortView.isHidden = false
        self.revenueEventListHieghtCons.constant = 423
        self.shortViewHeightCons.constant = 140
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated:true)
    }
    
}
