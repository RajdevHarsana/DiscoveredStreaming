//
//  AddPlaylistView.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 12/03/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class AddPlaylistView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    
    
    var buttonCancleHandler : (() -> Void)?
    var buttonCreateHandler : (() -> Void)?
    @IBOutlet weak var playlistTableview: UITableView!
    
    var userid:Int!
    var defaults:UserDefaults!
    var songId:Int!
    var response = NSMutableArray()
    class func intitiateFromNib() -> AddPlaylistView {
        let View1 = UINib.init(nibName: "AddPlaylistView", bundle: nil).instantiate(withOwner: self, options: nil).first as! AddPlaylistView
        return View1
    }
    
    @objc func DiscoverPlayListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverMyplayList"), object: nil)
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.playlistTableview.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverMyplayList"), object: nil)
                
                
            }
        }
    }
    
    @objc func DiscoverCreatePlayListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateplayList"), object: nil)
            
            }
            else{
                Parsing().DiscoverMyplayList(UserId: self.userid)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverMyplayList"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverPlayListAction), name: NSNotification.Name(rawValue: "DiscoverMyplayList"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateplayList"), object: nil)
                
                
            }
        }
    }
    
    
    @objc func DiscoverAddSongPlayListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAddSongPlayList"), object: nil)
                
            }
            else{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                Parsing().DiscoverMyplayList(UserId: self.userid)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverMyplayList"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverPlayListAction), name: NSNotification.Name(rawValue: "DiscoverMyplayList"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAddSongPlayList"), object: nil)
                
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaults = UserDefaults.standard
        userid = defaults.integer(forKey: "UserIDGet")
        songId = defaults.integer(forKey: "Song_Id")
        playlistTableview.delegate = self
        playlistTableview.dataSource = self
        
        
        let nib = UINib(nibName: "AddPlayCell", bundle: nil)
        self.playlistTableview.register(nib, forCellReuseIdentifier: "cell")
        
        Parsing().DiscoverMyplayList(UserId: userid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverMyplayList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverPlayListAction), name: NSNotification.Name(rawValue: "DiscoverMyplayList"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddPlayCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.listnameLbl.text = dict.value(forKey: "playlist_name") as? String
        cell.imgeview.sd_setImage(with: URL(string: (dict.value(forKey: "playlist_image") as? String)!), placeholderImage: UIImage(named: "Playlist"))
        cell.addBtn.tag = indexPath.row
        cell.addBtn.addTarget(self, action: #selector(HandleTap(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func HandleTap(_ sender:UIButton) {
        var dict = NSDictionary()
        dict = response.object(at: sender.tag) as! NSDictionary
        var playlistid:Int!
        playlistid = dict.value(forKey: "id") as? Int
        
        Parsing().DiscoverAddSongPlayList(UserId: userid, SongId: songId, PlaylistId: playlistid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAddSongPlayList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverAddSongPlayListAction), name: NSNotification.Name(rawValue: "DiscoverAddSongPlayList"), object: nil)
    }

    @IBAction func cancleBtnAction(_ sender: Any) {
        buttonCancleHandler?()
    }
    @IBAction func createBtnAction(_ sender: Any) {
        let nextview = CreatePlayListView.intitiateFromNib()
        let model = NewPopModel()
        nextview.buttonCancleHandler = {
            model.closewithAnimation()
        }
        nextview.buttonDonehandler = { (playlistname) in
            Parsing().DiscoverCreateplayList(UserId: self.userid, ListName: playlistname)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateplayList"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverCreatePlayListAction), name: NSNotification.Name(rawValue: "DiscoverCreateplayList"), object: nil)
            model.closewithAnimation()
        }
        model.show(view: nextview)
        
    }
}
