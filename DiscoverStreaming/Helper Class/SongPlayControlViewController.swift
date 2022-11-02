/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Popover
import SwiftToast
import AVFoundation
import MediaPlayer
import CoreLocation


class SongPlayControlViewController: UIViewController,AVAudioPlayerDelegate,FloatRatingViewDelegate,SongSubscriber,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
   
    
    var currentSong: Song?
  //  var miniPlayer: MiniPlayerViewController?
    var mp3Player:MP3Player?
    var timer:Timer?
    
    var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
        .type(.auto),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    let screenWidth = UIScreen.main.bounds.size.width
    
    let IS_IPHONE_7 = (UIScreen.main.bounds.size.height - 667) != 0.0 ? false : true
    let IS_IPHONE_X = (UIScreen.main.bounds.size.height - 812) != 0.0 ? false : true
    let IS_IPHONE_5S = (UIScreen.main.bounds.size.height - 568) != 0.0 ? false : true
    let IS_IPHONE_XR = (UIScreen.main.bounds.size.height - 896) != 0.0 ? false : true
    
    
    @IBOutlet weak var songscrollview: UIScrollView!
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
    
    @IBOutlet weak var songListTableview: UITableView!
    @IBOutlet weak var goodnameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    var defaults:UserDefaults!
    var userId:Int!
    var SongID:Int!
    var idnew:Int!
    let selectedBackground = 1
    
    var audioPlayer1: AVPlayer? = nil
    var audioPlayer = AVAudioPlayer()
    var currentAudio = ""
    var currentAudioPath:URL!
