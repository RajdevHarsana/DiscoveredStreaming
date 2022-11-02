//
//  HotMusicViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import CoreLocation
import SwiftToast

class HotMusicViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate,CLLocationManagerDelegate {
    let selectedBackground = 1
    
    
    @IBOutlet weak var musicPlayerView: UIView!
    
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
    
    var currentAudio = ""
    var currentAudioPath:URL!
    var audioList:NSArray!
    var currentAudioIndex = 0
    var timer:Timer!
    var toggle = true
    var effectToggle = true
    var finalImage:UIImage!
    var isTableViewOnscreen = false
    var shuffleState = false
    var repeatState = false
    var shuffleArray = [Int]()
    var songfile:String!
    var audioLength1 = 0.0
    @IBOutlet weak var backgroundImageView: UIImageView!
    var selectedMusic = 0
    @IBOutlet weak var songCountLbl: UILabel!
    @IBOutlet weak var musicListTableHeightCons: NSLayoutConstraint!
    
    var defaults:UserDefaults!
    var user_Id:Int!
    var response = NSMutableArray()
    var str_lat:String!
    var str_long:String!
    var Manager: CLLocationManager!
    var isCall = Bool()
    var totalLengthOfAudio1 = ""
    var SongID:Int!
    
    var slooooooooooot = Int()
    var APICall = Bool()
    
