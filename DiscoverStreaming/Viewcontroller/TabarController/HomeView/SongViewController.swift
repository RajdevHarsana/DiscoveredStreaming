//
//  SongViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 27/06/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import Popover
import CoreLocation
import SwiftToast
import GoogleMobileAds
import AVFoundation
class SongViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,SongSubscriber,GADBannerViewDelegate,GADInterstitialDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var allViewHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var hotmusicCollectionView: UICollectionView!
    @IBOutlet weak var FeaturedSongCollection: UICollectionView!
    @IBOutlet weak var UpcomingEventCollectionView: UICollectionView!
    @IBOutlet weak var featuredArtistCollectionView: UICollectionView!
    @IBOutlet weak var RecentlyAddedTablview: UITableView!
    @IBOutlet weak var MoodCollectionView: UICollectionView!
    @IBOutlet weak var RecentlyPlayedCollectionView: UICollectionView!
    
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var upcomingHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var upbtnHeightCons: NSLayoutConstraint!
    @IBOutlet weak var upLbl: UILabel!
    @IBOutlet weak var uplblheightCons: NSLayoutConstraint!
    @IBOutlet weak var lineLblConstUp: NSLayoutConstraint!
    var currentSong: Song?
    var songfile1:String!
    var songMul:String!
    var asname:String!
    var img:String!
    var sngname:String!
    var currentAudioPath:URL!
    var audioPlayer = AVAudioPlayer()
    var audioLength1 = 0.0
    var audioCurrent = 0.0
    var like_unsts:Int!
    var myindexpath = NSIndexPath()
    var StatusLike_Unlike = Int()
    fileprivate var texts = [String]()
    var timer:Timer!
    var songTime:String!
    var sliderValue:Float!
    var table = UITableView()
    @IBOutlet weak var artistBtnHeightconstarints: NSLayoutConstraint!
    var locationManager = CLLocationManager()
    var myCustomView: PlayerView?
    var isComingFrom = String()
    @IBOutlet weak var contanerviewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var viewAllBtnUp: UIButton!
    @IBOutlet weak var viewAllBtnRA: UIButton!
    @IBOutlet weak var ViewAllBtnRP: UIButton!
    @IBOutlet weak var viewAllBtnMoods: UIButton!
    @IBOutlet weak var viewAllBtnFeSongs: UIButton!
    @IBOutlet weak var viewAllBtnFeArtist: UIButton!
    var Manager: CLLocationManager!
    var isCall = Bool()
    var str_lat:String!
    var str_long:String!
    var user_id:Int!
    var ArtistId:Int!
    var ArtistUserId:Int!
    var artistName:String!
    var MoodsId:Int!
    var listName:String!
    var updateTimer = Timer()
    var selectedMusic = 0
    var dataArray = [Any]()
    var SongID = Int()
    var likeSts:Int!
    var likeCount:Int!
    var UnlikeSts:Int!
    var UnlikeCount:Int!
    
    var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
        .type(.auto),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    
    let IS_IPHONE_7 = (UIScreen.main.bounds.size.height - 667) != 0.0 ? false : true
    let IS_IPHONE_X = (UIScreen.main.bounds.size.height - 812) != 0.0 ? false : true
    let IS_IPHONE_5S = (UIScreen.main.bounds.size.height - 568) != 0.0 ? false : true
    let IS_IPHONE_XR = (UIScreen.main.bounds.size.height - 896) != 0.0 ? false : true
    
    //    var bannerView =  GADBannerView()
    var interstitial: GADInterstitial?
    
    var defaults :UserDefaults!
    var Arsts:String!
    var response = NSMutableArray()
    var response1 = NSMutableArray()
    var response2 = NSMutableArray()
    var response3 = NSMutableArray()
    var response4 = NSMutableArray()
    var response5 = NSMutableArray()
    var response6 = NSMutableArray()
    var sngID:Int!
    var sngType = String()
    var App_Delegate = AppDelegate()
    
    @IBOutlet weak var becomeArtistImage: UIImageView!
    var artiststs:Int!
    var range:Int!
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var collectionTypeStr = String()
    var songListArray = [Any]()
    
    //MARK:- Login WebService
    @objc func DiscoverHomeListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.response.removeAllObjects()
                self.response1.removeAllObjects()
                self.response2.removeAllObjects()
                self.response3.removeAllObjects()
                self.response4.removeAllObjects()
                self.response5.removeAllObjects()
                self.response6.removeAllObjects()
                self.hotmusicCollectionView.reloadData()
                self.UpcomingEventCollectionView.reloadData()
                self.RecentlyPlayedCollectionView.reloadData()
                self.RecentlyAddedTablview.reloadData()
                self.MoodCollectionView.reloadData()
                self.FeaturedSongCollection.reloadData()
                self.featuredArtistCollectionView.reloadData()
                self.viewAllBtn.isHidden = true
                self.viewAllBtnRA.isHidden = true
                self.ViewAllBtnRP.isHidden = true
                self.viewAllBtnUp.isHidden = true
                self.viewAllBtnMoods.isHidden = true
                self.viewAllBtnFeSongs.isHidden = true
                self.viewAllBtnFeArtist.isHidden = true
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverDashboard"), object: nil)
                
            }
            else{
                self.artiststs = (notification.userInfo?["artist_status"] as? Int)
                if self.artiststs == 1 {
                    self.becomeArtistImage.isHidden = true
                    self.artistBtnHeightconstarints.constant = 0
                }else {
                    self.becomeArtistImage.isHidden = false
                    self.artistBtnHeightconstarints.constant = 150
                }
                var data = NSMutableDictionary()
                data = (notification.userInfo?["data"] as? NSMutableDictionary)!
                self.response = data.value(forKey: "hot_music") as! NSMutableArray
                self.response1 = data.value(forKey: "upcoming_events") as! NSMutableArray
                self.response2 = data.value(forKey: "recently_added") as! NSMutableArray
                self.response3 = data.value(forKey: "recently_played") as! NSMutableArray
                self.response4 = data.value(forKey: "moods") as! NSMutableArray
                self.response5 = data.value(forKey: "featured_songs") as! NSMutableArray
                self.response6 = data.value(forKey: "featured_artist") as! NSMutableArray
                
                if self.response.count == 0 {
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.hotmusicCollectionView.bounds.size.width, height: self.hotmusicCollectionView.bounds.size.height))
                    noDataLabel.text = "No Hot Music Availale"
                    noDataLabel.textColor     = UIColor.white
                    noDataLabel.textAlignment = .center
                    self.hotmusicCollectionView.backgroundView  = noDataLabel
                    self.viewAllBtn.isHidden = true
                }else {
                    
                }
                if self.response1.count == 0 {
                    self.UpcomingEventCollectionView.isHidden = true
                    self.upcomingHeightCons.constant = 0
                    self.upLbl.isHidden  = true
                    self.uplblheightCons.constant = 0
                    self.viewAllBtnUp.isHidden = true
                    self.upbtnHeightCons.constant = 0
                }else {
                    self.UpcomingEventCollectionView.isHidden = false
                    self.upcomingHeightCons.constant = 174
                    self.upLbl.isHidden  = false
                    self.uplblheightCons.constant = 26.5
                    self.viewAllBtnUp.isHidden = false
                    self.upbtnHeightCons.constant = 30
                }
                
                if self.response2.count == 0 {
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.RecentlyAddedTablview.bounds.size.width, height: self.RecentlyAddedTablview.bounds.size.height))
                    noDataLabel.text = "No Recentely Added Availale"
                    noDataLabel.textColor     = UIColor.white
                    noDataLabel.textAlignment = .center
                    self.RecentlyAddedTablview.backgroundView  = noDataLabel
                    self.viewAllBtnRA.isHidden = true
                }else {
                    
                }
                if self.response3.count == 0 {
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.RecentlyPlayedCollectionView.bounds.size.width, height: self.RecentlyPlayedCollectionView.bounds.size.height))
                    noDataLabel.text = "No Recentely Played Availale"
                    noDataLabel.textColor     = UIColor.white
                    noDataLabel.textAlignment = .center
                    self.RecentlyPlayedCollectionView.backgroundView  = noDataLabel
                    self.ViewAllBtnRP.isHidden = true
                }else {
                    
                }
                if self.response4.count == 0 {
                    let noDataLabel: UILabel    = UILabel(frame: CGRect(x: 0, y: 0, width: self.MoodCollectionView.bounds.size.width, height: self.MoodCollectionView.bounds.size.height))
                    noDataLabel.text = "No Moods Availale"
                    noDataLabel.textColor     = UIColor.white
                    noDataLabel.textAlignment = .center
                    self.MoodCollectionView.backgroundView  = noDataLabel
                    self.viewAllBtnMoods.isHidden = true
                }else {
                    
                }
                if self.response5.count == 0 {
                    let noDataLabel: UILabel   = UILabel(frame: CGRect(x: 0, y: 0, width: self.FeaturedSongCollection.bounds.size.width, height: self.FeaturedSongCollection.bounds.size.height))
                    noDataLabel.text = "No Moods Availale"
                    noDataLabel.textColor     = UIColor.white
                    noDataLabel.textAlignment = .center
                    self.FeaturedSongCollection.backgroundView  = noDataLabel
                    self.viewAllBtnFeSongs.isHidden = true
                }else {
                    
                }
                if self.response6.count == 0 {
                    let noDataLabel: UILabel   = UILabel(frame: CGRect(x: 0, y: 0, width: self.featuredArtistCollectionView.bounds.size.width, height: self.featuredArtistCollectionView.bounds.size.height))
                    noDataLabel.text = "No Moods Availale"
                    noDataLabel.textColor     = UIColor.white
                    noDataLabel.textAlignment = .center
                    self.featuredArtistCollectionView.backgroundView  = noDataLabel
                    self.viewAllBtnFeArtist.isHidden = true
                }else {
                    
                }
                self.hotmusicCollectionView.reloadData()
                self.UpcomingEventCollectionView.reloadData()
                self.RecentlyPlayedCollectionView.reloadData()
                self.RecentlyAddedTablview.reloadData()
                self.MoodCollectionView.reloadData()
                self.FeaturedSongCollection.reloadData()
                self.featuredArtistCollectionView.reloadData()
                self.viewAllBtn.isHidden = false
                self.viewAllBtnRA.isHidden = false
                self.ViewAllBtnRP.isHidden = false
                //self.viewAllBtnUp.isHidden = false
                self.viewAllBtnMoods.isHidden = false
                self.viewAllBtnFeSongs.isHidden = false
                self.viewAllBtnFeArtist.isHidden = false
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverDashboard"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    
    @objc func DiscoverSongLikeAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                //                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongLikeUnlike"), object: nil)
                self.table.delegate = self
                self.table.dataSource = self
                self.table.reloadData()
                self.response2.removeAllObjects()
                self.homeDataAPI()
                self.removeAllOverlays()
                
            }
            else{
                //                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongLikeUnlike"), object: nil)
                self.table.delegate = self
                self.table.dataSource = self
                self.table.reloadData()
                self.response2.removeAllObjects()
                self.homeDataAPI()
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        bannerView.adUnitID = "ca-app-pub-2310499434542995/8296633128"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        interstitial?.delegate = self
        interstitial = createAndLoadInterstitial()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        defaults = UserDefaults.standard
        Arsts = defaults.value(forKey: "ArSts") as? String
        user_id = defaults.integer(forKey: "UserIDGet")
        range = defaults.integer(forKey: "Default_range")
        if range == 0 {
            range = 1000
        }else {
            range = defaults.integer(forKey: "Default_range")
        }
        str_lat = defaults.string(forKey: "LAT")
        str_long = defaults.string(forKey: "LONG")
        
        //        if Arsts == "Artist" {
        //            self.becomeArtistImage.isHidden = true
        //            self.artistBtnHeightconstarints.constant = 0
        //        }else {
        //            self.becomeArtistImage.isHidden = false
        //            self.artistBtnHeightconstarints.constant = 150
        //        }
        
        
        self.view.insetsLayoutMarginsFromSafeArea = true
        containerView.isHidden = true
        contanerviewHeightCons.constant = 0
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        
        let LiberaryLayOut = UICollectionViewFlowLayout()
        LiberaryLayOut.itemSize = CGSize(width:screenWidth/3, height: 180)
        LiberaryLayOut.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
        LiberaryLayOut.minimumInteritemSpacing = 0
        LiberaryLayOut.minimumLineSpacing = 20
        LiberaryLayOut.scrollDirection = .horizontal
        
        hotmusicCollectionView.collectionViewLayout = LiberaryLayOut
        
        let FeaturedLiberaryLayOut = UICollectionViewFlowLayout()
        FeaturedLiberaryLayOut.itemSize = CGSize(width:screenWidth/3, height: 180)
        FeaturedLiberaryLayOut.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
        FeaturedLiberaryLayOut.minimumInteritemSpacing = 0
        FeaturedLiberaryLayOut.minimumLineSpacing = 20
        FeaturedLiberaryLayOut.scrollDirection = .horizontal
        
        FeaturedSongCollection.collectionViewLayout = FeaturedLiberaryLayOut
        
        
        let UpcommingLiberaryLayOut = UICollectionViewFlowLayout()
        UpcommingLiberaryLayOut.itemSize = CGSize(width:screenWidth/1.8, height: 180)
        UpcommingLiberaryLayOut.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
        UpcommingLiberaryLayOut.minimumInteritemSpacing = 0
        UpcommingLiberaryLayOut.minimumLineSpacing = 14
        UpcommingLiberaryLayOut.scrollDirection = .horizontal
        
        UpcomingEventCollectionView.collectionViewLayout = UpcommingLiberaryLayOut
        
        let FeatureArtistLiberaryLayOut = UICollectionViewFlowLayout()
        FeatureArtistLiberaryLayOut.itemSize = CGSize(width:screenWidth/3, height: 180)
        FeatureArtistLiberaryLayOut.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
        FeatureArtistLiberaryLayOut.minimumInteritemSpacing = 0
        FeatureArtistLiberaryLayOut.minimumLineSpacing = 20
        FeatureArtistLiberaryLayOut.scrollDirection = .horizontal
        
        featuredArtistCollectionView.collectionViewLayout = FeatureArtistLiberaryLayOut
        
        let MoodArtistLiberaryLayOut = UICollectionViewFlowLayout()
        MoodArtistLiberaryLayOut.itemSize = CGSize(width:screenWidth/3, height: 150)
        MoodArtistLiberaryLayOut.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
        MoodArtistLiberaryLayOut.minimumInteritemSpacing = 0
        MoodArtistLiberaryLayOut.minimumLineSpacing = 20
        MoodArtistLiberaryLayOut.scrollDirection = .horizontal
        
        MoodCollectionView.collectionViewLayout = MoodArtistLiberaryLayOut
        
        let RecentlyPlayedArtistLiberaryLayOut = UICollectionViewFlowLayout()
        RecentlyPlayedArtistLiberaryLayOut.itemSize = CGSize(width:screenWidth/3, height: 180)
        RecentlyPlayedArtistLiberaryLayOut.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
        RecentlyPlayedArtistLiberaryLayOut.minimumInteritemSpacing = 0
        RecentlyPlayedArtistLiberaryLayOut.minimumLineSpacing = 20
        RecentlyPlayedArtistLiberaryLayOut.scrollDirection = .horizontal
        
        RecentlyPlayedCollectionView.collectionViewLayout = RecentlyPlayedArtistLiberaryLayOut
        
        Config().AppUserDefaults.removeObject(forKey: "SearchSongPlayer")
        
        self.homeDataAPI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let SearchSongPlayer = DataManager.getVal(Config().AppUserDefaults.object(forKey: "SearchSongPlayer")) as? String ?? ""
        if SearchSongPlayer == "isPlaying"{
            var windowz = UIApplication.shared.windows
            windowz.removeLast()
            self.myCustomView?.window?.removeFromSuperview()
            self.myCustomView?.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
            self.myCustomView?.MiniView.isHidden = false
            self.myCustomView?.MiniViewHeightConstraint.constant = 60
            self.myCustomView?.BottomView.isHidden = true

        }else{
            
        }

//        self.isComingFrom = type
//        if self.isComingFrom == "isPlaying" {
//            // do stuff
//            if UIDevice().userInterfaceIdiom == .phone {
//                switch UIScreen.main.nativeBounds.height {
//                case 1136:
//                    print("iPhone 5 or 5S or 5C")
//                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
//                    self.myCustomView?.MiniView.isHidden = false
//                    self.myCustomView?.MiniViewHeightConstraint.constant = 60
//                    self.myCustomView?.BottomView.isHidden = true
//                case 1334:
//                    print("iPhone 6/6S/7/8")
//                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
//                    self.myCustomView?.MiniView.isHidden = false
//                    self.myCustomView?.MiniViewHeightConstraint.constant = 60
//                    self.myCustomView?.BottomView.isHidden = true
//                case 1920, 2208:
//                    print("iPhone 6+/6S+/7+/8+")
//                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
//                    self.myCustomView?.MiniView.isHidden = false
//                    self.myCustomView?.MiniViewHeightConstraint.constant = 60
//                    self.myCustomView?.BottomView.isHidden = true
//                case 2436:
//                    print("iPhone X/XS/11 Pro")
//                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
//                    self.myCustomView?.MiniView.isHidden = false
//                    self.myCustomView?.MiniViewHeightConstraint.constant = 60
//                    self.myCustomView?.BottomView.isHidden = true
//                case 2688:
//                    print("iPhone XS Max/11 Pro Max")
//                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
//                    self.myCustomView?.MiniView.isHidden = false
//                    self.myCustomView?.MiniViewHeightConstraint.constant = 60
//                    self.myCustomView?.BottomView.isHidden = true
//                case 1792:
//                    print("iPhone XR/ 11 ")
//                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
//                    self.myCustomView?.MiniView.isHidden = false
//                    self.myCustomView?.MiniViewHeightConstraint.constant = 60
//                    self.myCustomView?.BottomView.isHidden = true
//                default:
//                    print("Unknown")
//                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-60, width: self.screenWidth, height: 60)
//                    self.myCustomView?.MiniView.isHidden = false
//                    self.myCustomView?.MiniViewHeightConstraint.constant = 60
//                    self.myCustomView?.BottomView.isHidden = true
//                }
//            }
//        }else{
//            //
//        }
        
    }
    
    func homeDataAPI(){
        if !self.isCall {
            if Reachability.isConnectedToNetwork(){
                self.showWaitOverlay()
                Parsing().DiscoverDashboard(UserId: self.user_id, Lat: self.str_lat as String?, Long: self.str_long as String?, Range: self.range)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverDashboard"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverHomeListAction), name: NSNotification.Name(rawValue: "DiscoverDashboard"), object: nil)
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
    }
    
    // MARK: - Google Ads
    /// Tells the delegate an ad request loaded an ad.
    private func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        self.bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.bannerView.alpha = 1
        })
        
    }
    
    // MARK: - GADBannerViewDelegate methods
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView!) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            bannerView.transform = CGAffineTransform.identity
        }
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
        
    }
    
    // MARK: - Help methods
    
    private func createAndLoadInterstitial() -> GADInterstitial? {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2310499434542995/8296633128")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    // MARK: - GADInterstitialDelegate methods
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hotmusicCollectionView {
            return response.count
        } else if collectionView == FeaturedSongCollection {
            return response5.count
        }else if collectionView == UpcomingEventCollectionView {
            return response1.count
        }else if collectionView == featuredArtistCollectionView {
            return response6.count
        }else if collectionView == MoodCollectionView {
            return response4.count
        }else{
            return response3.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == hotmusicCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HotMusicCell
            cell.imgHot.layer.cornerRadius = 8
            var dict = NSDictionary()
            dict = response.object(at: indexPath.row) as! NSDictionary
            var featuredSong:Int!
            featuredSong = dict.value(forKey: "featured_song") as? Int
            if featuredSong == 0 {
                cell.featuredSong_img.isHidden = true
            }else{
                cell.featuredSong_img.isHidden = false
            }
            cell.imgHot.sd_setImage(with: URL(string: (dict.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.songLbl.text = dict.value(forKey: "song_name") as? String
            cell.songDes.text = dict.value(forKey: "as_type_name") as? String
            return cell
            
        } else if collectionView == FeaturedSongCollection {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FeaturedSongCell
            cell.imgFeatured.layer.cornerRadius = 8
            //            cell.imgFeatured.dropShadow(color: UIColor.black, offSet: CGSize(width: -1, height: 1))
            var dict = NSDictionary()
            dict = response5.object(at: indexPath.row) as! NSDictionary
            cell.imgFeatured.sd_setImage(with: URL(string: (dict.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.songLbl.text = dict.value(forKey: "song_name") as? String
            cell.songDes.text = dict.value(forKey: "as_type_name") as? String
            return cell
            
        } else if collectionView == UpcomingEventCollectionView {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UpcomingEventCell
            cell.imgUpcomming.layer.cornerRadius = 8
            var dict = NSDictionary()
            dict = response1.object(at: indexPath.row) as! NSDictionary
            cell.imgUpcomming.sd_setImage(with: URL(string: (dict.value(forKey: "event_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.evenyNameLbl.text = dict.value(forKey: "event_title") as? String
            var date = String()
            date = dict.value(forKey: "event_date") as! String
            var Time = String()
            Time = dict.value(forKey: "event_time") as! String
            
            cell.dateTimeLbl.text = date + " " + Time
            var price = NSNumber()
            price = dict.value(forKey: "price_per_sit") as! NSNumber
            cell.priceLbl.text = "$" + price.stringValue
            return cell
            
        }else if collectionView == featuredArtistCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FeaturedArtistCell
            cell.artistImageview.layer.cornerRadius = 8
            var dict = NSDictionary()
            dict = response6.object(at: indexPath.row) as! NSDictionary
            cell.artistImageview.sd_setImage(with: URL(string: (dict.value(forKey: "artist_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.artistImageview.layer.borderWidth = 1.0
            cell.artistImageview.layer.masksToBounds = false
            cell.artistImageview.layer.borderColor = UIColor.white.cgColor
            cell.artistImageview.layer.cornerRadius = CGFloat(signOf: cell.artistImageview.frame.size.width / 2, magnitudeOf: cell.artistImageview.frame.size.height / 2)
            cell.artistImageview.clipsToBounds = true
            cell.ArtistNameLbl.text = dict.value(forKey: "artist_name") as? String
            return cell
            
        }else if collectionView == MoodCollectionView {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoodsCell
            cell.imgMoods.layer.cornerRadius = 8
            var dict = NSDictionary()
            dict = response4.object(at: indexPath.row) as! NSDictionary
            cell.imgMoods.sd_setImage(with: URL(string: (dict.value(forKey: "image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.nameLbl.text = dict.value(forKey: "genre_name") as? String
            return cell
            
        }else {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecentlyPlayedCell
            cell.imgRecentlyPlayed.layer.cornerRadius = 8
            var dict = NSDictionary()
            dict = response3.object(at: indexPath.row) as! NSDictionary
            var featuredSong:Int!
            featuredSong = dict.value(forKey: "featured_song") as? Int
            if featuredSong == 0 {
                cell.featuredSong_img.isHidden = true
            }else{
                cell.featuredSong_img.isHidden = false
            }
            cell.imgRecentlyPlayed.sd_setImage(with: URL(string: (dict.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.songNameLbl.text = dict.value(forKey: "song_name") as? String
            cell.songDesLbl.text = dict.value(forKey: "as_type_name") as? String
            return cell
        }
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == hotmusicCollectionView {
            self.collectionTypeStr = "1"
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
            
            
//            self.myCustomView?.removeFromSuperview()
//            self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
//            self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-144, width: self.screenWidth, height: 60)
//            self.myCustomView?.BottomView.isHidden = true
            
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    self.myCustomView?.window?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 1334:
                    print("iPhone 6/6S/7/8")
                    self.myCustomView?.window?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 1920, 2208:
                    print("iPhone 6+/6S+/7+/8+")
                    self.myCustomView?.window?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 2436:
                    print("iPhone X/XS/11 Pro")
                    self.myCustomView?.window?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 2688:
                    print("iPhone XS Max/11 Pro Max")
                    self.myCustomView?.window?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 1792:
                    print("iPhone XR/ 11 ")
                    self.myCustomView?.window?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                default:
                    print("Unknown")
                    self.myCustomView?.window?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-60, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                }
            }
            
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
            
            
        }else if collectionView == FeaturedSongCollection {
            self.collectionTypeStr = "2"
            let dict = DataManager.getVal(self.response5[indexPath.row]) as! NSDictionary
            print(dict)
            self.dataArray = self.response5 as! [Any]
            let defaults = UserDefaults.standard
            defaults.set(self.dataArray, forKey: "DataAr")
            defaults.synchronize()
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
            
            
//            self.myCustomView?.removeFromSuperview()
//            self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
//            self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-144, width: self.screenWidth, height: 60)
//            self.myCustomView?.BottomView.isHidden = true
            
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 1334:
                    print("iPhone 6/6S/7/8")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 1920, 2208:
                    print("iPhone 6+/6S+/7+/8+")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 2436:
                    print("iPhone X/XS/11 Pro")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 2688:
                    print("iPhone XS Max/11 Pro Max")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 1792:
                    print("iPhone XR/ 11 ")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                default:
                    print("Unknown")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-60, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                }
            }
            
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
            
            if audioPlayer.isPlaying{
                audioPlayer.stop()
            }
            
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
            
        } else if collectionView == UpcomingEventCollectionView {
            var dict = NSDictionary()
            dict = response1.object(at: indexPath.row) as! NSDictionary
            var eventid:Int!
            var evntuserid:Int!
            eventid = dict.value(forKey: "id") as? Int
            evntuserid = dict.value(forKey: "user_id") as? Int
            let defaults = UserDefaults.standard
            defaults.set(eventid, forKey: "EventID")
            defaults.set(evntuserid, forKey: "EventUserID")
            defaults.synchronize()
            let vc = storyboard?.instantiateViewController(withIdentifier: "EventAllDetailsViewController") as! EventAllDetailsViewController
            navigationController?.pushViewController(vc, animated: true)
            
        }else if collectionView == featuredArtistCollectionView {
            var dict = NSDictionary()
            dict = response6.object(at: indexPath.row) as! NSDictionary
            ArtistId = dict.value(forKey: "id") as? Int
            ArtistUserId = dict.value(forKey: "user_id") as? Int
            artistName = dict.value(forKey: "artist_name") as? String
            let defaults = UserDefaults.standard
            defaults.set(ArtistId, forKey: "ArtistID")
            defaults.set(ArtistUserId, forKey: "ArUserId")
            defaults.set(artistName, forKey: "ArName")
            defaults.synchronize()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArtistDetailViewController") as! ArtistDetailViewController
            navigationController?.pushViewController(vc, animated: true)
            
        }else if collectionView == MoodCollectionView {
            var dict = NSDictionary()
            dict = response4.object(at: indexPath.row) as! NSDictionary
            MoodsId = dict.value(forKey: "id") as? Int
            listName = dict.value(forKey: "genre_name") as? String
            let defaults = UserDefaults.standard
            defaults.set(MoodsId, forKey: "MoodsID")
            defaults.set(listName, forKey: "MoodsName")
            defaults.synchronize()
            let vc = storyboard?.instantiateViewController(withIdentifier: "MoodsSongViewController") as! MoodsSongViewController
            navigationController?.pushViewController(vc, animated: true)
            
        }else {
            self.collectionTypeStr = "3"
            let dict = DataManager.getVal(self.response3[indexPath.row]) as! NSDictionary
            print(dict)
            self.dataArray = self.response3 as! [Any]
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
            let vc =  song_file.replacingOccurrences(of: " ", with: "")
            let AddPicture_url = URL.init(string: vc)
            print(AddPicture_url!)
            self.currentAudioPath = AddPicture_url
            
//            self.myCustomView?.removeFromSuperview()
//            self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
//            self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-144, width: self.screenWidth, height: 60)
//            self.myCustomView?.BottomView.isHidden = true
            
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 1334:
                    print("iPhone 6/6S/7/8")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 1920, 2208:
                    print("iPhone 6+/6S+/7+/8+")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 2436:
                    print("iPhone X/XS/11 Pro")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 2688:
                    print("iPhone XS Max/11 Pro Max")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 1792:
                    print("iPhone XR/ 11 ")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                default:
                    print("Unknown")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-60, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                }
            }
            
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
            
            if audioPlayer.isPlaying{
                audioPlayer.stop()
            }
            
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
        parameterDictionary.setObject(DataManager.getVal(self.user_id), forKey: "user_id" as NSCopying)
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
        parameterDictionary.setObject(DataManager.getVal(self.user_id), forKey: "user_id" as NSCopying)
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
        parameterDictionary.setObject(DataManager.getVal(self.user_id), forKey: "user_id" as NSCopying)
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
    
    func SongListAPi(songType:String){
        showWaitOverlay()
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.user_id), forKey: "user_id" as NSCopying)
        parameterDictionary.setValue(DataManager.getVal("all"), forKey: "as_type")
        parameterDictionary.setValue(DataManager.getVal(songType), forKey: "list_type")
        parameterDictionary.setValue(DataManager.getVal(str_lat), forKey: "lat")
        parameterDictionary.setValue(DataManager.getVal(str_long), forKey: "lng")
        parameterDictionary.setValue(DataManager.getVal(0), forKey: "offset")
        print(parameterDictionary)
        
        let methodName = "song_list"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status")) as? String ?? ""
                let message = DataManager.getVal(responseData?.object(forKey: "message")) as? String ?? ""
                if status == "1" {
                    //                    var arr_data = NSMutableArray()
                    //                    arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                    //                    if arr_data.count != 0 {
                    //                        self.songListArray.append(arr_data as NSMutableArray)
                    //                        //                  self.slooooooooooot = self.slooooooooooot + 10
                    //                        arr_data.removeAllObjects()
                    //                    }
                    self.songListArray = DataManager.getVal(responseData?.object(forKey: "data")) as? [Any] ?? []
                    
                    self.myCustomView?.NewSongTblView.reloadData()
                    self.removeAllOverlays()
                }else{
                    self.myCustomView?.NewSongTblView.reloadData()
                    self.removeAllOverlays()
                }
                self.removeAllOverlays()
            })
        }
    }
    
    
    // MARK: - Custtom view Action
    @objc func PlayButtonAction(_ sender: UIButton){
        print("Play Button")
        var dict = NSDictionary()
        if self.collectionTypeStr == "1"{//hot music
            dict = DataManager.getVal(self.response[sender.tag]) as! NSDictionary
        }else if self.collectionTypeStr == "2"{//feature song
            dict = DataManager.getVal(self.response5[sender.tag]) as! NSDictionary
        }else if self.collectionTypeStr == "3"{
            dict = DataManager.getVal(self.response3[sender.tag]) as! NSDictionary
        }else{
            dict = DataManager.getVal(self.response2[sender.tag]) as! NSDictionary
        }
        
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
    
    @objc func BigButtonAction(_ sender: UIButton){
        print("Big Button")
//        self.myCustomView!.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: screenHeight)
//        self.myCustomView?.MiniView.isHidden = true
//        self.myCustomView?.MiniViewHeightConstraint.constant = 0
//        self.myCustomView?.BottomView.isHidden = false
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                self.myCustomView!.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: screenHeight)
                self.myCustomView?.MiniView.isHidden = true
                self.myCustomView?.MiniViewHeightConstraint.constant = 0
                self.myCustomView?.BottomView.isHidden = false
            case 1334:
                print("iPhone 6/6S/7/8")
                self.myCustomView!.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: screenHeight)
                self.myCustomView?.MiniView.isHidden = true
                self.myCustomView?.MiniViewHeightConstraint.constant = 0
                self.myCustomView?.BottomView.isHidden = false
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                self.myCustomView!.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: screenHeight)
                self.myCustomView?.MiniView.isHidden = true
                self.myCustomView?.MiniViewHeightConstraint.constant = 0
                self.myCustomView?.BottomView.isHidden = false
            case 2436:
                print("iPhone X/XS/11 Pro")
                self.myCustomView!.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: screenHeight)
                self.myCustomView?.MiniView.isHidden = true
                self.myCustomView?.MiniViewHeightConstraint.constant = 0
                self.myCustomView?.BottomView.isHidden = false
            case 2688:
                print("iPhone XS Max/11 Pro Max")
                self.myCustomView!.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: screenHeight)
                self.myCustomView?.MiniView.isHidden = true
                self.myCustomView?.MiniViewHeightConstraint.constant = 0
                self.myCustomView?.BottomView.isHidden = false
            case 1792:
                print("iPhone XR/ 11 ")
                self.myCustomView!.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: screenHeight)
                self.myCustomView?.MiniView.isHidden = true
                self.myCustomView?.MiniViewHeightConstraint.constant = 0
                self.myCustomView?.BottomView.isHidden = false
            default:
                print("Unknown")
                self.myCustomView!.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: screenHeight)
                self.myCustomView?.MiniView.isHidden = true
                self.myCustomView?.MiniViewHeightConstraint.constant = 0
                self.myCustomView?.BottomView.isHidden = false
            }
        }
        
        if self.audioPlayer.isPlaying{
            let pause = UIImage(named: "pause")
            self.myCustomView?.PauseAndPlayButton.setImage(pause, for: .normal)
        }else{
            let pause = UIImage(named: "play-1")
            self.myCustomView?.PauseAndPlayButton.setImage(pause, for: .normal)
        }
    }
    
    @objc func CrossButtonAction(_ sender: UIButton){
        print("Cross Button")
//        self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-144, width: self.screenWidth, height: 60)
//        self.myCustomView?.MiniView.isHidden = false
//        self.myCustomView?.MiniViewHeightConstraint.constant = 60
//        self.myCustomView?.BottomView.isHidden = true
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
                self.myCustomView?.MiniView.isHidden = false
                self.myCustomView?.MiniViewHeightConstraint.constant = 60
                self.myCustomView?.BottomView.isHidden = true
            case 1334:
                print("iPhone 6/6S/7/8")
                self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
                self.myCustomView?.MiniView.isHidden = false
                self.myCustomView?.MiniViewHeightConstraint.constant = 60
                self.myCustomView?.BottomView.isHidden = true
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
                self.myCustomView?.MiniView.isHidden = false
                self.myCustomView?.MiniViewHeightConstraint.constant = 60
                self.myCustomView?.BottomView.isHidden = true
            case 2436:
                print("iPhone X/XS/11 Pro")
                self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
                self.myCustomView?.MiniView.isHidden = false
                self.myCustomView?.MiniViewHeightConstraint.constant = 60
                self.myCustomView?.BottomView.isHidden = true
            case 2688:
                print("iPhone XS Max/11 Pro Max")
                self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
                self.myCustomView?.MiniView.isHidden = false
                self.myCustomView?.MiniViewHeightConstraint.constant = 60
                self.myCustomView?.BottomView.isHidden = true
            case 1792:
                print("iPhone XR/ 11 ")
                self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
                self.myCustomView?.MiniView.isHidden = false
                self.myCustomView?.MiniViewHeightConstraint.constant = 60
                self.myCustomView?.BottomView.isHidden = true
            default:
                print("Unknown")
                self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-60, width: self.screenWidth, height: 60)
                self.myCustomView?.MiniView.isHidden = false
                self.myCustomView?.MiniViewHeightConstraint.constant = 60
                self.myCustomView?.BottomView.isHidden = true
            }
        }
        
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
    // MARK: - MiniPlayerSongAction
    func downloadFileFromURL3(url:NSURL){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            self?.prepareAudio(url: URL!)
        })
        
        downloadTask.resume()
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
        if tableView == RecentlyAddedTablview {
            return response2.count
        }else if tableView == self.table{
            return 3
        }else{
            return 0
        }
        
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
        
        if audioPlayer.isPlaying{
            audioPlayer.stop()
        }
        
        self.downloadFileFromURL3(url: self.currentAudioPath as NSURL)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == RecentlyAddedTablview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecentlyAddedCell
            var dict = NSDictionary()
            dict = response2.object(at: indexPath.row) as! NSDictionary
            cell.SongNameLbl.text = dict.value(forKey: "song_name") as? String
            cell.songDesLbl.text = dict.value(forKey: "as_type_name") as? String
            cell.songTimeLbl.text = dict.value(forKey: "duration") as? String
            cell.songImage.layer.cornerRadius = 5
            cell.songImage.sd_setImage(with: URL(string: (dict.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
            cell.reportBtn.tag = indexPath.row
            cell.reportBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
            return cell
        }else{
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.backgroundColor = UIColor.darkGray
            cell.textLabel?.text = self.texts[(indexPath as NSIndexPath).row]
            cell.textLabel?.textColor = UIColor.white
            
            return cell
        }
    }
    
    //MARK:- Tableview Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == RecentlyAddedTablview {
            let dict = DataManager.getVal(self.response2[indexPath.row]) as! NSDictionary
            print(dict)
            self.dataArray = self.response2 as! [Any]
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
            
            
//            self.myCustomView?.removeFromSuperview()
//            self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
//            self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-144, width: self.screenWidth, height: 60)
//            self.myCustomView?.BottomView.isHidden = true
            
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 1334:
                    print("iPhone 6/6S/7/8")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 1920, 2208:
                    print("iPhone 6+/6S+/7+/8+")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-108, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 2436:
                    print("iPhone X/XS/11 Pro")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 2688:
                    print("iPhone XS Max/11 Pro Max")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                case 1792:
                    print("iPhone XR/ 11 ")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-142, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                default:
                    print("Unknown")
                    self.myCustomView?.removeFromSuperview()
                    self.myCustomView = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView)
                    self.myCustomView!.frame = CGRect(x: 0, y: self.screenHeight-60, width: self.screenWidth, height: 60)
                    self.myCustomView?.BottomView.isHidden = true
                }
            }
            
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
            
            if audioPlayer.isPlaying{
                audioPlayer.stop()
            }
            
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
        }else {
            
            if indexPath.row == 0 {
                print("Ashish")
                var dict = NSDictionary()
                dict = response2.object(at: myindexpath.row) as! NSDictionary
                var ArId:Int!
                ArId = dict.value(forKey: "as_type_id") as? Int
                
                var AruserId:Int!
                AruserId = dict.value(forKey: "user_id") as? Int
                
                
                var arName:String!
                arName = dict.value(forKey: "as_type_name") as? String
                
                let defaults = UserDefaults.standard
                defaults.set(ArId, forKey: "ArtistID")
                defaults.set(AruserId, forKey: "ArUserId")
                defaults.set(arName, forKey: "ArName")
                defaults.synchronize()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArtistDetailViewController") as! ArtistDetailViewController
                navigationController?.pushViewController(vc, animated: true)
                self.popover.dismiss()
            }else if indexPath.row == 1 {
                print("Ashish1")
                var dict = NSDictionary()
                dict = response2.object(at: myindexpath.row) as! NSDictionary
                var songId:Int!
                songId = dict.value(forKey: "id") as? Int
                showWaitOverlay()
                Parsing().DiscoverSongLikeUnlike(UserId: user_id, SongId: songId, Status: 1)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSongLikeUnlike"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongLikeAction), name: NSNotification.Name(rawValue: "DiscoverSongLikeUnlike"), object: nil)
                self.popover.dismiss()
            }else {
                var dict = NSDictionary()
                dict = response2.object(at: myindexpath.row) as! NSDictionary
                var songfile:String!
                songfile = dict.value(forKey: "song_file") as? String
                // set up activity view controller
                let textToShare = [ songfile ]
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
    
    
    @objc func handleTap(_ sender:UIButton) {
        if IS_IPHONE_5S {
            let buttonPosition = sender.convert(CGPoint.zero, to: RecentlyAddedTablview)
            myindexpath = RecentlyAddedTablview.indexPathForRow(at: buttonPosition)! as NSIndexPath
            let cell = RecentlyAddedTablview.dequeueReusableCell(withIdentifier: "cell", for: myindexpath as IndexPath) as! RecentlyAddedCell
            cell.reportBtn.tag = myindexpath.row
            var dict = NSDictionary()
            dict = response2.object(at: myindexpath.row) as! NSDictionary
            self.like_unsts = dict.value(forKey: "like_unlike_status") as? Int
            if self.like_unsts == 2 || self.like_unsts == 0{
                self.texts = ["Go to Artist", "Like", "Share"]
                self.StatusLike_Unlike = 1
                self.table.reloadData()
            }else {
                self.texts = ["Go to Artist", "Dislike", "Share"]
                self.StatusLike_Unlike = 2
                self.table.reloadData()
            }
            table = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 130))
            table.delegate = self
            table.dataSource = self
            table.separatorStyle = .none
            table.isScrollEnabled = false
            //        let startPoint = CGPoint(x: self.view.frame.width - 78, y: 340)
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 130))
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
            self.popover.show(aView, fromView: sender)
        }else if IS_IPHONE_7 {
            let buttonPosition = sender.convert(CGPoint.zero, to: RecentlyAddedTablview)
            myindexpath = RecentlyAddedTablview.indexPathForRow(at: buttonPosition)! as NSIndexPath
            let cell = RecentlyAddedTablview.dequeueReusableCell(withIdentifier: "cell", for: myindexpath as IndexPath) as! RecentlyAddedCell
            cell.reportBtn.tag = myindexpath.row
            var dict = NSDictionary()
            dict = response2.object(at: myindexpath.row) as! NSDictionary
            self.like_unsts = dict.value(forKey: "like_unlike_status") as? Int
            if self.like_unsts == 2 || self.like_unsts == 0{
                self.texts = ["Go to Artist", "Like", "Share"]
                self.StatusLike_Unlike = 1
                self.table.reloadData()
            }else {
                self.texts = ["Go to Artist", "Dislike", "Share"]
                self.StatusLike_Unlike = 2
                self.table.reloadData()
            }
            table = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 130))
            table.delegate = self
            table.dataSource = self
            table.separatorStyle = .none
            table.isScrollEnabled = false
            //            let startPoint = CGPoint(x: self.view.frame.width - 78, y: 340)
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-260, height: 130))
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
            self.popover.show(aView, fromView: sender)
        }else if IS_IPHONE_X {
            let buttonPosition = sender.convert(CGPoint.zero, to: RecentlyAddedTablview)
            myindexpath = RecentlyAddedTablview.indexPathForRow(at: buttonPosition)! as NSIndexPath
            let cell = RecentlyAddedTablview.dequeueReusableCell(withIdentifier: "cell", for: myindexpath as IndexPath) as! RecentlyAddedCell
            cell.reportBtn.tag = myindexpath.row
            var dict = NSDictionary()
            dict = response2.object(at: myindexpath.row) as! NSDictionary
            self.like_unsts = dict.value(forKey: "like_unlike_status") as? Int
            if self.like_unsts == 2 || self.like_unsts == 0{
                self.texts = ["Go to Artist", "Like", "Share"]
                self.StatusLike_Unlike = 1
                self.table.reloadData()
            }else {
                self.texts = ["Go to Artist", "Dislike", "Share"]
                self.StatusLike_Unlike = 2
                self.table.reloadData()
            }
            table = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 130))
            table.delegate = self
            table.dataSource = self
            table.separatorStyle = .none
            table.isScrollEnabled = false
            //            let startPoint = CGPoint(x: self.view.frame.width - 68, y: 400)
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-260, height: 130))
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
            self.popover.show(aView, fromView: sender)
        }else if IS_IPHONE_XR {
            let buttonPosition = sender.convert(CGPoint.zero, to: RecentlyAddedTablview)
            myindexpath = RecentlyAddedTablview.indexPathForRow(at: buttonPosition)! as NSIndexPath
            let cell = RecentlyAddedTablview.dequeueReusableCell(withIdentifier: "cell", for: myindexpath as IndexPath) as! RecentlyAddedCell
            cell.reportBtn.tag = myindexpath.row
            var dict = NSDictionary()
            dict = response2.object(at: myindexpath.row) as! NSDictionary
            self.like_unsts = dict.value(forKey: "like_unlike_status") as? Int
            if self.like_unsts == 2 || self.like_unsts == 0{
                self.texts = ["Go to Artist", "Like", "Share"]
                self.StatusLike_Unlike = 1
                self.table.reloadData()
            }else {
                self.texts = ["Go to Artist", "Dislike", "Share"]
                self.StatusLike_Unlike = 2
                self.table.reloadData()
            }
            table = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 130))
            table.delegate = self
            table.dataSource = self
            table.separatorStyle = .none
            table.isScrollEnabled = false
            //            let startPoint = CGPoint(x: self.view.frame.width - 78, y: 400)
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-300, height: 130))
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
            self.popover.show(aView, fromView: sender)
        }else{
            let buttonPosition = sender.convert(CGPoint.zero, to: RecentlyAddedTablview)
            myindexpath = RecentlyAddedTablview.indexPathForRow(at: buttonPosition)! as NSIndexPath
            let cell = RecentlyAddedTablview.dequeueReusableCell(withIdentifier: "cell", for: myindexpath as IndexPath) as! RecentlyAddedCell
            cell.reportBtn.tag = myindexpath.row
            var dict = NSDictionary()
            dict = response2.object(at: myindexpath.row) as! NSDictionary
            self.like_unsts = dict.value(forKey: "like_unlike_status") as? Int
            if self.like_unsts == 2 || self.like_unsts == 0{
                self.texts = ["Go to Artist", "Like", "Share"]
                self.StatusLike_Unlike = 1
                self.table.reloadData()
            }else {
                self.texts = ["Go to Artist", "Dislike", "Share"]
                self.StatusLike_Unlike = 2
                self.table.reloadData()
            }
            table = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 130))
            table.delegate = self
            table.dataSource = self
            table.separatorStyle = .none
            table.isScrollEnabled = false
            //            let startPoint = CGPoint(x: self.view.frame.width - 78, y: 400)
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-300, height: 130))
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
            self.popover.show(aView, fromView: sender)
        }
    }
    
    @IBAction func hotmusicviewAllBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HotMusicViewController") as! HotMusicViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func FeaturedSongViewAllBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FeturedSongViewController") as! FeturedSongViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func UpcomingEventViewAllBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UpcomingEventsViewController") as! UpcomingEventsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func FeturedArtistViewAllBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FeturedArtistsViewController") as! FeturedArtistsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func RecentlyAddedViewAllBtnaction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RecentlyAddedViewController") as! RecentlyAddedViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func MoodsViewAllBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MoodsViewController") as! MoodsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func RecentelyPlayedViewAllBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RecentlyPlayedViewController") as! RecentlyPlayedViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func becomeArtistBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BecomeAnArtist1ViewController") as! BecomeAnArtist1ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK:- FSPagerViewDataSource
    
    
    
}
extension UIView {
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
// MARK: - MiniPlayerDelegate
//@available(iOS 11.0, *)
//extension SongViewController: MiniPlayerDelegate1 {
//
//    func expandSong1(song:Int) {
//        guard let maxiCard = storyboard?.instantiateViewController(withIdentifier: "MaxiSongCardViewController") as? MaxiSongCardViewController else {
//            assertionFailure("No view controller ID MaxiSongCardViewController in storyboard")
//            return
//        }
//
//        maxiCard.backingImage = view.makeSnapshot()
//       // maxiCard.currentSong = song
//      //  maxiCard.currentSong?.Id = 24
//        maxiCard.sourceView = miniPlayer
//        if let tabBar = tabBarController?.tabBar {
//            maxiCard.tabBarImage = tabBar.makeSnapshot()
//        }
//        present(maxiCard, animated: false)
//    }
//}


