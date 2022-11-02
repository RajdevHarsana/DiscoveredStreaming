//
//  MaxiSongViewController.swift
//  LnPopUpDemo
//
//  Created by MAC-27 on 24/09/20.
//  Copyright © 2020 MAC-27. All rights reserved.
//

import UIKit
import SwiftToast
import Popover
import AVFoundation

class MaxiSongViewController: MusicPlayerViewController, UITableViewDataSource,UITableViewDelegate, FloatRatingViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    
    @IBOutlet weak var maxPlay_PlayerMin_btn: UIButton!
    @IBOutlet weak var maxPlay_PlayerDismiss_btn: UIButton!
    @IBOutlet weak var maxPlay_Song_img: UIImageView!
    @IBOutlet weak var maxPlay_SongName_lbl: UILabel!
    @IBOutlet weak var maxPlay_SongArtist_lbl: UILabel!
    @IBOutlet weak var maxPlay_SongType_lbl: UILabel!
    @IBOutlet weak var maxPlay_SongPrice_lbl: UILabel!
    @IBOutlet weak var maxPlay_SongRating_lbl: UILabel!
    @IBOutlet weak var maxPlay_SongViews_lbl: UILabel!
    @IBOutlet weak var maxPlay_SongMinTime_lbl: UILabel!
    @IBOutlet weak var maxPlay_SongMacTime_lbl: UILabel!
    @IBOutlet weak var maxPlay_SongSlider: UISlider!
    @IBOutlet weak var maxPlay_SongPrev_btn: UIButton!
    @IBOutlet weak var maxPlay_SongNext_btn: UIButton!
    @IBOutlet weak var maxPlay_SongPlayPause_btn: UIButton!
    @IBOutlet weak var maxPlay_SongLike_btn: UIButton!
    @IBOutlet weak var maxPlay_SongFav_btn: UIButton!
    @IBOutlet weak var maxPlay_SongDislike_btn: UIButton!
    @IBOutlet weak var maxPlay_SongTableView: UITableView!
    @IBOutlet weak var maxPlay_ratingView: FloatRatingView!
    @IBOutlet weak var maxPlay_likeCountLbl: UILabel!
    @IBOutlet weak var maxPlay_unlikeCountLbl: UILabel!
    
    var audioLen = 0.0
    var audioCurren = 0.0
//    var totalLengthOfAudio1 = ""
//    var timer:Timer?
//    var audioPlayer = AVAudioPlayer()
    var likeSts:Int!
    var likeCount:Int!
    var UnlikeSts:Int!
    var UnlikeCount:Int!
    var idnew:Int!
    var songfile1:String!
    var SongType = String()
    var SongID = Int()
    var songImage = String()
    var songName = String()
    var songArtist = String()
    var defaults:UserDefaults!
    var userId = Int()
    var str_lat:String!
    var str_long:String!
    var slooooooooooot = Int()
    var APICall = Bool()
    var response = NSMutableArray()
    var songFile = String()
    var newID:Int!
    var FavSts:Int!
    var table = UITableView()
    var myindexpath = NSIndexPath()
    fileprivate var texts = [String]()
    var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
        .type(.auto),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    
    let IS_IPHONE_7 = (UIScreen.main.bounds.size.height - 667) != 0.0 ? false : true
    let IS_IPHONE_X = (UIScreen.main.bounds.size.height - 812) != 0.0 ? false : true
    let IS_IPHONE_5S = (UIScreen.main.bounds.size.height - 568) != 0.0 ? false : true
    let IS_IPHONE_XR = (UIScreen.main.bounds.size.height - 896) != 0.0 ? false : true
    let screenWidth = UIScreen.main.bounds.size.width
    
