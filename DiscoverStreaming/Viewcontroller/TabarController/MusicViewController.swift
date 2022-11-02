//
//  MusicViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class MusicViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var musicTableview: UITableView!
    var response = NSMutableArray()
    var userid:Int!
    var defaults:UserDefaults!
    
    @IBOutlet weak var downloadSongLbl: UILabel!
    @IBOutlet weak var likeSongLbl: UILabel!
    @IBOutlet weak var favSongLbl: UILabel!
    @IBOutlet weak var purchaseSongLbl: UILabel!
    @IBOutlet weak var musicTableHeightConst: NSLayoutConstraint!
    
    var download:Int!
    var Fav:Int!
    var like:Int!
    var purchase:Int!
    
    @objc func DiscoverPlayListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        self.download = (notification.userInfo?["download"] as? Int)!
        self.like = (notification.userInfo?["like"] as? Int)!
        self.purchase = (notification.userInfo?["purchase"] as? Int)!
        self.Fav = (notification.userInfo?["favourite"] as? Int)!
        var str_like:String!
        str_like = String(self.like)
        var str_Fav:String!
        str_Fav = String(self.Fav)
        var str_download:String!
        str_download = String(self.download)
//        self.downloadSongLbl.text = str_like + " " + "Songs"
        self.likeSongLbl.text = str_like + " " + "Songs"
        self.favSongLbl.text = str_Fav + " " + "Songs"
       // var str_purchase:String!
       // str_purchase = String(self.purchase)
       // self.purchaseSongLbl.text = str_download + " " + "Songs"
        DispatchQueue.main.async() {
            if status == 0{
                self.musicTableview.isHidden = true
                self.musicTableHeightConst.constant = 0
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverMyplayList"), object: nil)
                self.removeAllOverlays()
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                if self.response.count == 0 {
                    self.musicTableview.isHidden = true
                    self.musicTableHeightConst.constant = 0
                }else {
                    self.musicTableview.isHidden = false
                    self.musicTableHeightConst.constant = 214
                }
                print("response: \(String(describing: self.response))")
                self.musicTableview.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverMyplayList"), object: nil)
                self.removeAllOverlays()
                
            }
        }
    }
    
    @objc func DiscoverCreatePlayListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateplayList"), object: nil)
                self.removeAllOverlays()
            }
            else{
                self.showWaitOverlay()
                Parsing().DiscoverMyplayList(UserId: self.userid)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverMyplayList"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverPlayListAction), name: NSNotification.Name(rawValue: "DiscoverMyplayList"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateplayList"), object: nil)
                self.removeAllOverlays()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults = UserDefaults.standard
        userid = defaults.integer(forKey: "UserIDGet")
        
       

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().DiscoverMyplayList(UserId: userid)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverMyplayList"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverPlayListAction), name: NSNotification.Name(rawValue: "DiscoverMyplayList"), object: nil)
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
            noDataLabel.text          = "No Playlist Available"
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaylistCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.playlistName.text = dict.value(forKey: "playlist_name") as? String
        var Count:Int!
        Count = dict.value(forKey: "song_count") as? Int
        var CountStr:String!
        CountStr = String(Count)
        cell.songcountLbl.text = CountStr + " " + "Songs"
        cell.playlistImage.sd_setImage(with: URL(string: (dict.value(forKey: "playlist_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        var playlistId:Int!
        playlistId = dict.value(forKey: "id") as? Int
        var name:String!
        name = dict.value(forKey: "playlist_name") as? String
        let defaults = UserDefaults.standard
        defaults.set(playlistId, forKey: "PlayListID")
        defaults.set(name, forKey: "PlayListName")
        defaults.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlaylistSongViewController") as! PlaylistSongViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func downloadSongBtnAction(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyDownloadsViewController") as! MyDownloadsViewController
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func LikedSongBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LikedSongsViewController") as! LikedSongsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func MyFavBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyFavouriteListViewController") as! MyFavouriteListViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func PurchaseSongBtnAction(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyDownloadsViewController") as! MyDownloadsViewController
//        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func createPlayListBtnAction(_ sender: Any) {
        let nextview = CreatePlayListView.intitiateFromNib()
        let model = NewPopModel()
        nextview.buttonCancleHandler = {
            model.closewithAnimation()
        }
        nextview.buttonDonehandler = { (playlistname) in
            self.showWaitOverlay()
            Parsing().DiscoverCreateplayList(UserId: self.userid, ListName: playlistname)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateplayList"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverCreatePlayListAction), name: NSNotification.Name(rawValue: "DiscoverCreateplayList"), object: nil)
            model.closewithAnimation()
        }
        model.show(view: nextview)
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
