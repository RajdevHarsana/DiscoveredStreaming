//
//  PlaylistSongViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import CoreLocation
import AVFoundation

class PlaylistSongViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,AVAudioPlayerDelegate {
   

    @IBOutlet weak var playListtableview: UITableView!
    var response = NSMutableArray()
    var userid:Int!
    var defaults:UserDefaults!
    var str_lat:String!
    var str_long:String!
    var Manager: CLLocationManager!
    var isCall = Bool()
    var slooooooooooot = Int()
    var APICall = Bool()
    var myindexpath = NSIndexPath()
    var songId:Int!
    var listtypeId:Int!
    var playlistName:String!
    
    var SongID:Int!
    var selectedMusic = 0
    var myCustomView: PlayerView?
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var dataArray = [Any]()
    var updateTimer = Timer()
    var likeSts:Int!
    var likeCount:Int!
    var UnlikeSts:Int!
    var UnlikeCount:Int!
    var audioPlayer = AVAudioPlayer()
    var currentAudioPath:URL!
    
    @IBOutlet weak var playlistnameLbl: UILabel!
    @IBOutlet weak var playAllBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        userid = defaults.integer(forKey: "UserIDGet")
        listtypeId = defaults.integer(forKey: "PlayListID")
        str_lat = defaults.value(forKey: "LAT") as? String
        str_long = defaults.value(forKey: "LONG") as? String
        playlistName = defaults.value(forKey: "PlayListName") as? String
        playlistnameLbl.text = playlistName
        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
        self.PlayListApi()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func PlayListApi(){
          if !isCall
          {
              if Reachability.isConnectedToNetwork() == true{
                  showWaitOverlay()
                  let parameterDictionary = NSMutableDictionary()
                  parameterDictionary.setObject(DataManager.getVal(self.userid), forKey: "user_id" as NSCopying)
                  parameterDictionary.setValue(DataManager.getVal(""), forKey: "as_type")
                  parameterDictionary.setValue(DataManager.getVal(""), forKey: "as_type_id")
                  parameterDictionary.setValue(DataManager.getVal("playlist_songs"), forKey: "list_type")
                  parameterDictionary.setValue(DataManager.getVal(str_lat), forKey: "lat")
                  parameterDictionary.setValue(DataManager.getVal(str_long), forKey: "lng")
                  parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
                  parameterDictionary.setValue(DataManager.getVal(self.listtypeId), forKey: "list_type_id")
                  print(parameterDictionary)
                  
                  let methodName = "song_list"
                  
                  DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                  DispatchQueue.main.async(execute: {
                      let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                      let songCount = DataManager.getVal(responseData?.object(forKey: "song_count"))  as? Int ?? 0
    
                      if status == "1" {
                      var arr_data = NSMutableArray()
                      arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                        
                        if arr_data.count == 0 {
                            self.playAllBtn.isHidden = true
                        }else{
                            self.playAllBtn.isHidden = false
                        }
                        
                      self.APICall = true
                      self.response.removeAllObjects()
                      if arr_data.count != 0 {
                      self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                      self.slooooooooooot = self.slooooooooooot + 10
                      arr_data.removeAllObjects()
                      }
                      self.playListtableview.reloadData()
                      self.removeAllOverlays()

                      }else{
                        self.playAllBtn.isHidden = true
                      if songCount <= 10{
                        self.response.removeAllObjects()
                        self.playListtableview.reloadData()
                        self.removeAllOverlays()
                      }else{
                        self.playListtableview.reloadData()
                        self.removeAllOverlays()
                      }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.myCustomView?.NewSongTblView {
            return self.dataArray.count
        }else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.myCustomView?.NewSongTblView{
            return 60
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == playListtableview{
            return response.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlayListSongCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.songName.text = dict.value(forKey: "song_name") as? String
        cell.songdesLbl.text = dict.value(forKey: "as_type_name") as? String
        cell.song.sd_setImage(with: URL(string: (dict.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        var gen:String!
        gen =  dict.value(forKey: "genres") as? String
        if gen == nil {
            
        }else {
             cell.songdesLbl.text = "Genre:" + " " + gen
        }
       
        cell.songTimeLbl.text = dict.value(forKey: "duration") as? String
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(HandleTap1(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.myCustomView?.NewSongTblView{
            let dict = DataManager.getVal(self.dataArray[section]) as! NSDictionary
            let image = DataManager.getVal(dict["song_image"]) as? String ?? ""
            let artistName = DataManager.getVal(dict["as_type_name"]) as? String ?? ""
            let songName = DataManager.getVal(dict["song_name"]) as? String ?? ""
            let header = UIView()
            header.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 60)
            header.backgroundColor = UIColor.red
            
            let sngImg = UIImageView()
            sngImg.frame = CGRect(x: 8, y: 8, width: 44, height: 44)
            sngImg.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "Group 4-1"))
            header.addSubview(sngImg)
            
            let moreBtn = UIButton()
            moreBtn.frame = CGRect(x: screenWidth-52, y: 8, width: 44, height: 44)
            let Moreimage = UIImage(named: "more_icon")
            moreBtn.setImage(Moreimage, for: .normal)
            header.addSubview(moreBtn)
            
            let downloadBtn = UIButton()
            downloadBtn.frame = CGRect(x: screenWidth-104, y: 8, width: 44, height: 44)
            let Downimage = UIImage(named: "download_icon_bg")
            downloadBtn.setImage(Downimage, for: .normal)
            header.addSubview(downloadBtn)
            
            let titleLbl = UILabel()
            titleLbl.frame = CGRect(x: 60, y: 8, width: screenWidth-172, height: 20)
            titleLbl.text = songName
            titleLbl.textColor = UIColor.white
            header.addSubview(titleLbl)
            
            let titleLbl1 = UILabel()
            titleLbl1.frame = CGRect(x: 60, y: 30, width: screenWidth-172, height: 18)
            titleLbl1.text = artistName
            titleLbl1.textColor = UIColor.white
            header.addSubview(titleLbl1)
            
            let headerButton = UIButton()
            headerButton.frame = CGRect(x: 0, y: 0, width: screenWidth-104, height: 60)
            headerButton.tag = section
            headerButton.addTarget(self, action: #selector(headerButtonAction), for: .touchUpInside)
            
            
            header.addSubview(headerButton)
            return header
        }else{
            return nil
        }
    }
    
    @objc func headerButtonAction(_ sender: UIButton){
        print("Tap on Header")
        let musicPlay = sender.tag
        let dict = DataManager.getVal(self.dataArray[musicPlay]) as! NSDictionary
        print(dict)
        let artistName = DataManager.getVal(dict["as_type_name"]) as? String ?? ""
        let songName = DataManager.getVal(dict["song_name"]) as? String ?? ""
        let songimg = DataManager.getVal(dict["song_image"]) as? String ?? ""
        let song_file = DataManager.getVal(dict["song_file"]) as? String ?? ""
        let duration = DataManager.getVal(dict["duration"]) as? String ?? ""
        let like_unlike_status = DataManager.getVal(dict["like_unlike_status"]) as? String ?? ""
        let favouriteStatus = DataManager.getVal(dict["favouriteStatus"]) as? String ?? ""
        let total_likes = DataManager.getVal(dict["total_likes"]) as? String ?? ""
        let total_unlikes = DataManager.getVal(dict["total_unlikes"]) as? String ?? ""
        self.myCustomView?.LikeCountLbl.text = total_likes
        self.myCustomView?.DislikeCountLbl.text = total_unlikes
        if like_unlike_status == "1"{
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs_up"), for: .normal)
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs_down"), for: .normal)
        }else {
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
        }
        
        if favouriteStatus == "1"{
            self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart-1"), for: .normal)
        }else{
            self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart"), for: .normal)
        }
        //Mini View
        self.myCustomView?.ArtistNameLbl.text = artistName
        self.myCustomView?.MiniSongNameLbl.text = songName
        
        self.myCustomView?.MiniImgView.sd_setImage(with: URL(string: songimg), placeholderImage: UIImage(named: "Group 4-1"))
        
        self.myCustomView?.BottomSongNameLbl.text = songName
        self.myCustomView?.BottomArtistNameLbl.text = artistName
        self.myCustomView?.MaximumTimeLbl.text = duration
        
        self.myCustomView?.BottomImgView.sd_setImage(with: URL(string: songimg), placeholderImage: UIImage(named: "Group 4-1"))
        
        let vc =  song_file.replacingOccurrences(of: " ", with: "")
        let AddPicture_url = URL.init(string: vc)
        print(AddPicture_url!)
        self.currentAudioPath = AddPicture_url
        
        self.downloadFileFromURL3(url: self.currentAudioPath as NSURL)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = DataManager.getVal(self.response[indexPath.row]) as! NSDictionary
        print(dict)
        self.dataArray = self.response as! [Any]
        let artistName = DataManager.getVal(dict["as_type_name"]) as? String ?? ""
        let songName = DataManager.getVal(dict["song_name"]) as? String ?? ""
        let songimg = DataManager.getVal(dict["song_image"]) as? String ?? ""
        let song_file = DataManager.getVal(dict["song_file"]) as? String ?? ""
        let duration = DataManager.getVal(dict["duration"]) as? String ?? ""
        let songid = DataManager.getVal(dict["id"]) as? String ?? ""
        let like_unlike_status = DataManager.getVal(dict["like_unlike_status"]) as? String ?? ""
        let favouriteStatus = DataManager.getVal(dict["favouriteStatus"]) as? String ?? ""
        let total_likes = DataManager.getVal(dict["total_likes"]) as? String ?? ""
        let total_unlikes = DataManager.getVal(dict["total_unlikes"]) as? String ?? ""
        self.myCustomView?.LikeCountLbl.text = total_likes
        self.myCustomView?.DislikeCountLbl.text = total_unlikes
        if like_unlike_status == "1"{
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs_up"), for: .normal)
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
        }else {
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs_down"), for: .normal)
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
        }
        
        if favouriteStatus == "1"{
            self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart-1"), for: .normal)
        }else{
            self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart"), for: .normal)
        }
        
        self.SongID = Int(songid) ?? 0
        self.selectedMusic = indexPath.row
        //            self.SongListAPi(songType:"hot_music")
        let vc =  song_file.replacingOccurrences(of: " ", with: "")
        let AddPicture_url = URL.init(string: vc)
        print(AddPicture_url!)
        self.currentAudioPath = AddPicture_url
        
        
        self.myCustomView?.removeFromSuperview()
        self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
        self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-144, width: self.screenWidth, height: 60)
        self.myCustomView?.BottomView.isHidden = true
        
        //Mini View
        self.myCustomView?.MiniViewHeightConstraint.constant = 60
        self.myCustomView?.ArtistNameLbl.text = artistName
        self.myCustomView?.MiniSongNameLbl.text = songName
        
        self.myCustomView?.MiniImgView.sd_setImage(with: URL(string: songimg), placeholderImage: UIImage(named: "Group 4-1"))
        //Bottom View
        self.myCustomView?.BottomSongNameLbl.text = songName
        self.myCustomView?.BottomArtistNameLbl.text = artistName
        self.myCustomView?.MaximumTimeLbl.text = duration
        
        self.myCustomView?.BottomImgView.sd_setImage(with: URL(string: songimg), placeholderImage: UIImage(named: "Group 4-1"))
        
        self.downloadFileFromURL3(url:currentAudioPath! as NSURL)
        
        
        self.myCustomView?.BigButton.addTarget(self, action: #selector(BigButtonAction), for: .touchUpInside)
        self.myCustomView?.PlayButton.addTarget(self, action: #selector(PlayButtonAction), for: .touchUpInside)
        self.myCustomView?.CrossButton.addTarget(self, action: #selector(CrossButtonAction), for: .touchUpInside)
        self.myCustomView?.SongSlider.addTarget(self, action: #selector(SliderAction), for: .touchUpInside)
        
        self.myCustomView?.PreviousButton.addTarget(self, action: #selector(PreviousButtonAction), for: .touchUpInside)
        self.myCustomView?.PauseAndPlayButton.addTarget(self, action: #selector(PauseAndPlayButtonAction), for: .touchUpInside)
        self.myCustomView?.NextButton.addTarget(self, action: #selector(NextButtonAction), for: .touchUpInside)
        self.myCustomView?.Like_btn.addTarget(self, action: #selector(LikeSongAction), for: .touchUpInside)
        self.myCustomView?.Dislike_btn.addTarget(self, action: #selector(DislikeSongAction), for: .touchUpInside)
        self.myCustomView?.Fav_btn.addTarget(self, action: #selector(FavSongAction), for: .touchUpInside)
        
        self.view.window?.addSubview(self.myCustomView!)

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
            self.PlayListApi()
        }
    }
    
    // MARK: - Custtom view Action
    
    @objc func BigButtonAction(_ sender: UIButton){
        print("Big Button")
        self.myCustomView!.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: screenHeight)
        self.myCustomView?.MiniView.isHidden = true
        self.myCustomView?.MiniViewHeightConstraint.constant = 0
        self.myCustomView?.BottomView.isHidden = false
        if self.audioPlayer.isPlaying{
            let pause = UIImage(named: "pause")
            self.myCustomView?.PauseAndPlayButton.setImage(pause, for: .normal)
        }else{
            let pause = UIImage(named: "play-1")
            self.myCustomView?.PauseAndPlayButton.setImage(pause, for: .normal)
        }
    }
    
    @objc func PlayButtonAction(_ sender: UIButton){
        print("Play Button")
        var dict = NSDictionary()
        dict = DataManager.getVal(self.response[sender.tag]) as! NSDictionary
        let song_file = DataManager.getVal(dict["song_file"]) as? String ?? ""
        let vc =  song_file.replacingOccurrences(of: " ", with: "")
        let AddPicture_url = URL.init(string: vc)
        print(AddPicture_url!)
        currentAudioPath = AddPicture_url
        
        //        sender.isSelected = !sender.isSelected
        if self.audioPlayer.isPlaying{
            let pause = UIImage(named: "play-1")
            self.myCustomView?.PlayButton.setImage(pause, for: .normal)
            self.audioPlayer.pause()
        }else{
            let play = UIImage(named: "pause")
            self.myCustomView?.PlayButton.setImage(play, for: .normal)
            self.audioPlayer.play()
        }
        
    }
    
    @objc func CrossButtonAction(_ sender: UIButton){
        print("Cross Button")
        self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-144, width: self.screenWidth, height: 60)
        self.myCustomView?.MiniView.isHidden = false
        self.myCustomView?.MiniViewHeightConstraint.constant = 60
        self.myCustomView?.BottomView.isHidden = true
        if self.audioPlayer.isPlaying{
            let pause = UIImage(named: "pause")
            self.myCustomView?.PlayButton.setImage(pause, for: .normal)
        }else{
            let pause = UIImage(named: "play-1")
            self.myCustomView?.PlayButton.setImage(pause, for: .normal)
        }
        if self.likeSts == 1 {
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs_up"), for: .normal)
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
        }else {
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
        }
        if self.UnlikeSts == 1 {
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs_down"), for: .normal)
        }else {
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
        }
    }
    @objc func SliderAction(_ sender: UISlider){
        print("Slider")
        self.audioPlayer.currentTime = TimeInterval(sender.value)
        //print(sender.value)
    }
    
    @objc func PreviousButtonAction(_ sender: UIButton){
        DispatchQueue.main.async() {
            if self.selectedMusic != 0 {
                self.selectedMusic = self.selectedMusic - 1
                self.loadUrl()
            }
        }
    }
    
    @objc func PauseAndPlayButtonAction(_ sender: UIButton){
        if self.audioPlayer.isPlaying{
            let pause = UIImage(named: "play-1")
            self.myCustomView?.PauseAndPlayButton.setImage(pause, for: .normal)
            self.audioPlayer.pause()
        }else{
            let play = UIImage(named: "pause")
            self.myCustomView?.PauseAndPlayButton.setImage(play, for: .normal)
            self.audioPlayer.play()
        }
        
    }
    
    @objc func NextButtonAction(_ sender: UIButton){
        DispatchQueue.main.async() {
            if self.selectedMusic + 1 < self.dataArray.count {
                self.selectedMusic = self.selectedMusic + 1
                self.loadUrl()
                if self.audioPlayer.isPlaying{
                    let pause = UIImage(named: "pause")
                    self.myCustomView?.PauseAndPlayButton.setImage(pause, for: .normal)
                }else{
                    let pause = UIImage(named: "play-1")
                    self.myCustomView?.PauseAndPlayButton.setImage(pause, for: .normal)
                }
            }
        }
    }
    
    @objc func LikeSongAction(_ sender: UIButton){
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.userid), forKey: "user_id" as NSCopying)
        parameterDictionary.setValue(DataManager.getVal(self.SongID), forKey: "song_id")
        parameterDictionary.setValue(DataManager.getVal(1), forKey: "status")
        print(parameterDictionary)
        
        let methodName = "songLikeUnlike"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                //            let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                if status == "1" {
                    self.likeSts = (responseData?.object(forKey: "like_status")) as? Int
                    self.likeCount = (responseData?.object(forKey: "likecount")) as? Int
                    self.UnlikeSts = (responseData?.object(forKey: "unlike_status")) as? Int
                    self.UnlikeCount = (responseData?.object(forKey: "unlikecount")) as? Int
                    var likecou:String!
                    likecou = String(self.likeCount)
                    var Unlikecou:String!
                    Unlikecou = String(self.UnlikeCount)
                    self.myCustomView?.LikeCountLbl.text = likecou
                    self.myCustomView?.DislikeCountLbl.text = Unlikecou
                    if self.likeSts == 1 {
                        self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs_up"), for: .normal)
                        self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
                    }else {
                        self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                    }
                    self.removeAllOverlays()
                }else{
                    self.likeCount = (responseData?.object(forKey: "likecount")) as? Int
                    self.UnlikeCount = (responseData?.object(forKey: "unlikecount")) as? Int
                    var likecou:String!
                    likecou = String(self.likeCount)
                    var Unlikecou:String!
                    Unlikecou = String(self.UnlikeCount)
                    self.myCustomView?.LikeCountLbl.text = likecou
                    self.myCustomView?.DislikeCountLbl.text = Unlikecou
                    self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                    self.removeAllOverlays()
                }
            })
        }
    }
    
    @objc func DislikeSongAction(_ sender: UIButton){
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.userid), forKey: "user_id" as NSCopying)
        parameterDictionary.setValue(DataManager.getVal(self.SongID), forKey: "song_id")
        parameterDictionary.setValue(DataManager.getVal(2), forKey: "status")
        print(parameterDictionary)
        
        let methodName = "songLikeUnlike"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                //            let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                if status == "1" {
                    self.likeSts = (responseData?.object(forKey: "like_status")) as? Int
                    self.likeCount = (responseData?.object(forKey: "likecount")) as? Int
                    self.UnlikeSts = (responseData?.object(forKey: "unlike_status")) as? Int
                    self.UnlikeCount = (responseData?.object(forKey: "unlikecount")) as? Int
                    if self.UnlikeSts == 1 {
                        self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                        self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs_down"), for: .normal)
                    }else {
                        self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
                    }
                    var likecou:String!
                    likecou = String(self.likeCount)
                    var Unlikecou:String!
                    Unlikecou = String(self.UnlikeCount)
                    self.myCustomView?.LikeCountLbl.text = likecou
                    self.myCustomView?.DislikeCountLbl.text = Unlikecou
                    self.removeAllOverlays()
                }else{
                    self.likeCount = (responseData?.object(forKey: "likecount")) as? Int
                    self.UnlikeCount = (responseData?.object(forKey: "unlikecount")) as? Int
                    var likecou:String!
                    likecou = String(self.likeCount)
                    var Unlikecou:String!
                    Unlikecou = String(self.UnlikeCount)
                    self.myCustomView?.LikeCountLbl.text = likecou
                    self.myCustomView?.DislikeCountLbl.text = Unlikecou
                    self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
                    self.removeAllOverlays()
                }
            })
        }
    }
    
    @objc func FavSongAction(_ sender: UIButton){
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.userid), forKey: "user_id" as NSCopying)
        parameterDictionary.setValue(DataManager.getVal(self.SongID), forKey: "favourite_id")
        parameterDictionary.setValue(DataManager.getVal("song"), forKey: "favourite_type")
        print(parameterDictionary)
        
        let methodName = "favourite"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                //                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                if status == "1" {
                    self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart-1"), for: .normal)
                    self.removeAllOverlays()
                }else{
                    self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart"), for: .normal)
                    self.removeAllOverlays()
                }
            })
        }
        
    }
    
    func loadUrl(){
        let dict = DataManager.getVal(self.dataArray[self.selectedMusic]) as! NSDictionary
        print(dict)
        let artistName = DataManager.getVal(dict["as_type_name"]) as? String ?? ""
        let songName = DataManager.getVal(dict["song_name"]) as? String ?? ""
        let songimg = DataManager.getVal(dict["song_image"]) as? String ?? ""
        let song_file = DataManager.getVal(dict["song_file"]) as? String ?? ""
        let duration = DataManager.getVal(dict["duration"]) as? String ?? ""
        let like_unlike_status = DataManager.getVal(dict["like_unlike_status"]) as? String ?? ""
        let favouriteStatus = DataManager.getVal(dict["favouriteStatus"]) as? String ?? ""
        let total_likes = DataManager.getVal(dict["total_likes"]) as? String ?? ""
        let total_unlikes = DataManager.getVal(dict["total_unlikes"]) as? String ?? ""
        self.myCustomView?.LikeCountLbl.text = total_likes
        self.myCustomView?.DislikeCountLbl.text = total_unlikes
        if like_unlike_status == "1"{
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs_up"), for: .normal)
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs_down"), for: .normal)
        }else {
            self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
            self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
        }
        
        if favouriteStatus == "1"{
            self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart-1"), for: .normal)
        }else{
            self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart"), for: .normal)
        }
        //Mini View
        self.myCustomView?.ArtistNameLbl.text = artistName
        self.myCustomView?.MiniSongNameLbl.text = songName
        
        self.myCustomView?.MiniImgView.sd_setImage(with: URL(string: songimg), placeholderImage: UIImage(named: "Group 4-1"))
        
        self.myCustomView?.BottomSongNameLbl.text = songName
        self.myCustomView?.BottomArtistNameLbl.text = artistName
        self.myCustomView?.MaximumTimeLbl.text = duration
        
        self.myCustomView?.BottomImgView.sd_setImage(with: URL(string: songimg), placeholderImage: UIImage(named: "Group 4-1"))
        
        let vc =  song_file.replacingOccurrences(of: " ", with: "")
        let AddPicture_url = URL.init(string: vc)
        print(AddPicture_url!)
        self.currentAudioPath = AddPicture_url
        
        if audioPlayer.isPlaying{
            audioPlayer.stop()
        }
        
        self.downloadFileFromURL3(url: self.currentAudioPath as NSURL)
    }
    
    
    func downloadFileFromURL3(url:NSURL){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            self?.prepareAudio(url: URL!)
        })
        
        downloadTask.resume()
    }
    // MARK: - Prepare audio for playing
    func prepareAudio(url : URL){
        
        print("playing \(url)")
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.volume = 1.0
            if audioPlayer.isPlaying{
            self.audioPlayer.stop()
            }else{
            self.audioPlayer.play()
            }
            DispatchQueue.main.async() {
                let pause = UIImage(named: "pause")
                self.myCustomView?.PlayButton.setImage(pause, for: .normal)
                self.myCustomView?.PauseAndPlayButton.setImage(pause, for: .normal)
                self.updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                self.updateTimer.fire()
            }
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        self.audioPlayer.delegate = self
        
        DispatchQueue.main.async {
            self.myCustomView?.SongSlider.maximumValue = CFloat(self.audioPlayer.duration)
            self.myCustomView?.SongSlider.minimumValue = 0.0
            self.myCustomView?.MinimumTimeLbl.text = "00:00"
            self.myCustomView?.SongSlider.value = 0.0
            self.audioPlayer.prepareToPlay()
        }
    }
    
    @objc func update(_ timer: Timer){
        if !audioPlayer.isPlaying{
            return
        }
        DispatchQueue.main.async() {
            let time = self.calculateTimeFromNSTimeInterval(self.audioPlayer.currentTime)
            self.myCustomView?.MinimumTimeLbl.text  = "\(time.minute):\(time.second)"
            self.myCustomView?.SongSlider.value = CFloat(self.audioPlayer.currentTime)
        }
    }
    
    func calculateTimeFromNSTimeInterval(_ duration:TimeInterval) ->(minute:String, second:String){
        //let hour_   = abs(Int(duration)/3600)
        let minute_ = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
        let second_ = abs(Int(duration.truncatingRemainder(dividingBy: 60)))
        
        let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
        let second = second_ > 9 ? "\(second_)" : "0\(second_)"
        
        return (minute,second)
        
    }
    
    @objc func HandleTap1(_ sender:UIButton){
        
        let nextview = Deletesongview.intitiateFromNib()
        let model = NewPopModel()
        nextview.buttonDoneHandler = {
            let buttonPosition = sender.convert(CGPoint.zero, to: self.playListtableview)
            self.myindexpath = self.playListtableview.indexPathForRow(at: buttonPosition)! as NSIndexPath
            var dict1 = NSDictionary()
            dict1  = (self.response.object(at: self.myindexpath.row) as? NSDictionary)!
            self.songId = dict1.value(forKey: "id") as? Int
            
            if Reachability.isConnectedToNetwork() == true {
                self.showWaitOverlay()
                let parameterDictionary = NSMutableDictionary()
                parameterDictionary.setObject(DataManager.getVal(self.userid), forKey: "user_id" as NSCopying)
                parameterDictionary.setValue(DataManager.getVal("playlist_songs"), forKey: "remove_type")
                parameterDictionary.setValue(DataManager.getVal(self.songId), forKey: "song_id")
                parameterDictionary.setValue(DataManager.getVal(self.listtypeId), forKey: "playlist_id")
                print(parameterDictionary)
                
                let methodName = "removeSongFromList"
                
                DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                    DispatchQueue.main.async(execute: {
                        let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                        let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                        if status == "1" {
                            self.slooooooooooot = 0
                            self.PlayListApi()
                        }else{
                            self.playListtableview.reloadData()
                            self.removeAllOverlays()
                        }
                        self.removeAllOverlays()
                    })
                }
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
            model.closewithAnimation()
        }
        nextview.buttonCancleHandler = {
        model.closewithAnimation()
        }
        model.show(view: nextview)
        
    }
    @IBAction func playAllBtnAction(_ sender: Any) {
     var songMul:String!
     songMul = "AllS"
     let defaults = UserDefaults.standard
    //. defaults.set(response, forKey: "AllSong")
     defaults.set(songMul, forKey: "ALLS")
     defaults.synchronize()
//     let vc = storyboard?.instantiateViewController(withIdentifier: "SongDetailpageViewController") as! SongDetailpageViewController
//     vc.allsong = response
//     navigationController?.pushViewController(vc, animated: true)
        
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