//  class func intitiateFromNib() -> MaxiSongViewController {
//        let view = UINib.init(nibName: "MaxiSongViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as! MaxiSongViewController
//        
//        return view
//    }
    
    @objc func DiscoverSongListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.APICall = false
                self.maxPlay_SongTableView.reloadData()
            }
            else{
                var arr_data = NSMutableArray()
                arr_data = (notification.userInfo?["data"] as? NSMutableArray)!
                self.APICall = true
                if arr_data.count != 0 {
                    self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                    self.slooooooooooot = self.slooooooooooot + 10
                    arr_data.removeAllObjects()
                }
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAllSongList"), object: nil)
                self.maxPlay_SongTableView.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "SongViewCell", bundle:nil)
        self.maxPlay_SongTableView.register(nibName, forCellReuseIdentifier: "cell")
//        DispatchQueue.main.async{
////        self.maxPlay_SongMacTime_lbl.text = String(self.audioLen)
////        self.maxPlay_SongMinTime_lbl.text = String(self.audioCurren)
//        self.startTimer()
//        self.retrievePlayerProgressSliderValue()
//        }
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        str_lat = defaults.value(forKey: "LAT") as? String
        str_long = defaults.value(forKey: "LONG") as? String
        self.maxPlay_ratingView.emptyImage = UIImage(named: "star_2")
        self.maxPlay_ratingView.fullImage = UIImage(named: "star_1")
        // Optional params
        self.maxPlay_ratingView.delegate = self
        self.maxPlay_ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.maxPlay_ratingView.maxRating = 5
        self.maxPlay_ratingView.minRating = 0
        self.maxPlay_ratingView.editable = false
        self.maxPlay_ratingView.halfRatings = false
        self.maxPlay_ratingView.floatRatings = false
        self.maxPlay_Song_img.layer.cornerRadius = 10
        self.updateAudioProgressView()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        self.SongDetailAPI()
        slooooooooooot = 0
        APICall = true
        self.SongListAPI()
//        let AddPicture_url = URL.init(string: songImage)
//        self.maxPlay_Song_img.sd_setImage(with: AddPicture_url)
//        self.maxPlay_SongName_lbl.text = songName
//        self.maxPlay_SongArtist_lbl.text = songArtist
        // Do any additional setup after loading the view.
        
        let maxValue = Float(self.audioLen)
//        print("maxValue",maxValue)

        let currentValue = Float(self.audioCurren)
