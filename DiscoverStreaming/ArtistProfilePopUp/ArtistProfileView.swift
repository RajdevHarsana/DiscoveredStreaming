//
//  ArtistProfileView.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 21/11/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit


class ArtistProfileView: UIView,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var arnameLbl: UILabel!
    @IBOutlet weak var bandTableview: UITableView!
     var response1:NSMutableArray!
    var banduserid:Int!
    var bandiD:Int!
    var buttonCancleHandler : (() -> Void)?
    var buttonCloseHandler : (() -> Void)?
    var bandname:String!
    var bandimage:String!
    var name:String!
    var image:String!
    class func intitiateFromNib() -> ArtistProfileView {
        let View1 = UINib.init(nibName: "ArtistProfileView", bundle: nil).instantiate(withOwner: self, options: nil).first as! ArtistProfileView
        return View1
    }
    
    
    @objc func DiscoverGetUserRoleAction1(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                
            }
            else{
                var response = NSDictionary()
                response = (notification.userInfo?["artist_detail"] as? NSDictionary)!
                self.arnameLbl.text = response.value(forKey: "artist_name") as? String
                self.name = response.value(forKey: "artist_name") as? String
                self.image = response.value(forKey: "artist_image") as? String
                self.response1 =  (notification.userInfo?["band_list"] as? NSMutableArray)!
                self.bandTableview.reloadData()
                
                
               
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bandTableview.delegate = self
        bandTableview.dataSource = self
        response1 = NSMutableArray()
        bandTableview.backgroundColor = UIColor(red: 22/255, green: 34/255, blue: 52/255, alpha: 1.0)
        
        let nib = UINib(nibName: "SelBandCell", bundle: nil)
        self.bandTableview.register(nib, forCellReuseIdentifier: "cell")
        
        if Reachability.isConnectedToNetwork() == true{
            Parsing().DiscoverProfileArtistBandList1()
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverGetUserRoleAction1), name: NSNotification.Name(rawValue: "DiscoverProfileArtistBandList1"), object: nil)
        }else{
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if response1.count>0
        {
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Bands Found"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelBandCell
        var dict = NSDictionary()
        dict = response1.object(at: indexPath.row) as! NSDictionary
        cell.bandnameLbl.text = dict.value(forKey: "band_name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response1.object(at: indexPath.row) as! NSDictionary
        banduserid = dict.value(forKey: "band_user_id") as? Int
        bandiD = dict.value(forKey: "id") as? Int
        bandname = dict.value(forKey: "band_name") as? String
        bandimage = dict.value(forKey: "band_image") as? String
        var str = String()
        str = "Bandi"
      
        let defaults = UserDefaults.standard
        defaults.set(banduserid, forKey: "BNDID")
        defaults.set(bandiD, forKey: "BANDID")
        defaults.set(bandname, forKey: "BNDNAME")
        defaults.set(bandimage, forKey: "BNDIMG")
        defaults.set(str, forKey: "ARTI")
        defaults.synchronize()
        buttonCloseHandler?()
    }
    
    @IBAction func artistBtnAction(_ sender: Any) {
        var type:String!
        type = "Arti"
        let defaults = UserDefaults.standard
        defaults.set(type, forKey: "ARTI")
        defaults.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("ArProfile"), object: nil)
        buttonCancleHandler?()
    }
    
    @IBAction func cancleBtnAction(_ sender: Any) {
        buttonCancleHandler?()
    }
    
}