    @IBOutlet weak var songTableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //assing background
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        str_lat = defaults.value(forKey: "LAT") as? String
        str_long = defaults.value(forKey: "LONG") as? String
        slooooooooooot = 0
        APICall = true
        songListApi()
        //LockScreen Media control registry
        if UIApplication.shared.responds(to: #selector(UIApplication.beginReceivingRemoteControlEvents)){
            UIApplication.shared.beginReceivingRemoteControlEvents()
            UIApplication.shared.beginBackgroundTask(expirationHandler: { () -> Void in
            })
        }
        // Do any additional setup after loading the view.
    }
    
    func songListApi(){
            
        if !isCall
        {
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
            parameterDictionary.setValue(DataManager.getVal("all"), forKey: "as_type")
//            parameterDictionary.setValue(DataManager.getVal(""), forKey: "as_type_id")
            parameterDictionary.setValue(DataManager.getVal("hotmusic"), forKey: "list_type")
            parameterDictionary.setValue(DataManager.getVal(str_lat), forKey: "lat")
            parameterDictionary.setValue(DataManager.getVal(str_long), forKey: "lng")
            parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
//            parameterDictionary.setValue(DataManager.getVal(list_type_id), forKey: "list_type_id")
            print(parameterDictionary)
            
            let methodName = "song_list"
            
            DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
//                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                let songCount = DataManager.getVal(responseData?.object(forKey: "song_count"))  as? String ?? ""
                self.songCountLbl.text = songCount + " Songs by Discover Streming"
                if status == "0" {
                    if songCount <= "10"{
                    self.removeAllOverlays()
                    }else{
                    self.songTableview.reloadData()
                    self.removeAllOverlays()
                    }
                }else{
                var arr_data = NSMutableArray()
                  arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                  self.APICall = true
                  if arr_data.count != 0 {
                  self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                  self.dataArray = self.response as! [Any]
                  self.slooooooooooot = self.slooooooooooot + 10
                  arr_data.removeAllObjects()
                }
                  self.dataArray = self.response.value(forKey: "song_file") as! [Any]
                  self.songTableview.reloadData()
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
    
    @IBAction func PlayAllBtnAction(_ sender: Any) {
       
//        print(self.dataArray)
//
//        for i in 0..<dataArray.count {
//            let Object = dataArray[i] as! String
//            print(Object)
//            let vc =  Object.replacingOccurrences(of: " ", with: "")
//            let AddPicture_url = URL.init(string: vc)
//            print(AddPicture_url!)
//            let videoAsset = AVURLAsset(url: AddPicture_url!)
//
//            videoAsset.loadValuesAsynchronously(forKeys: dataArray as! [String]) {
//                DispatchQueue.main.async {
//                    let queuePlayer = AVQueuePlayer()
//                    let loopItem = AVPlayerItem(asset: videoAsset)
//                    queuePlayer.insert(loopItem, after: nil)
//                    queuePlayer.play()
//                }
//            }
//            var queuePlayer = AVQueuePlayer()
//            let item = AVPlayerItem(url: AddPicture_url!)
//            queuePlayer = AVQueuePlayer(items: [item])
//            queuePlayer.play()
//            
//            let dict = DataManager.getVal(self.response[indexPath.row]) as! NSDictionary
//            print(dict)
////            self.dataArray = self.response as! [Any]
//            let artistName = DataManager.getVal(dict["as_type_name"]) as? String ?? ""
//            let songName = DataManager.getVal(dict["song_name"]) as? String ?? ""
//            let songimg = DataManager.getVal(dict["song_image"]) as? String ?? ""
//            let song_file = DataManager.getVal(dict["song_file"]) as? String ?? ""
//            let duration = DataManager.getVal(dict["duration"]) as? String ?? ""
//            let songid = DataManager.getVal(dict["id"]) as? String ?? ""
//            let like_unlike_status = DataManager.getVal(dict["like_unlike_status"]) as? String ?? ""
//            let favouriteStatus = DataManager.getVal(dict["favouriteStatus"]) as? String ?? ""
//            let total_likes = DataManager.getVal(dict["total_likes"]) as? String ?? ""
//            let total_unlikes = DataManager.getVal(dict["total_unlikes"]) as? String ?? ""
//            self.myCustomView?.LikeCountLbl.text = total_likes
//            self.myCustomView?.DislikeCountLbl.text = total_unlikes
//            if like_unlike_status == "1"{
//                self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs_up"), for: .normal)
//                self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
//            }else {
//                self.myCustomView?.Dislike_btn.setImage(UIImage(named: "thumbs_down"), for: .normal)
//                self.myCustomView?.Like_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
//            }
//            
//            if favouriteStatus == "1"{
//                self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart-1"), for: .normal)
//            }else{
//                self.myCustomView?.Fav_btn.setImage(UIImage(named: "heart"), for: .normal)
//            }
//            
////            self.SongID = Int(songid) ?? 0
////            self.selectedMusic = indexPath.row
////            //            self.SongListAPi(songType:"hot_music")
////            let vc =  song_file.replacingOccurrences(of: " ", with: "")
////            let AddPicture_url = URL.init(string: vc)
////            print(AddPicture_url!)
////            self.currentAudioPath = AddPicture_url
////
//            
//            self.myCustomView?.removeFromSuperview()
//            self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
//            self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-144, width: self.screenWidth, height: 60)
//            self.myCustomView?.BottomView.isHidden = true
//            
//            //Mini View
//            self.myCustomView?.MiniViewHeightConstraint.constant = 60
//            self.myCustomView?.ArtistNameLbl.text = artistName
//            self.myCustomView?.MiniSongNameLbl.text = songName
//            
//            self.myCustomView?.MiniImgView.sd_setImage(with: URL(string: songimg), placeholderImage: UIImage(named: "Group 4-1"))
//            //Bottom View
//            self.myCustomView?.BottomSongNameLbl.text = songName
//            self.myCustomView?.BottomArtistNameLbl.text = artistName
//            self.myCustomView?.MaximumTimeLbl.text = duration
//            
//            self.myCustomView?.BottomImgView.sd_setImage(with: URL(string: songimg), placeholderImage: UIImage(named: "Group 4-1"))
//            
//            self.downloadFileFromURL3(url:currentAudioPath! as NSURL)
//            
//            
//            self.myCustomView?.BigButton.addTarget(self, action: #selector(BigButtonAction), for: .touchUpInside)
//            self.myCustomView?.PlayButton.addTarget(self, action: #selector(PlayButtonAction), for: .touchUpInside)
//            self.myCustomView?.CrossButton.addTarget(self, action: #selector(CrossButtonAction), for: .touchUpInside)
//            self.myCustomView?.SongSlider.addTarget(self, action: #selector(SliderAction), for: .touchUpInside)
//            
//            self.myCustomView?.PreviousButton.addTarget(self, action: #selector(PreviousButtonAction), for: .touchUpInside)
//            self.myCustomView?.PauseAndPlayButton.addTarget(self, action: #selector(PauseAndPlayButtonAction), for: .touchUpInside)
//            self.myCustomView?.NextButton.addTarget(self, action: #selector(NextButtonAction), for: .touchUpInside)
//            self.myCustomView?.Like_btn.addTarget(self, action: #selector(LikeSongAction), for: .touchUpInside)
//            self.myCustomView?.Dislike_btn.addTarget(self, action: #selector(DislikeSongAction), for: .touchUpInside)
//            self.myCustomView?.Fav_btn.addTarget(self, action: #selector(FavSongAction), for: .touchUpInside)
//            
//            self.view.window?.addSubview(self.myCustomView!)
//        }
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
    
    //MARK:- Tableview DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == songTableview{
            return response.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MusicCell
        var songNameDict = NSDictionary();
        songNameDict = response.object(at: indexPath.item) as! NSDictionary
        cell.songName.text = songNameDict.value(forKey: "song_name") as? String
        cell.songTime.text = songNameDict.value(forKey: "duration") as? String
        cell.songCount.text = "1"
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView,willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath){
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
            songListApi()
            
        }
        tableView.backgroundColor = UIColor.clear
        
        let backgroundView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = UIColor.clear
        cell.backgroundView = backgroundView
        cell.backgroundColor = UIColor.clear
    }
    // MARK: - UITableViewDelegate
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
        parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
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
        parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
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
        parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
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
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}