//        print("currentValue",currentValue)

        self.maxPlay_SongSlider.minimumValue = 0
        self.maxPlay_SongSlider.maximumValue = maxValue
        self.maxPlay_SongSlider.isContinuous = true
        
        self.maxPlay_SongSlider.value = currentValue

        
    }
    
    @objc func updateAudioProgressView()
    {
        if avPlayer.isPlaying
        {
            // Update progress
            self.maxPlay_SongSlider.maximumValue = CFloat(avPlayer.duration)
            self.maxPlay_SongSlider.minimumValue = 0.0
            let pause = UIImage(named: "pause")
            self.maxPlay_SongPlayPause_btn.setImage(pause, for: .normal)
            self.maxPlay_SongSlider.value = CFloat(avPlayer.currentTime)
            self.avPlayer.prepareToPlay()
            self.maxPlay_SongSlider.isUserInteractionEnabled = true
            self.maxPlay_SongPlayPause_btn.isUserInteractionEnabled = true
            self.showTotalSongLength()
            self.maxPlay_SongMinTime_lbl.text = "00:00"
        }else{
            let play = UIImage(named: "play-1")
            self.maxPlay_SongPlayPause_btn.setImage(play, for: .normal)
        }
    }
    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        //        self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
        //self.liveLabel.text = String(self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    func SongDetailAPI(){
        if Reachability.isConnectedToNetwork() == true{
        showWaitOverlay()
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.userId), forKey: "user_id" as NSCopying)
        parameterDictionary.setValue(DataManager.getVal(self.SongID), forKey: "song_id")
        print(parameterDictionary)
        
        let methodName = "song_detail"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
        DispatchQueue.main.async(execute: {
            let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
            let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
            if status == "1" {
                 var response = NSDictionary()
                 response = (responseData?.object(forKey: "data") as? NSDictionary)!
                 print("response: \(String(describing: response))")
                 self.maxPlay_SongName_lbl.text = response.value(forKey: "song_name") as? String
                 self.maxPlay_Song_img.sd_setImage(with: URL(string: (response.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                 var name:String!
                 name = response.value(forKey: "as_type_name") as? String
                 var id :Int!
                 id = response.value(forKey: "id") as? Int
                 let defaults = UserDefaults.standard
                 defaults.setValue(id, forKey: "Song_Id")
                 defaults.synchronize()
                 var date:String!
                 date = response.value(forKey: "uploaded_date") as? String
                 self.maxPlay_SongArtist_lbl.text = name + " | " + date
                 self.songFile = response.value(forKey: "song_file") as! String
                 var type:String!
                 type =  response.value(forKey: "song_type") as? String
                 self.maxPlay_SongType_lbl.text = "Song Type:" + " " + type
                 var ratingPercentage:Int!
                 ratingPercentage = response.value(forKey: "rating_percentage") as? Int
                 self.maxPlay_SongRating_lbl.text = (String(ratingPercentage) + "%")
                 var price:NSNumber!
                 price =  response.value(forKey: "price") as? NSNumber
                 self.maxPlay_SongPrice_lbl.text = "Price:" + " $" + price.stringValue
                 let vc =  self.songFile.replacingOccurrences(of: " ", with: "")
                 //let AddPicture_url = URL.init(string: vc)
                 let vc1 =   NSURL.init(string: vc)!
                // print(AddPicture_url!)
                // self.currentAudioPath = vc1
                 let pause = UIImage(named: "pause")
                 self.maxPlay_SongPlayPause_btn.setImage(pause, for: .normal)
    //             self.downloadFileFromURL(url:vc1)
                 
                 var rating1:NSNumber!
                 rating1 = response.value(forKey: "rating") as? NSNumber
                 
                 var rate = Float()
                 rate = Float(truncating: rating1)
                 self.maxPlay_ratingView.rating = Float(truncating: NSNumber(value: rate))
                 
    //             print("\(String(describing: self.currentAudioPath))")
                 var view:Int!
                 view = response.value(forKey: "viewer") as? Int
                 var viewer:String!
                 viewer = String(view)
                 self.maxPlay_SongViews_lbl.text = viewer + "  " + "Views"
                 var likeunlikeSt:Int!
                 likeunlikeSt = response.value(forKey: "like_unlike_status") as? Int
                 if likeunlikeSt == 2 {
                     self.maxPlay_SongLike_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                     self.maxPlay_SongDislike_btn.setImage(UIImage(named: "thumbs_down"), for: .normal)
                 }else if likeunlikeSt == 1 {
                     self.maxPlay_SongLike_btn.setImage(UIImage(named: "thumbs_up"), for: .normal)
                     self.maxPlay_SongDislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
                 }else {
                     self.maxPlay_SongLike_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                     self.maxPlay_SongDislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
                 }
                 self.newID = response.value(forKey: "id") as? Int
                 var TotalLike:Int!
                 TotalLike = response.value(forKey: "total_likes") as? Int
                 var TlLikeCount:String!
                 TlLikeCount = String(TotalLike)
                 self.maxPlay_likeCountLbl.text = TlLikeCount
                 
                 var TotalUnLike:Int!
                 TotalUnLike = response.value(forKey: "total_unlikes") as? Int
                 var TlUnLikeCount:String!
                 TlUnLikeCount = String(TotalUnLike)
                 self.maxPlay_unlikeCountLbl.text = TlUnLikeCount
                 self.FavSts = response.value(forKey: "favouriteStatus") as? Int
                 if self.FavSts == 1 {
                     self.maxPlay_SongFav_btn.setImage(UIImage(named: "heart-1"), for: .normal)
                 }else {
                     self.maxPlay_SongFav_btn.setImage(UIImage(named: "heart"), for: .normal)
                 }
            }else{
                self.removeAllOverlays()
            }
          })
         }
        }
    }
    func SongListAPI(){
    if Reachability.isConnectedToNetwork() == true{
        showWaitOverlay()
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.userId), forKey: "user_id" as NSCopying)
        parameterDictionary.setValue(DataManager.getVal("all"), forKey: "as_type")
        parameterDictionary.setValue(DataManager.getVal(SongType), forKey: "list_type")
        parameterDictionary.setValue(DataManager.getVal(str_lat), forKey: "lat")
        parameterDictionary.setValue(DataManager.getVal(str_long), forKey: "lng")
        parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
        print(parameterDictionary)
        
        let methodName = "song_list"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
        DispatchQueue.main.async(execute: {
            let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
            let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
            if status == "1" {
                var arr_data = NSMutableArray()
                  arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                  self.APICall = true
                  if arr_data.count != 0 {
                  self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                  self.slooooooooooot = self.slooooooooooot + 10
                  arr_data.removeAllObjects()
                }
                  self.maxPlay_SongTableView.reloadData()
                  self.removeAllOverlays()
            }else{
              self.maxPlay_SongTableView.reloadData()
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
            noDataLabel.text = "No Song Found"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == maxPlay_SongTableView {
            return response.count
        }else {
            return texts.count
        }
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == maxPlay_SongTableView {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SongViewCell
//        var dict = NSDictionary()
//        dict = response.object(at: indexPath.row) as! NSDictionary
//        cell.song_img.layer.cornerRadius = 10
//        cell.song_img.sd_setImage(with: URL(string: (dict.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
//        cell.song_Name.text = dict.value(forKey: "song_name") as? String
//        cell.song_Artist_Name.text = dict.value(forKey: "as_type_name") as? String
//        cell.more_btn.tag = indexPath.row
//        cell.more_btn.addTarget(self, action: #selector(HandleAdd(_:)), for: .touchUpInside)
//        return cell
//        }else {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
//        cell.backgroundColor = UIColor.darkGray
//        cell.textLabel?.text = self.texts[(indexPath as NSIndexPath).row]
//        cell.textLabel?.textColor = UIColor.white
//        return cell
//        }
//
//    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == maxPlay_SongTableView {
       // tableView.deselectRow(at: indexPath, animated: true)
       // animateTableViewToOffScreen()
        var songNameDict = NSDictionary();
        songNameDict = response.object(at: indexPath.row) as! NSDictionary
        SongID = songNameDict.value(forKey: "id") as! Int
        idnew = songNameDict.value(forKey: "id") as? Int
        self.songfile1 = songNameDict.value(forKey: "song_file") as? String
        let vc =  self.songfile1.replacingOccurrences(of: " ", with: "")
        let AddPicture_url = URL.init(string: vc)
        print(AddPicture_url!)
        self.currentAudioPath = AddPicture_url
//        downloadFileFromURL(url: currentAudioPath! as NSURL)
//        self.urlChange()
       NotificationCenter.default.post(name: NSNotification.Name("PlaySong"), object: nil)
        }else {
            if indexPath.row == 0 {
                var dict = NSDictionary()
                dict = response.object(at:myindexpath.row) as! NSDictionary
                idnew = dict.value(forKey: "id") as? Int
                let defaults = UserDefaults.standard
                defaults.set(SongID, forKey: "Song_Id")
                defaults.synchronize()
                let nextview = AddPlaylistView.intitiateFromNib()
                let model = AddPlyaModel()
                nextview.buttonCancleHandler = {
                    model.closewithAnimation()
                }
                model.show(view: nextview)
                self.popover.dismiss()
            }else {
                var dict = NSDictionary()
                dict = response.object(at: myindexpath.row) as! NSDictionary
                var songfiles:String!
                songfiles = dict.value(forKey: "song_file") as? String
                // set up activity view controller
                let textToShare = [ songfiles ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                // exclude some activity types from the list (optional)
                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
                
                activityViewController.popoverPresentationController?.sourceRect = self.navigationController?.navigationBar.frame ?? CGRect.zero
                activityViewController.popoverPresentationController?.sourceView = self.navigationController?.navigationBar
                self.present(activityViewController, animated: true)
                self.popover.dismiss()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
            showWaitOverlay()
            Parsing().DiscoverAllSongList(UserId: userId, AsType: "all", ListType: SongType, Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAllSongList"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongListAction), name: NSNotification.Name(rawValue: "DiscoverAllSongList"), object: nil)
            
        }
    }
    
    // Prepare audio for playing
    func prepareAudio(url : URL){
        
        print("playing \(url)")

        do {
            self.avPlayer = try AVAudioPlayer(contentsOf: url)
            self.avPlayer.prepareToPlay()
            self.avPlayer.volume = 1.0
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        avPlayer.delegate = self
//        audioLength1 = audioPlayer.duration
        DispatchQueue.main.async {
            self.playAudio()
            self.maxPlay_SongSlider.maximumValue = CFloat(self.audioLen)
            self.maxPlay_SongSlider.minimumValue = 0.0
            self.maxPlay_SongSlider.value = 0.0
            self.avPlayer.prepareToPlay()
            self.maxPlay_SongSlider.isUserInteractionEnabled = true
            self.maxPlay_SongPlayPause_btn.isUserInteractionEnabled = true
            self.showTotalSongLength()
            self.maxPlay_SongMinTime_lbl.text = "00:00"
        }
        
        
    }
    
//    //MARK:- Player Controls Methods
//    func  playAudio(){
//        avPlayer.play()
//        startTimer()
//    }
////
////    func  playAudio1(){
////        audioPlayer.play()
////        startTimer1()
////    }
////
//
//
//    func stopAudiplayer(){
//        avPlayer.stop();
//
//    }
//
//    func pauseAudioPlayer(){
//        avPlayer.pause()
//
//    }
    
//    @objc func HandleAdd(_ sender:UIButton) {
//        if IS_IPHONE_5S {
//            let buttonPosition = sender.convert(CGPoint.zero, to: maxPlay_SongTableView)
//            myindexpath = maxPlay_SongTableView.indexPathForRow(at: buttonPosition)! as NSIndexPath
//            let cell = maxPlay_SongTableView.dequeueReusableCell(withIdentifier: "cell", for: myindexpath as IndexPath) as! SongViewCell
//            cell.more_btn.tag = myindexpath.row
//            table = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 130))
//            table.delegate = self
//            table.dataSource = self
//            table.separatorStyle = .none
//            table.isScrollEnabled = false
////            let startPoint = CGPoint(x: self.view.frame.width - 78, y: 340)
//            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-180, height: 130))
//            aView.backgroundColor = UIColor.lightGray
//            let popover = Popover()
//            popover.popoverColor = UIColor.darkGray
//            aView.addSubview(table)
//            self.popover = Popover(options: self.popoverOptions)
//            self.popover.popoverColor = UIColor.darkGray
//            self.popover.willShowHandler = {
//                print("willShowHandler")
//            }
//            self.popover.didShowHandler = {
//                print("didShowHandler")
//            }
//            self.popover.willDismissHandler = {
//                print("willDismissHandler")
//            }
//            self.popover.didDismissHandler = {
//                print("didDismissHandler")
//            }
//            self.popover.show(aView, fromView: sender)
//        }else if IS_IPHONE_7 {
//            let buttonPosition = sender.convert(CGPoint.zero, to: maxPlay_SongTableView)
//            myindexpath = maxPlay_SongTableView.indexPathForRow(at: buttonPosition)! as NSIndexPath
//            let cell = maxPlay_SongTableView.dequeueReusableCell(withIdentifier: "cell", for: myindexpath as IndexPath) as! SongViewCell
//            cell.more_btn.tag = myindexpath.row
//            table = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 95))
//            table.delegate = self
//            table.dataSource = self
//            table.separatorStyle = .none
//            table.isScrollEnabled = false
////            let startPoint = CGPoint(x: self.view.frame.width - 78, y: 340)
//            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-240, height: 95))
//            aView.backgroundColor = UIColor.lightGray
//            let popover = Popover()
//            popover.popoverColor = UIColor.darkGray
//            aView.addSubview(table)
//            self.popover = Popover(options: self.popoverOptions)
//            self.popover.popoverColor = UIColor.darkGray
//            self.popover.willShowHandler = {
//                print("willShowHandler")
//            }
//            self.popover.didShowHandler = {
//                print("didShowHandler")
//            }
//            self.popover.willDismissHandler = {
//                print("willDismissHandler")
//            }
//            self.popover.didDismissHandler = {
//                print("didDismissHandler")
//            }
//            self.popover.show(aView, fromView: sender)
//        }else if IS_IPHONE_X {
//            let buttonPosition = sender.convert(CGPoint.zero, to: maxPlay_SongTableView)
//            myindexpath = maxPlay_SongTableView.indexPathForRow(at: buttonPosition)! as NSIndexPath
//            let cell = maxPlay_SongTableView.dequeueReusableCell(withIdentifier: "cell", for: myindexpath as IndexPath) as! SongViewCell
//            cell.more_btn.tag = myindexpath.row
//            table = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 95))
//            table.delegate = self
//            table.dataSource = self
//            table.separatorStyle = .none
//            table.isScrollEnabled = false
////            let startPoint = CGPoint(x: self.view.frame.width - 68, y: 400)
//            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-240, height: 95))
//            aView.backgroundColor = UIColor.lightGray
//            let popover = Popover()
//            popover.popoverColor = UIColor.darkGray
//            aView.addSubview(table)
//            self.popover = Popover(options: self.popoverOptions)
//            self.popover.popoverColor = UIColor.darkGray
//            self.popover.willShowHandler = {
//                print("willShowHandler")
//            }
//            self.popover.didShowHandler = {
//                print("didShowHandler")
//            }
//            self.popover.willDismissHandler = {
//                print("willDismissHandler")
//            }
//            self.popover.didDismissHandler = {
//                print("didDismissHandler")
//            }
//            self.popover.show(aView, fromView: sender)
//        }else if IS_IPHONE_XR {
//            let buttonPosition = sender.convert(CGPoint.zero, to: maxPlay_SongTableView)
//            myindexpath = maxPlay_SongTableView.indexPathForRow(at: buttonPosition)! as NSIndexPath
//            let cell = maxPlay_SongTableView.dequeueReusableCell(withIdentifier: "cell", for: myindexpath as IndexPath) as! SongViewCell
//            cell.more_btn.tag = myindexpath.row
//            table = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 95))
//            table.delegate = self
//            table.dataSource = self
//            table.separatorStyle = .none
//            table.isScrollEnabled = false
////            let startPoint = CGPoint(x: self.view.frame.width - 78, y: 400)
//            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-280, height: 95))
//            aView.backgroundColor = UIColor.lightGray
//            let popover = Popover()
//            popover.popoverColor = UIColor.darkGray
//            aView.addSubview(table)
//            self.popover = Popover(options: self.popoverOptions)
//            self.popover.popoverColor = UIColor.darkGray
//            self.popover.willShowHandler = {
//                print("willShowHandler")
//            }
//            self.popover.didShowHandler = {
//                print("didShowHandler")
//            }
//            self.popover.willDismissHandler = {
//                print("willDismissHandler")
//            }
//            self.popover.didDismissHandler = {
//                print("didDismissHandler")
//            }
//            self.popover.show(aView, fromView: sender)
//        }else{
//            let buttonPosition = sender.convert(CGPoint.zero, to: maxPlay_SongTableView)
//            myindexpath = maxPlay_SongTableView.indexPathForRow(at: buttonPosition)! as NSIndexPath
//            let cell = maxPlay_SongTableView.dequeueReusableCell(withIdentifier: "cell", for: myindexpath as IndexPath) as! SongViewCell
//            cell.more_btn.tag = myindexpath.row
//            table = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 95))
//            table.delegate = self
//            table.dataSource = self
//            table.separatorStyle = .none
//            table.isScrollEnabled = false
////            let startPoint = CGPoint(x: self.view.frame.width - 78, y: 400)
//            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-280, height: 95))
//            aView.backgroundColor = UIColor.lightGray
//            let popover = Popover()
//            popover.popoverColor = UIColor.darkGray
//            aView.addSubview(table)
//            self.popover = Popover(options: self.popoverOptions)
//            self.popover.popoverColor = UIColor.darkGray
//            self.popover.willShowHandler = {
//                print("willShowHandler")
//            }
//            self.popover.didShowHandler = {
//                print("didShowHandler")
//            }
//            self.popover.willDismissHandler = {
//                print("willDismissHandler")
//            }
//            self.popover.didDismissHandler = {
//                print("didDismissHandler")
//            }
//            self.popover.show(aView, fromView: sender)
//
//        }
//    }
//
//    @IBAction func commentAction_btn(_ sender: Any) {
//        let popover = Popover()
//        popover.isHidden = true
//        let defaults = UserDefaults.standard
//        defaults.set(newID, forKey: "POSTID")
//        defaults.synchronize()
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentAllSongViewController") as! CommentAllSongViewController
//        navigationController?.pushViewController(vc, animated: true)
//    }
    @IBAction func songSlider_Action(_ sender: UISlider) {
        if avPlayer.isPlaying {
            
        }else{
            avPlayer.currentTime = TimeInterval(sender.value)
        }
    }
    @IBAction func prevSongAction_Btn(_ sender: Any) {
    }
    
    @IBAction func nextSongAction_Btn(_ sender: Any) {
    }
    
    @IBAction func playPauseAction_btn(_ sender: Any) {
        
    }
    
    @IBAction func likeSongAction_Btn(_ sender: Any) {
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.userId), forKey: "user_id" as NSCopying)
        parameterDictionary.setValue(DataManager.getVal(self.SongID), forKey: "song_id")
        parameterDictionary.setValue(DataManager.getVal(1), forKey: "status")
        print(parameterDictionary)
        
        let methodName = "songLikeUnlike"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
        DispatchQueue.main.async(execute: {
            let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
            let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
            if status == "1" {
                self.likeSts = (responseData?.object(forKey: "like_status")) as? Int
                self.likeCount = (responseData?.object(forKey: "likecount")) as? Int
                self.UnlikeSts = (responseData?.object(forKey: "unlike_status")) as? Int
                self.UnlikeCount = (responseData?.object(forKey: "unlikecount")) as? Int
                var likecou:String!
                likecou = String(self.likeCount)
                var Unlikecou:String!
                Unlikecou = String(self.UnlikeCount)
                self.maxPlay_likeCountLbl.text = likecou
                self.maxPlay_unlikeCountLbl.text = Unlikecou
                if self.likeSts == 1 {
                    self.maxPlay_SongLike_btn.setImage(UIImage(named: "thumbs_up"), for: .normal)
                    self.maxPlay_SongDislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
                }else {
                    self.maxPlay_SongLike_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                }
                self.removeAllOverlays()
            }else{
                self.removeAllOverlays()
            }
          })
         }
    }
    
    @IBAction func dislikeSongAction_Btn(_ sender: Any) {
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.userId), forKey: "user_id" as NSCopying)
        parameterDictionary.setValue(DataManager.getVal(self.SongID), forKey: "song_id")
        parameterDictionary.setValue(DataManager.getVal(2), forKey: "status")
        print(parameterDictionary)
        
        let methodName = "songLikeUnlike"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
        DispatchQueue.main.async(execute: {
            let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
            let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
            if status == "1" {
                self.likeSts = (responseData?.object(forKey: "like_status")) as? Int
                self.likeCount = (responseData?.object(forKey: "likecount")) as? Int
                self.UnlikeSts = (responseData?.object(forKey: "unlike_status")) as? Int
                self.UnlikeCount = (responseData?.object(forKey: "unlikecount")) as? Int
                if self.UnlikeSts == 1 {
                    self.maxPlay_SongLike_btn.setImage(UIImage(named: "thumbs-up-hand-symbol (2)"), for: .normal)
                    self.maxPlay_SongDislike_btn.setImage(UIImage(named: "thumbs_down"), for: .normal)
                }else {
                    self.maxPlay_SongDislike_btn.setImage(UIImage(named: "thumbs-up-hand-unlike"), for: .normal)
                }
                var likecou:String!
                likecou = String(self.likeCount)
                var Unlikecou:String!
                Unlikecou = String(self.UnlikeCount)
                self.maxPlay_likeCountLbl.text = likecou
                self.maxPlay_unlikeCountLbl.text = Unlikecou
                self.removeAllOverlays()
            }else{
                self.removeAllOverlays()
            }
          })
         }
    }
    
    @IBAction func favSongAction_BTn(_ sender: Any) {
        let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setObject(DataManager.getVal(self.userId), forKey: "user_id" as NSCopying)
            parameterDictionary.setValue(DataManager.getVal(self.SongID), forKey: "favourite_id")
            parameterDictionary.setValue(DataManager.getVal("song"), forKey: "favourite_type")
            print(parameterDictionary)
            
            let methodName = "favourite"
            
            DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                if status == "1" {
                    self.maxPlay_SongFav_btn.setImage(UIImage(named: "heart-1"), for: .normal)
                    self.removeAllOverlays()
                }else{
                    self.maxPlay_SongFav_btn.setImage(UIImage(named: "heart"), for: .normal)
                    self.removeAllOverlays()
                }
            })
        }
    }
    