//    var timer:Timer!
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
    var slooooooooooot = Int()
    var APICall = Bool()
    
    var table = UITableView()
    fileprivate var texts = ["Add to playlist","Share"]
    
    var str_lat:NSString!
    var str_long:NSString!
    var Manager: CLLocationManager!
    var isCall = Bool()
    var response = NSMutableArray()
    var songfile1:String!
    var currentAudioIndex = 0
    var songfile2:String!
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
               // self.songImage.sd_setImage(with: URL(string: (response.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                var name:String!
                name = response.value(forKey: "as_type_name") as? String
                var id :Int!
                id = response.value(forKey: "id") as? Int
                let defaults = UserDefaults.standard
                defaults.setValue(id, forKey: "Song_Id")
                defaults.synchronize()
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
                //let AddPicture_url = URL.init(string: vc)
                let vc1 =   NSURL.init(string: vc)!
               // print(AddPicture_url!)
               // self.currentAudioPath = vc1
                let pause = UIImage(named: "pause")
                self.playBtn.setImage(pause, for: .normal)
                self.downloadFileFromURL(url:vc1)
                
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
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongDetail"), object: nil)
               // self.removeAllOverlays()
            }
        }
    }
    
    
    
    
    @objc func DiscoverSongDetailAction1(_ notification: Notification) {
        
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
                var name:String!
                name = response.value(forKey: "as_type_name") as? String
                
                var date:String!
                date = response.value(forKey: "uploaded_date") as? String
                self.dateLbl.text = name + " | " + date
                self.songfile = response.value(forKey: "song_file") as! String
                
                let vc =  self.songfile.replacingOccurrences(of: " ", with: "")
                let AddPicture_url = URL.init(string: vc)
                print(AddPicture_url!)
                self.currentAudioPath = AddPicture_url
                //self.downloadFileFromURL(url: self.currentAudioPath! as NSURL)
                 self.downloadFileFromURL2(url: self.currentAudioPath! as NSURL)
                var type:String!
                type =  response.value(forKey: "song_type") as? String
                self.typeLbl.text = "Song Type:" + " " + type
                
                var price:NSNumber!
                price =  response.value(forKey: "price") as? NSNumber
                self.priceLbl.text = "Price:" + " $" + price.stringValue
                
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
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongDetail"), object: nil)
               // self.removeAllOverlays()
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
    
    
    @objc func DiscoverSongListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.APICall = false
                self.songListTableview.reloadData()
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
                self.songListTableview.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mp3Player = MP3Player()
        setupNotificationCenter()
        setTrackName()
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
        
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        // Do any additional setup after loading the view.
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
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongDetail"), object: nil)
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
        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
        determineMyCurrentLocation()
        
        
        // self.assingSliderUI()
        // self.retrievePlayerProgressSliderValue()
        //LockScreen Media control registry
        if UIApplication.shared.responds(to: #selector(UIApplication.beginReceivingRemoteControlEvents)){
            UIApplication.shared.beginReceivingRemoteControlEvents()
            UIApplication.shared.beginBackgroundTask(expirationHandler: { () -> Void in
            })
        }
    }
    
    
    
    func determineMyCurrentLocation() {
        Manager = CLLocationManager()
        Manager.delegate = self
        Manager.desiredAccuracy = kCLLocationAccuracyBest
        Manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            Manager.startUpdatingLocation()
            Manager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        
        
        // self.map.setRegion(region, animated: true)
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        print("\(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
        
        str_lat = ((String(userLocation.coordinate.latitude) as NSString))
        str_long = ((String(userLocation.coordinate.longitude) as NSString))
        print("lat: \(String(describing: str_lat))")
        print("long: \(String(describing: str_long))")
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in
            // print(placemarks!)
            //            if let placemarks = placemarks as? [CLPlacemark], placemarks.count > 0 {
            //                var placemark = placemarks[0]
            //                print(placemark.addressDictionary)
        }
        
        if userLocation.coordinate.latitude>0  {
            
            if !isCall
            {
                if Reachability.isConnectedToNetwork() == true{
                    //showWaitOverlay()
                    Parsing().DiscoverAllSongList(UserId: userId, AsType: "all", ListType: "hotmusic", Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
                     NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAllSongList"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongListAction), name: NSNotification.Name(rawValue: "DiscoverAllSongList"), object: nil)
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
            manager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
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
        if tableView == songListTableview {
            return response.count
        }else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if tableView == songListTableview {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaySongListCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.songImage.sd_setImage(with: URL(string: (dict.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        cell.songNameLbl.text = dict.value(forKey: "song_name") as? String
        cell.arNameLbl.text = dict.value(forKey: "as_type_name") as? String
        cell.moreBtn.tag = indexPath.row
        cell.moreBtn.addTarget(self, action: #selector(HandleAdd(_:)), for: .touchUpInside)
        return cell
         }else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.backgroundColor = UIColor.darkGray
            cell.textLabel?.text = self.texts[(indexPath as NSIndexPath).row]
            cell.textLabel?.textColor = UIColor.white
            
            return cell
        }
    }
    
//    @objc func HandleAdd(_ sender: UIButton) {
//        var dict = NSDictionary()
//        dict = response.object(at:sender.tag) as! NSDictionary
//        idnew = dict.value(forKey: "id") as? Int
//        let defaults = UserDefaults.standard
//        defaults.set(SongID, forKey: "Song_Id")
//        defaults.synchronize()
//        let nextview = AddPlaylistView.intitiateFromNib()
//        let model = AddPlyaModel()
//        nextview.buttonCancleHandler = {
//            model.closewithAnimation()
//        }
//
//        model.show(view: nextview)
//    }
    
    
    @objc func HandleAdd(_ sender:UIButton) {
        if IS_IPHONE_5S {
            var myindexpath = NSIndexPath()
            let buttonPosition = sender.convert(CGPoint.zero, to: songListTableview)
            myindexpath = songListTableview.indexPathForRow(at: buttonPosition)! as NSIndexPath
            let cell = songListTableview.dequeueReusableCell(withIdentifier: "cell", for: myindexpath as IndexPath) as! PlaySongListCell
            cell.moreBtn.tag = myindexpath.row
            table = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 95))
            table.delegate = self
            table.dataSource = self
            table.separatorStyle = .none
            table.isScrollEnabled = false
            let startPoint = CGPoint(x: self.view.frame.width - 78, y: 340)
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-180, height: 95))
            aView.backgroundColor = UIColor.lightGray
            let popover = Popover()
            popover.popoverColor = UIColor.darkGray
            aView.addSubview(table)
            self.popover = Popover(options: self.popoverOptions)
            self.popover.popoverColor = UIColor.darkGray
            self.popover.willShowHandler = {
                print("willShowHandler")
            }
            self.popover.didShowHandler = {
                print("didShowHandler")
            }
            self.popover.willDismissHandler = {
                print("willDismissHandler")
            }
            self.popover.didDismissHandler = {
                print("didDismissHandler")
            }
            self.popover.show(aView, point: startPoint)
        }else if IS_IPHONE_7 {
            var myindexpath = NSIndexPath()
            let buttonPosition = sender.convert(CGPoint.zero, to: songListTableview)
            myindexpath = songListTableview.indexPathForRow(at: buttonPosition)! as NSIndexPath
            let cell = songListTableview.dequeueReusableCell(withIdentifier: "cell", for: myindexpath as IndexPath) as! PlaySongListCell
            cell.moreBtn.tag = myindexpath.row
            table = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 95))
            table.delegate = self
            table.dataSource = self
            table.separatorStyle = .none
            table.isScrollEnabled = false
            let startPoint = CGPoint(x: self.view.frame.width - 78, y: 340)
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-240, height: 95))
            aView.backgroundColor = UIColor.lightGray
            let popover = Popover()
            popover.popoverColor = UIColor.darkGray
            aView.addSubview(table)
            self.popover = Popover(options: self.popoverOptions)
            self.popover.popoverColor = UIColor.darkGray
            self.popover.willShowHandler = {
                print("willShowHandler")
            }
            self.popover.didShowHandler = {
                print("didShowHandler")
            }
            self.popover.willDismissHandler = {
                print("willDismissHandler")
            }
            self.popover.didDismissHandler = {
                print("didDismissHandler")
            }
            self.popover.show(aView, point: startPoint)
        }else if IS_IPHONE_X {
            var myindexpath = NSIndexPath()
            let buttonPosition = sender.convert(CGPoint.zero, to: songListTableview)
            myindexpath = songListTableview.indexPathForRow(at: buttonPosition)! as NSIndexPath
            let cell = songListTableview.dequeueReusableCell(withIdentifier: "cell", for: myindexpath as IndexPath) as! PlaySongListCell
            cell.moreBtn.tag = myindexpath.row
            table = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 95))
            table.delegate = self
            table.dataSource = self
            table.separatorStyle = .none
            table.isScrollEnabled = false
            let startPoint = CGPoint(x: self.view.frame.width - 68, y: 400)
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-240, height: 95))
            aView.backgroundColor = UIColor.lightGray
            let popover = Popover()
            popover.popoverColor = UIColor.darkGray
            aView.addSubview(table)
            self.popover = Popover(options: self.popoverOptions)
            self.popover.popoverColor = UIColor.darkGray
            self.popover.willShowHandler = {
                print("willShowHandler")
            }
            self.popover.didShowHandler = {
                print("didShowHandler")
            }
            self.popover.willDismissHandler = {
                print("willDismissHandler")
            }
            self.popover.didDismissHandler = {
                print("didDismissHandler")
            }
            self.popover.show(aView, point: startPoint)
        }else if IS_IPHONE_XR {
            var myindexpath = NSIndexPath()
            let buttonPosition = sender.convert(CGPoint.zero, to: songListTableview)
            myindexpath = songListTableview.indexPathForRow(at: buttonPosition)! as NSIndexPath
            let cell = songListTableview.dequeueReusableCell(withIdentifier: "cell", for: myindexpath as IndexPath) as! PlaySongListCell
            cell.moreBtn.tag = myindexpath.row
            table = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 95))
            table.delegate = self
            table.dataSource = self
            table.separatorStyle = .none
            table.isScrollEnabled = false
            let startPoint = CGPoint(x: self.view.frame.width - 78, y: 400)
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-280, height: 95))
            aView.backgroundColor = UIColor.lightGray
            let popover = Popover()
            popover.popoverColor = UIColor.darkGray
            aView.addSubview(table)
            self.popover = Popover(options: self.popoverOptions)
            self.popover.popoverColor = UIColor.darkGray
            self.popover.willShowHandler = {
                print("willShowHandler")
            }
            self.popover.didShowHandler = {
                print("didShowHandler")
            }
            self.popover.willDismissHandler = {
                print("willDismissHandler")
            }
            self.popover.didDismissHandler = {
                print("didDismissHandler")
            }
            self.popover.show(aView, point: startPoint)
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == songListTableview {
       // tableView.deselectRow(at: indexPath, animated: true)
       // animateTableViewToOffScreen()
        var songNameDict = NSDictionary();
        songNameDict = response.object(at: indexPath.row) as! NSDictionary
        SongID = songNameDict.value(forKey: "id") as? Int
        idnew = songNameDict.value(forKey: "id") as? Int
        self.songfile1 = songNameDict.value(forKey: "song_file") as? String
        self.urlChange()
       NotificationCenter.default.post(name: NSNotification.Name("PlaySong"), object: nil)
        }else {
            if indexPath.row == 0 {
                var dict = NSDictionary()
                dict = response.object(at:indexPath.row) as! NSDictionary
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
                dict = response.object(at: indexPath.row) as! NSDictionary
                var songfiles:String!
                songfiles = dict.value(forKey: "song_file") as? String
                // set up activity view controller
                let textToShare = [ songfiles ]
                let activityViewController = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
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
            Parsing().DiscoverAllSongList(UserId: userId, AsType: "all", ListType: "hotmusic", Lat: str_lat as String?, Long: str_long as String?, Offset: slooooooooooot)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAllSongList"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongListAction), name: NSNotification.Name(rawValue: "DiscoverAllSongList"), object: nil)
            
        }
    }
    // MARK: - Song URL Action
    func urlChange(){
    let vc =  self.songfile1.replacingOccurrences(of: " ", with: "")
    let AddPicture_url = URL.init(string: vc)
    print(AddPicture_url!)
    self.currentAudioPath = AddPicture_url
    let pause = UIImage(named: "pause")
    self.playBtn.setImage( pause, for: .normal)
    self.favBtn.isUserInteractionEnabled = true
    self.likeBtn.isUserInteractionEnabled = true
    self.disLikeBtn.isUserInteractionEnabled = true
    self.playBtn.isUserInteractionEnabled = true
    self.sliderview.isUserInteractionEnabled = true
    let defaults = UserDefaults.standard
    defaults.set(SongID, forKey: "Song_Id")
    defaults.synchronize()
    downloadFileFromURL2(url: currentAudioPath! as NSURL)
    }
    
    
    func animateTableViewToOffScreen(){
        isTableViewOnscreen = false
        setNeedsStatusBarAppearanceUpdate()
        //  self.tableViewContainerTopConstrain.constant = 1000.0
        UIView.animate(withDuration: 0.20, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            //  self.tableViewContainer.layoutIfNeeded()
            
        }, completion: {
            (value: Bool) in
            // self.blurView.isHidden = true
        })
    }
    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        //        self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
        //self.liveLabel.text = String(self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
   
    override func viewDidLayoutSubviews() {
          songscrollview.isScrollEnabled = true
          songscrollview.contentSize = CGSize(width: self.view.frame.size.width, height: 600)
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
            if audioPlayer.isPlaying{
                mp3Player?.pause()
                timer?.invalidate()
                let play = UIImage(named: "play-1")
                self.playBtn.setImage(play, for: .normal)
            }else{
                mp3Player?.play()
                startTimer()
                let pause = UIImage(named: "pause")
                self.playBtn.setImage(pause, for: .normal)
            }
        }else {
            if shuffleState == true {
                shuffleArray.removeAll()
            }
            if audioPlayer.isPlaying{
                mp3Player?.pause()
                timer?.invalidate()
                let play = UIImage(named: "play-1")
                self.playBtn.setImage(play, for: .normal)
            }else{
                mp3Player?.play()
                startTimer()
                let pause = UIImage(named: "pause")
                self.playBtn.setImage(pause, for: .normal)
            }
        }
        
    }
    
    
    @IBAction func playPreviousSong(_ sender: Any) {
        mp3Player?.nextSong(songFinishedPlaying: false)
        startTimer()
    }
    
    @IBAction func playNextSong(_ sender: Any) {
        mp3Player?.previousSong()
        startTimer()
    }
    
    func setTrackName(){
        goodnameLbl.text = mp3Player?.getCurrentTrackName()
    }
    
    func setupNotificationCenter(){
        NotificationCenter.default.addObserver(self,selector:Selector(("setTrackName")),name:NSNotification.Name(rawValue: "SetTrackNameText"),object:nil)
    }
    
