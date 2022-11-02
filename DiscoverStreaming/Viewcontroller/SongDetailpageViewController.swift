//
//  SongDetailpageViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 19/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import Popover
import SwiftToast
import AVFoundation
import MediaPlayer



class SongDetailpageViewController: UIViewController,AVAudioPlayerDelegate,FloatRatingViewDelegate {

    let IS_IPHONE_7 = (UIScreen.main.bounds.size.height - 667) != 0.0 ? false : true
    let IS_IPHONE_X = (UIScreen.main.bounds.size.height - 812) != 0.0 ? false : true
    let IS_IPHONE_5S = (UIScreen.main.bounds.size.height - 568) != 0.0 ? false : true
    let IS_IPHONE_XR = (UIScreen.main.bounds.size.height - 896) != 0.0 ? false : true
    
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songNAme: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var ratingPer: UILabel!
    @IBOutlet weak var viewlbl: UILabel!
    @IBOutlet weak var previewstimeLbl: UILabel!
    @IBOutlet weak var nextTimeLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var disLikeBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var sliderview: UISlider!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var unlikeCountLbl: UILabel!
    
    @IBOutlet weak var goodnameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    var defaults:UserDefaults!
    var userId:Int!
    var SongID:Int!
    
    let selectedBackground = 1
    
    var audioPlayer1: AVPlayer? = nil
    var audioPlayer = AVAudioPlayer()
    var currentAudio = ""
    var currentAudioPath:URL!
    var timer:Timer!
    var audioLength1 = 0.0
    var toggle = true
    var effectToggle = true
    var totalLengthOfAudio1 = ""
    var finalImage:UIImage!
    var isTableViewOnscreen = false
    var shuffleState = false
    var repeatState = false
    var shuffleArray = [Int]()
    var songfile = String()
    var audiodata = Data()
    var likeSts:Int!
    var likeCount:Int!
    var UnlikeSts:Int!
    var UnlikeCount:Int!
    var newID:Int!
    var FavSts:Int!
    var allsong:NSArray!
    var alls:String!
    var counter = 0
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
  
    
    
