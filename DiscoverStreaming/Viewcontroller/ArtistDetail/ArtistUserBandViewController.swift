//
//  ArtistUserBandViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast


class ArtistUserBandViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var ArtistBandTable: UITableView!
    @IBOutlet weak var createbandBtn: UIButton!
    
    @IBOutlet weak var createBandImage: UIImageView!
    @IBOutlet weak var bandBtnHeightCons: NSLayoutConstraint!
    var defaults:UserDefaults!
    var user_Id:Int!
    var response:NSMutableArray!
    var artistId:Int!
    var artistUserId:Int!
    var bandid:Int!
    var banduserid:Int!
    var bandName:String!
    var bandRefreshControl: UIRefreshControl!
    
    @IBOutlet weak var notFoundLbl: UILabel!
    //MARK:- Login WebService
    @objc func DiscoverBandListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
//                self.ArtistBandTable.isHidden = true
//                self.notFoundLbl.isHidden = false
                self.ArtistBandTable.reloadData()
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.ArtistBandTable.reloadData()
                self.ArtistBandTable.isHidden = false
                self.notFoundLbl.isHidden = true
                self.removeAllOverlays()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
        if #available(iOS 10.0, *) {
            self.bandRefreshControl = UIRefreshControl()
            self.bandRefreshControl.tintColor = UIColor.systemPink
//            self.venueRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.bandRefreshControl.addTarget(self,action: #selector(self.refreshBandList),for: .valueChanged)
            self.ArtistBandTable.addSubview(self.bandRefreshControl)
        }
        }
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        artistId = defaults.integer(forKey: "ArtistID")
        artistUserId = defaults.integer(forKey: "ArUserId")

        
        if artistUserId == user_Id {
          self.createBandImage.isHidden = false
          self.bandBtnHeightCons.constant = 70
            
        }else {
            self.createBandImage.isHidden = true
            self.bandBtnHeightCons.constant = 0
        }
        
        response = NSMutableArray()
        notFoundLbl.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("CreateBand"), object: nil)
        
        if Reachability.isConnectedToNetwork() == true{
        showWaitOverlay()
        Parsing().DiscoverBandListing(user_Id: user_Id, ArtistId: artistId)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBandListAction), name: NSNotification.Name(rawValue: "DiscoverBandListing"), object: nil)
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
        }
        

        // Do any additional setup after loading the view.
    }
    
    @objc func refreshBandList(sender: UIRefreshControl) {
       // Code to refresh table view
        self.ArtistBandTable.reloadData()
        self.bandRefreshControl.endRefreshing()
        if Reachability.isConnectedToNetwork() == true{
        showWaitOverlay()
        Parsing().DiscoverBandListing(user_Id: user_Id, ArtistId: artistId)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBandListAction), name: NSNotification.Name(rawValue: "DiscoverBandListing"), object: nil)
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
        }
    }

    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        if Reachability.isConnectedToNetwork() == true {
        showWaitOverlay()
        Parsing().DiscoverBandListing(user_Id: user_Id, ArtistId: artistId)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBandListAction), name: NSNotification.Name(rawValue: "DiscoverBandListing"), object: nil)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if response.count>0
        {
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
            self.ArtistBandTable.addSubview(bandRefreshControl)
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Bands Found"
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArtistUserbandCell
      
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.bandNameLbl.text = dict.value(forKey: "band_name") as? String
        cell.bandImageView.sd_setImage(with: URL(string: (dict.value(forKey: "band_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        
       
        
        var ArtistCount = Int()
        ArtistCount =  (dict.value(forKey: "invited_artist") as? Int)!
        
        var countArtrist = String()
        countArtrist = String(ArtistCount)
        
        cell.bandArtistLbl.text = countArtrist + "  Artist"
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        bandid = dict.value(forKey: "id") as? Int
        banduserid = dict.value(forKey: "user_id") as? Int
        bandName = dict.value(forKey: "band_name") as? String
        let defaults = UserDefaults.standard
        defaults.set(bandid, forKey: "BandID")
        defaults.set(banduserid, forKey: "BandUserID")
        defaults.set(bandName, forKey: "BandName")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func createBandBtnAction(_ sender: Any) {
        var str = String()
        str = "Add"
        let defaults = UserDefaults.standard
        defaults.set(artistId, forKey: "ArtistID")
        defaults.set(str, forKey: "AREDIT")
        defaults.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArtistCreateBandViewController") as! ArtistCreateBandViewController
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