//    func startTimer(){
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector(("updateViewsWithTimer:")), userInfo: nil, repeats: true)
//    }
//
//    func updateViewsWithTimer(theTimer: Timer){
//        updateViews()
//    }
//
//    func updateViews(){
//        trackTime.text = mp3Player?.getCurrentTimeAsString()
//        if let progress = mp3Player?.getProgress() {
//            progressBar.progress = progress
//        }
//    }
    
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
        print("playing \(url)")
        do {
        self.audioPlayer = try AVAudioPlayer(contentsOf: url)
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.volume = 1.0
        } catch let error as NSError {
        //self.player = nil
        print(error.localizedDescription)
        } catch {
        print("AVAudioPlayer init failed")
        }
        audioPlayer.delegate = self
        audioLength1 = audioPlayer.duration
        DispatchQueue.main.async {
        self.playAudio()
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
        
        print("playing \(url)")

        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.volume = 1.0
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        audioPlayer.delegate = self
        audioLength1 = audioPlayer.duration
        DispatchQueue.main.async {
            self.playAudio()
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
            
            if error == nil {
                 print(url)
                self?.prepareAudio(url: URL!)
               
           }else {
                self!.removeAllOverlays()
           }
        })
        downloadTask.resume()
        
    }
    
    
    func downloadFileFromURL2(url:NSURL){
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            
            self?.prepareAudio(url: URL!)
            
        })
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            Parsing().DiscoverSongDetail(UserId: userId, SongId: SongID)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongDetail"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongDetailAction1), name: NSNotification.Name(rawValue: "DiscoverSongDetail"), object: nil)
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
            timer?.fire()
        }
    }
    
    func startTimer1(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(SongDetailpageViewController.update1(_:)), userInfo: nil, repeats: true)
            timer?.fire()
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        
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