    @objc func DiscoverSongDetailAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
               
            }
            else{
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(String(describing: response))")
                self.goodnameLbl.text = response.value(forKey: "song_name") as? String
                self.songImage.sd_setImage(with: URL(string: (response.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                var name:String!
                name = response.value(forKey: "as_type_name") as? String
                
                var date:String!
                date = response.value(forKey: "uploaded_date") as? String
                self.dateLbl.text = name + " | " + date
                self.songfile = response.value(forKey: "song_file") as! String
                var type:String!
                type =  response.value(forKey: "song_type") as? String
                self.typeLbl.text = "Song Type:" + " " + type
                
                var price:NSNumber!
                price =  response.value(forKey: "price") as? NSNumber
                self.priceLbl.text = "Price:" + " $" + price.stringValue
                let vc =  self.songfile.replacingOccurrences(of: " ", with: "")
                let AddPicture_url = URL.init(string: vc)
                print(AddPicture_url!)
                self.currentAudioPath = AddPicture_url
                self.downloadFileFromURL(url: self.currentAudioPath! as NSURL)
                
                var rating1:NSNumber!
                rating1 = response.value(forKey: "rating") as? NSNumber
               
                var rate = Float()
                rate = Float(truncating: rating1)
                self.ratingView.rating = Float(truncating: NSNumber(value: rate))
                
                print("\(String(describing: self.currentAudioPath))")
                var view:Int!
                view = response.value(forKey: "viewer") as? Int
                var viewer:String!
                viewer = String(view)
                self.viewlbl.text = viewer + "  " + "Views"
                var likeunlikeSt:Int!
                likeunlikeSt = response.value(forKey: "like_unlike_status") as? Int
                if likeunlikeSt == 2 {
                    self.likeBtn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                    self.disLikeBtn.setImage(UIImage(named: "thumbs_down"), for: .normal)
                }else if likeunlikeSt == 1 {
                    self.likeBtn.setImage(UIImage(named: "thumbs_up"), for: .normal)
                    self.disLikeBtn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
                }else {
                    self.likeBtn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                    self.disLikeBtn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
                }
                self.newID = response.value(forKey: "id") as? Int
                var TotalLike:Int!
                TotalLike = response.value(forKey: "total_likes") as? Int
                var TlLikeCount:String!
                TlLikeCount = String(TotalLike)
                self.likeCountLbl.text = TlLikeCount
               
                var TotalUnLike:Int!
                TotalUnLike = response.value(forKey: "total_unlikes") as? Int
                var TlUnLikeCount:String!
                TlUnLikeCount = String(TotalUnLike)
                self.unlikeCountLbl.text = TlUnLikeCount
                self.FavSts = response.value(forKey: "favouriteStatus") as? Int
                if self.FavSts == 1 {
                      self.favBtn.setImage(UIImage(named: "heart-1"), for: .normal)
                }else {
                    self.favBtn.setImage(UIImage(named: "heart"), for: .normal)
                }
               // self.prepareAudio(url: AddPicture_url!)
                self.removeAllOverlays()
            }
        }
    }
    
    @objc func DiscoverSongLikeAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                
            }
            else{
                self.likeSts = (notification.userInfo?["like_status"] as? Int)!
                self.likeCount = (notification.userInfo?["likecount"] as? Int)!
                self.UnlikeSts = (notification.userInfo?["unlike_status"] as? Int)!
                self.UnlikeCount = (notification.userInfo?["unlikecount"] as? Int)!
                
                var likecou:String!
                likecou = String(self.likeCount)
                
                var Unlikecou:String!
                Unlikecou = String(self.UnlikeCount)
                
                self.likeCountLbl.text = likecou
                self.unlikeCountLbl.text = Unlikecou
                
                if self.likeSts == 1 {
                    self.likeBtn.setImage(UIImage(named: "thumbs_up"), for: .normal)
                    self.disLikeBtn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
                }else {
                    self.likeBtn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                }
                self.removeAllOverlays()
            }
        }
    }
    
    @objc func DiscoverSongUnLikeAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                
            }
            else{
                self.likeSts = (notification.userInfo?["like_status"] as? Int)!
                self.likeCount = (notification.userInfo?["likecount"] as? Int)!
                self.UnlikeSts = (notification.userInfo?["unlike_status"] as? Int)!
                self.UnlikeCount = (notification.userInfo?["unlikecount"] as? Int)!
                
               
                
                if self.UnlikeSts == 1 {
                    self.likeBtn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                    self.disLikeBtn.setImage(UIImage(named: "thumbs_down"), for: .normal)
                    
                }else {
                    self.disLikeBtn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
                }
                var likecou:String!
                likecou = String(self.likeCount)
                
                var Unlikecou:String!
                Unlikecou = String(self.UnlikeCount)
                
                self.likeCountLbl.text = likecou
                self.unlikeCountLbl.text = Unlikecou
                self.removeAllOverlays()
            }
        }
    }
    
    @objc func DiscoverSongFavouriteAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                 self.favBtn.setImage(UIImage(named: "heart"), for: .normal)
            }
            else{
             
                self.favBtn.setImage(UIImage(named: "heart-1"), for: .normal)
                self.removeAllOverlays()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ratingView.emptyImage = UIImage(named: "star_2")
        self.ratingView.fullImage = UIImage(named: "star_1")
        // Optional params
        self.ratingView.delegate = self
        self.ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 0
        self.ratingView.editable = false
        self.ratingView.halfRatings = false
        self.ratingView.floatRatings = false
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        //        self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
        //self.liveLabel.text = String(self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        SongID = defaults.integer(forKey: "Song_Id")
       // allsong = defaults.array(forKey: "AllSong") as NSArray?
        alls = defaults.value(forKey: "ALLS") as? String
      
        
        
        if self.alls == "AllS" {
            sliderview.value = 0.0

            music()
        }else if self.alls == "SongS" {
            sliderview.value = 0.0
            self.playBtn.isUserInteractionEnabled = false
            self.sliderview.isUserInteractionEnabled = false
            if Reachability.isConnectedToNetwork() == true{
                showWaitOverlay()
                Parsing().DiscoverSongDetail(UserId: userId, SongId: SongID)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongDetailAction), name: NSNotification.Name(rawValue: "DiscoverSongDetail"), object: nil)
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
        }else {
            
        }
        
        
       
       // self.assingSliderUI()
        // self.retrievePlayerProgressSliderValue()
        //LockScreen Media control registry
        if UIApplication.shared.responds(to: #selector(UIApplication.beginReceivingRemoteControlEvents)){
            UIApplication.shared.beginReceivingRemoteControlEvents()
            UIApplication.shared.beginBackgroundTask(expirationHandler: { () -> Void in
            })
        }
    }
    @IBAction func slidervierwBtnaction(_ sender: UISlider) {
        if alls == "AllS" {
            audioPlayer.currentTime = TimeInterval(sender.value)
        }else {
            audioPlayer.currentTime = TimeInterval(sender.value)
        }
        
        
    }
    
    @IBAction func favBtnAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            Parsing().DiscoverSongFavourite(UserId: userId, FavId: SongID, Fav_Tyape: "song")
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongFavouriteAction), name: NSNotification.Name(rawValue: "DiscoverSongFavourite"), object: nil)
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
    @IBAction func dislikeBtn(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            Parsing().DiscoverSongLikeUnlike(UserId: userId, SongId: SongID, Status: 2)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongUnLikeAction), name: NSNotification.Name(rawValue: "DiscoverSongLikeUnlike"), object: nil)
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
    @IBAction func likeBtn(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            Parsing().DiscoverSongLikeUnlike(UserId: userId, SongId: SongID, Status: 1)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongLikeAction), name: NSNotification.Name(rawValue: "DiscoverSongLikeUnlike"), object: nil)
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
    @IBAction func playBtnaction(_ sender: Any) {
        if alls == "AllS" {
            //music()
            let play = UIImage(named: "play-1")
            let pause = UIImage(named: "pause")
            if audioPlayer.isPlaying{
                pauseAudioPlayer()
                audioPlayer.isPlaying ? "\(playBtn.setImage( pause, for: UIControl.State()))" : "\(playBtn.setImage(play , for: UIControl.State()))"
                
            }else{
                playAudio1()
                audioPlayer.isPlaying ? "\(playBtn.setImage( pause, for: UIControl.State()))" : "\(playBtn.setImage(play , for: UIControl.State()))"
            }
        }else {
            if shuffleState == true {
                shuffleArray.removeAll()
            }
            let play = UIImage(named: "play-1")
            let pause = UIImage(named: "pause")
            if audioPlayer.isPlaying{
                pauseAudioPlayer()
                audioPlayer.isPlaying ? "\(playBtn.setImage( pause, for: UIControl.State()))" : "\(playBtn.setImage(play , for: UIControl.State()))"
                
            }else{
                playAudio()
                audioPlayer.isPlaying ? "\(playBtn.setImage( pause, for: UIControl.State()))" : "\(playBtn.setImage(play , for: UIControl.State()))"
            }
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func commentBtnAction(_ sender: Any) {
        let popover = Popover()
        popover.isHidden = true
        let defaults = UserDefaults.standard
        defaults.set(newID, forKey: "POSTID")
        defaults.synchronize()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentAllSongViewController") as! CommentAllSongViewController
        navigationController?.pushViewController(vc, animated: true)
//        if IS_IPHONE_7 {
//        let startPoint = CGPoint(x: self.view.frame.width - 78, y: 340)
//        let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-310, height: 30))
//        aView.backgroundColor = UIColor.lightGray
//        let popover = Popover()
//        popover.popoverColor = UIColor.darkGray
//        let lab = UILabel()
//        lab.frame = CGRect(x: 10, y: 10, width:aView.frame.size.width, height: aView.frame.size.height)
//        lab.text = "Comment"
//        lab.textColor = UIColor.white
//        lab.font = UIFont.boldSystemFont(ofSize: 10)
//        aView.addSubview(lab)
//        let but = UIButton()
//        but.frame = CGRect(x: 10, y: 10, width:aView.frame.size.width, height: aView.frame.size.height)
//        but.setTitle("", for: .normal)
//        but.backgroundColor = UIColor.clear
//        but.addTarget(self, action: #selector(HandleTap(_:)), for: .touchUpInside)
//        aView.addSubview(but)
//        popover.show(aView, point: startPoint)
//        } else if IS_IPHONE_X {
//            let startPoint = CGPoint(x: self.view.frame.width - 78, y: 370)
//            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-310, height: 30))
//            aView.backgroundColor = UIColor.lightGray
//            let popover = Popover()
//            popover.popoverColor = UIColor.darkGray
//            let lab = UILabel()
//            lab.frame = CGRect(x: 10, y: 10, width:aView.frame.size.width, height: aView.frame.size.height)
//            lab.text = "Comment"
//            lab.textColor = UIColor.white
//            lab.font = UIFont.boldSystemFont(ofSize: 10)
//            aView.addSubview(lab)
//            let but = UIButton()
//            but.frame = CGRect(x: 10, y: 10, width:aView.frame.size.width, height: aView.frame.size.height)
//            but.setTitle("", for: .normal)
//            but.backgroundColor = UIColor.clear
//            but.addTarget(self, action: #selector(HandleTap(_:)), for: .touchUpInside)
//            aView.addSubview(but)
//            popover.show(aView, point: startPoint)
//        }else if IS_IPHONE_5S {
//            let startPoint = CGPoint(x: self.view.frame.width - 50, y: 340)
//            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-250, height: 30))
//            aView.backgroundColor = UIColor.lightGray
//            let popover = Popover()
//            popover.popoverColor = UIColor.darkGray
//            let lab = UILabel()
//            lab.frame = CGRect(x: 10, y: 10, width:aView.frame.size.width, height: aView.frame.size.height)
//            lab.text = "Comment"
//            lab.textColor = UIColor.white
//            lab.font = UIFont.boldSystemFont(ofSize: 10)
//            aView.addSubview(lab)
//            let but = UIButton()
//            but.frame = CGRect(x: 10, y: 10, width:aView.frame.size.width, height: aView.frame.size.height)
//            but.setTitle("", for: .normal)
//            but.backgroundColor = UIColor.clear
//            but.addTarget(self, action: #selector(HandleTap(_:)), for: .touchUpInside)
//            aView.addSubview(but)
//            popover.show(aView, point: startPoint)
//        }else if IS_IPHONE_XR {
//            let startPoint = CGPoint(x: self.view.frame.width - 88, y: 370)
//            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-350, height: 30))
//            aView.backgroundColor = UIColor.lightGray
//            let popover = Popover()
//            popover.popoverColor = UIColor.darkGray
//            let lab = UILabel()
//            lab.frame = CGRect(x: 10, y: 10, width:aView.frame.size.width, height: aView.frame.size.height)
//            lab.text = "Comment"
//            lab.textColor = UIColor.white
//            lab.font = UIFont.boldSystemFont(ofSize: 10)
//            aView.addSubview(lab)
//            let but = UIButton()
//            but.frame = CGRect(x: 10, y: 10, width:aView.frame.size.width, height: aView.frame.size.height)
//            but.setTitle("", for: .normal)
//            but.backgroundColor = UIColor.clear
//            but.addTarget(self, action: #selector(HandleTap(_:)), for: .touchUpInside)
//            aView.addSubview(but)
//            popover.show(aView, point: startPoint)
//        }
    }
    
    @objc func HandleTap(_ sender:UIButton){
        let popover = Popover()
        popover.isHidden = true
        let defaults = UserDefaults.standard
        defaults.set(newID, forKey: "POSTID")
        defaults.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
   
    // MARK:- AVAudioPlayer Delegate's Callback method
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        if alls == "AllS" {
            var alls:NSArray!
            alls = self.allsong.value(forKey: "song_file") as? NSArray
            if flag {
                counter+=1
            }
            
            if ((counter) == alls.count) {
                counter = 0
            }
            
            music()
           
        }else {
           playBtn.setImage(UIImage(named: "pause"), for: .normal)
        }
        

    }
    
    func music(){
        for i in 0..<allsong.count-1 {
            var dict = NSDictionary()
            dict = allsong.object(at: counter) as! NSDictionary
            var songf = String()
            songf = dict.value(forKey: "song_file") as! String
            let vc =  songf.replacingOccurrences(of: " ", with: "")
            let url = URL(string: vc)
            //var comps = URLComponents(string: vc)!
            //comps.scheme = "http"
           // let https = comps.url!
            self.goodnameLbl.text = dict.value(forKey: "song_name") as? String
            self.songImage.sd_setImage(with: URL(string: (dict.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            var name:String!
            name = dict.value(forKey: "as_type_name") as? String
            
            var date:String!
            date = dict.value(forKey: "uploaded_date") as? String
            self.dateLbl.text = name + " | " + date
            self.songfile = dict.value(forKey: "song_file") as! String
            var type:String!
            type =  dict.value(forKey: "song_type") as? String
            self.typeLbl.text = "Song Type:" + " " + type
            
            var price:NSNumber!
            price =  dict.value(forKey: "price") as? NSNumber
            self.priceLbl.text = "Price:" + " $" + price.stringValue
            
            var view:Int!
            view = dict.value(forKey: "viewer") as? Int
            var viewer:String!
            viewer = String(view)
            self.viewlbl.text = viewer + "  " + "Views"
            var likeunlikeSt:Int!
            likeunlikeSt = dict.value(forKey: "like_unlike_status") as? Int
            if likeunlikeSt == 2 {
                self.likeBtn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                self.disLikeBtn.setImage(UIImage(named: "thumbs_down"), for: .normal)
            }else if likeunlikeSt == 1 {
                self.likeBtn.setImage(UIImage(named: "thumbs_up"), for: .normal)
                self.disLikeBtn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
            }else {
                self.likeBtn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                self.disLikeBtn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
            }
            self.newID = dict.value(forKey: "id") as? Int
            var TotalLike:Int!
            TotalLike = dict.value(forKey: "total_likes") as? Int
            var TlLikeCount:String!
            TlLikeCount = String(TotalLike)
            self.likeCountLbl.text = TlLikeCount
            
            var TotalUnLike:Int!
            TotalUnLike = dict.value(forKey: "total_unlikes") as? Int
            var TlUnLikeCount:String!
            TlUnLikeCount = String(TotalUnLike)
            self.unlikeCountLbl.text = TlUnLikeCount
            self.FavSts = dict.value(forKey: "favouriteStatus") as? Int
            if self.FavSts == 1 {
                self.favBtn.setImage(UIImage(named: "heart-1"), for: .normal)
            }else {
                self.favBtn.setImage(UIImage(named: "heart"), for: .normal)
            }
            
            downloadFileFromURL1(url: url! as NSURL)
        }
//        var alls:NSArray!
//        alls = self.allsong.value(forKey: "song_file") as? NSArray
//        for path in alls {
//
//                let str = String(describing: path)
//                let vc =  str.replacingOccurrences(of: " ", with: "")
//                let url = URL(string: vc)
//                var comps = URLComponents(string: vc)!
//                comps.scheme = "http"
//                let https = comps.url!
//                downloadFileFromURL1(url: https as NSURL)
//
//        }
    }
    
    func prepareAudio1(url : URL) {
        audioPlayer = try! AVAudioPlayer.init(contentsOf: url, fileTypeHint: "mp3")
        audioPlayer.delegate = self
        audioLength1 = audioPlayer.duration
        DispatchQueue.main.async {
            self.sliderview.maximumValue = CFloat(self.audioPlayer.duration)
            self.sliderview.minimumValue = 0.0
            self.sliderview.value = 0.0
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
            self.sliderview.isUserInteractionEnabled = true
            self.playBtn.isUserInteractionEnabled = true
            self.showTotalSongLength()
            self.previewstimeLbl.text = "00:00"
        }
    }
     @objc func update1(_ timer: Timer){
        if !audioPlayer.isPlaying{
            return
        }
        let time = calculateTimeFromNSTimeInterval(audioPlayer.currentTime)
        previewstimeLbl.text  = "\(time.minute):\(time.second)"
        sliderview.value = CFloat(audioPlayer.currentTime)
        UserDefaults.standard.set(sliderview.value , forKey: "playerProgressSliderValue")
       // sliderview.value = Float(audioPlayer.currentTime)
    }
    
    //Sets audio file URL
    func setCurrentAudioPath(){
        let vc =  self.songfile.replacingOccurrences(of: " ", with: "")
        let AddPicture_url: NSURL = NSURL(string: vc)!
        print(AddPicture_url)
        currentAudioPath = AddPicture_url as URL
        audiodata = try! Data.init(contentsOf: currentAudioPath!)
        print(audiodata)
        print("\(String(describing: currentAudioPath))")
    }
    
  

   
    // Prepare audio for playing
    func prepareAudio(url : URL){
        //setCurrentAudioPath()
//        do {
//            //keep alive audio at background
//
//
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
//        } catch _ {
//        }
//        do {
//            try AVAudioSession.sharedInstance().setActive(true)
//        } catch _ {
//        }
      //  UIApplication.shared.beginReceivingRemoteControlEvents()
       
        audioPlayer = try! AVAudioPlayer.init(contentsOf: url, fileTypeHint: "mp3")
        audioPlayer.delegate = self
        audioLength1 = audioPlayer.duration
         DispatchQueue.main.async {
            self.sliderview.maximumValue = CFloat(self.audioPlayer.duration)
            self.sliderview.minimumValue = 0.0
            self.sliderview.value = 0.0
            self.audioPlayer.prepareToPlay()
            self.sliderview.isUserInteractionEnabled = true
            self.playBtn.isUserInteractionEnabled = true
            self.showTotalSongLength()
            self.previewstimeLbl.text = "00:00"
        }
        
        
    }
    func downloadFileFromURL(url:NSURL){
       
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
           
           self?.prepareAudio(url: URL!)
            
        })
        
        downloadTask.resume()
        
    }
    
    
    func downloadFileFromURL1(url:NSURL){
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            
           self?.prepareAudio1(url: URL!)
            
        })
        
        downloadTask.resume()
        
    }
    
//    func downloadFileFromURL(url:NSURL){
//
//        var downloadTask:URLSessionDownloadTask
//        let vc =  self.songfile.replacingOccurrences(of: " ", with: "")
//        let AddPicture_url = URL.init(string: vc)
//        print(AddPicture_url!)
//        downloadTask = URLSession.shared.downloadTask(with: AddPicture_url!)
//        downloadTask = URLSession.shared.downloadTask(with: AddPicture_url!, completionHandler: { [weak self](URL, response, error) -> Void in
//             self?.prepareAudio(url: AddPicture_url!)
//        })
////        downloadTask = URLSession.shared.downloadTaskWithURL(url, completionHandler: { [weak self](URL, response, error) -> Void in
////            self?.play(URL)
////        })
//
//        downloadTask.resume()
//
//    }
    
    //MARK:- Player Controls Methods
    func  playAudio(){
        audioPlayer.play()
        startTimer()
    }
    
    func  playAudio1(){
        audioPlayer.play()
        startTimer1()
    }
    

    
    func stopAudiplayer(){
        audioPlayer.stop();
        
    }
    
    func pauseAudioPlayer(){
        audioPlayer.pause()
        
    }
    
    
    //MARK:-
    
    func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SongDetailpageViewController.update(_:)), userInfo: nil,repeats: true)
            timer.fire()
        }
    }
    
    func startTimer1(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(SongDetailpageViewController.update1(_:)), userInfo: nil, repeats: true)
            timer.fire()
        }
    }
    
    func stopTimer(){
        timer.invalidate()
        
    }
    
    
    @objc func update(_ timer: Timer){
        if !audioPlayer.isPlaying{
            return
        }
        let time = calculateTimeFromNSTimeInterval(audioPlayer.currentTime)
        previewstimeLbl.text  = "\(time.minute):\(time.second)"
        sliderview.value = CFloat(audioPlayer.currentTime)
        UserDefaults.standard.set(sliderview.value , forKey: "playerProgressSliderValue")
        
        
    }
    
    func retrievePlayerProgressSliderValue(){
        let playerProgressSliderValue =  UserDefaults.standard.float(forKey: "playerProgressSliderValue")
        if playerProgressSliderValue != 0 {
            sliderview.value  = playerProgressSliderValue
            audioPlayer.currentTime = TimeInterval(playerProgressSliderValue)
            
            let time = calculateTimeFromNSTimeInterval(audioPlayer.currentTime)
            previewstimeLbl.text  = "\(time.minute):\(time.second)"
            sliderview.value = CFloat(audioPlayer.currentTime)
            
        }else{
            sliderview.value = 0.0
            audioPlayer.currentTime = 0.0
            previewstimeLbl.text = "00:00"
        }
    }
    
    
    
    //This returns song length
    func calculateTimeFromNSTimeInterval(_ duration:TimeInterval) ->(minute:String, second:String){
        // let hour_   = abs(Int(duration)/3600)
        let minute_ = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
        let second_ = abs(Int(duration.truncatingRemainder(dividingBy: 60)))
        
        // var hour = hour_ > 9 ? "\(hour_)" : "0\(hour_)"
        let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
        let second = second_ > 9 ? "\(second_)" : "0\(second_)"
        return (minute,second)
    }
    
    
    
    func showTotalSongLength(){
        calculateSongLength()
        nextTimeLbl.text = totalLengthOfAudio1
    }
    
    
    func calculateSongLength(){
        let time = calculateTimeFromNSTimeInterval(audioLength1)
        totalLengthOfAudio1 = "\(time.minute):\(time.second)"
    }
    
    
    func assingSliderUI () {
        let minImage = UIImage(named: "playing")
        let maxImage = UIImage(named: "whole")
        let thumb = UIImage(named: "Oval 3")
        
        sliderview.setMinimumTrackImage(minImage, for: UIControl.State())
        sliderview.setMaximumTrackImage(maxImage, for: UIControl.State())
        sliderview.setThumbImage(thumb, for: UIControl.State())
        
        
    }
    
    
  

}