//    func downloadFileFromURL(url:NSURL){
//
//        var downloadTask:URLSessionDownloadTask
//        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
//
//            if error == nil {
//                 print(url)
//                self?.prepareAudio(url: URL!)
//
//           }else {
//                self!.removeAllOverlays()
//           }
//        })
//        downloadTask.resume()
//
//    }
    
    //MARK:-
    
    func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SongDetailpageViewController.update(_:)), userInfo: nil,repeats: true)
            timer?.fire()
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        
    }
    
    
    @objc func update(_ timer: Timer){
        if !avPlayer.isPlaying{
            return
        }
        let time = calculateTimeFromNSTimeInterval(avPlayer.currentTime)
        maxPlay_SongMinTime_lbl.text  = "\(time.minute):\(time.second)"
        maxPlay_SongSlider.value = CFloat(avPlayer.currentTime)
        UserDefaults.standard.set(maxPlay_SongSlider.value , forKey: "playerProgressSliderValue")
        
        
    }
    
    func retrievePlayerProgressSliderValue(){
        let playerProgressSliderValue =  UserDefaults.standard.float(forKey: "playerProgressSliderValue")
        if playerProgressSliderValue != 0 {
            maxPlay_SongSlider.value  = playerProgressSliderValue
            avPlayer.currentTime = TimeInterval(playerProgressSliderValue)
            
            let time = calculateTimeFromNSTimeInterval(avPlayer.currentTime)
            maxPlay_SongMinTime_lbl.text  = "\(time.minute):\(time.second)"
            maxPlay_SongSlider.value = CFloat(avPlayer.currentTime)
            
        }else{
            maxPlay_SongSlider.value = 0.0
            avPlayer.currentTime = 0.0
            maxPlay_SongMinTime_lbl.text = "00:00"
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
        maxPlay_SongMacTime_lbl.text = totalLengthOfAudio1
    }
    
    
    func calculateSongLength(){
        let time = calculateTimeFromNSTimeInterval(Audiolength)
        totalLengthOfAudio1 = "\(time.minute):\(time.second)"
    }
    
    
    func assingSliderUI () {
        let minImage = UIImage(named: "playing")
        let maxImage = UIImage(named: "whole")
        let thumb = UIImage(named: "Oval 3")
        
        maxPlay_SongSlider.setMinimumTrackImage(minImage, for: UIControl.State())
        maxPlay_SongSlider.setMaximumTrackImage(maxImage, for: UIControl.State())
        maxPlay_SongSlider.setThumbImage(thumb, for: UIControl.State())
        
        
    }

    
}
