//
//  EventUserDetailViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class EventUserDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,FloatRatingViewDelegate {
   
    

   
    
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var easyBtn: UIButton!
    @IBOutlet weak var rapBtn: UIButton!
    @IBOutlet weak var popBtn: UIButton!
    
    @IBOutlet weak var genreCollection: UICollectionView!
    @IBOutlet weak var profileImagvView: UIImageView!
    @IBOutlet weak var ArtistName: UILabel!
    @IBOutlet weak var ArtistGmail: UILabel!
    @IBOutlet weak var RatingView: FloatRatingView!
    @IBOutlet weak var Viewer: UILabel!
    @IBOutlet weak var AddressLbl: UILabel!
    @IBOutlet weak var communityImageView: UIImageView!
    
    @IBOutlet weak var postTitleLbl: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var likecountlbl: UILabel!
    @IBOutlet weak var commentCountLbl: UILabel!
    
    @IBOutlet weak var ratingperLbl: UILabel!
    
    @IBOutlet weak var viewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var communityView: UIView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var postNameLbl: UILabel!
    var defaults:UserDefaults!
    var userId:Int!
    var BandId:Int!
    var bandUserID:Int!
    var genreArray:NSMutableArray!
    var communityArray:NSMutableArray!
    var likeid:Int!
    var like_sts:Int!
    var artistUserId:Int!
    var Data1:Int!
    var ArtistFollowSts:Int!
    var postId:Int!
    
    @IBOutlet weak var updateLbl: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    
    
    //MARK:- Artist Detail WebService
    @objc func DiscoverArtistDetailAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                let test =  SwiftToast(
                    text: str_message,
                    textAlignment: .center,
                    image: UIImage(named: "ic_alert"),
                    backgroundColor: .purple,
                    textColor: .white,
                    font: .boldSystemFont(ofSize: 15.0),
                    duration: 2.0,
                    minimumHeight: CGFloat(100.0),
                    statusBarStyle: .lightContent,
                    aboveStatusBar: true,
                    target: nil,
                    style: .navigationBar)
                self.present(test, animated: true)
                self.removeAllOverlays()
            }
            else{
                
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(response)")
                
                self.ArtistName.text = response.value(forKey: "band_name") as? String
                self.ArtistGmail.text = response.value(forKey: "band_email") as? String
                var str_city = String()
                str_city = (response.value(forKey: "city") as? String)!
                self.ArtistFollowSts = response.value(forKey: "followStatus") as? Int
                if self.ArtistFollowSts == 1 {
                    self.followBtn.setImage(UIImage(named: "Un_Follow_button"), for: .normal)
                }else {
                    self.followBtn.setImage(UIImage(named: "Follow"), for: .normal)
                }
                var str_state = String()
                str_state = (response.value(forKey: "state") as? String)!
                self.AddressLbl.text = str_city + "," + str_state
                self.descriptionLbl.text = response.value(forKey: "description") as? String
                var str_rating = NSNumber()
                str_rating  = response.value(forKey: "rating") as! NSNumber
                self.RatingView.rating = Float(truncating: str_rating)
                var str_view = Int()
                str_view = response.value(forKey: "viewer") as! Int
                var viewer = String()
                viewer = String(str_view)
                self.Viewer.text = viewer + " Views"
                self.profileImagvView.sd_setImage(with: URL(string: (response.value(forKey: "band_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                self.genreArray = response.value(forKey: "genres") as? NSMutableArray
                self.genreCollection.reloadData()
                var dict = NSDictionary()
                dict = (response.value(forKey: "latest_post") as? NSDictionary)!
                self.communityArray.add(dict)
                
                 var rateper:Int!
                 rateper =  response.value(forKey: "rating_percentage") as? Int
                
                 var rate = String()
                 rate = String(rateper)
                
                self.ratingperLbl.text =  rate + "%"
                
                if dict.count == 0 {
                    self.viewHeightCons.constant = 0
                    self.updateLbl.isHidden = true
                    self.viewAllBtn.isHidden = true
                    self.communityView.isHidden = true
                }else {
                    self.viewHeightCons.constant = 311
                    self.updateLbl.isHidden = false
                    self.viewAllBtn.isHidden = false
                    self.communityView.isHidden = false
                    self.communityImageView.sd_setImage(with: URL(string: (dict.value(forKey: "post_image") as? String)!), placeholderImage: UIImage(named: "Artist_img_3"))
                    self.postTitleLbl.text = dict.value(forKey: "post_title") as? String
                    self.postDescription.text = dict.value(forKey: "description") as? String
                    self.likeid = dict.value(forKey: "id") as? Int
                    var likeCOUNT = Int()
                    likeCOUNT = (dict.value(forKey: "like_count") as? Int)!
                    self.postId = dict.value(forKey: "id") as? Int
                    var likeSts = Int()
                    likeSts = (dict.value(forKey: "like_status") as? Int)!
                    
                    if likeSts == 1 {
                        self.likeBtn.setImage(UIImage(named: "like_icon"), for: .normal)
                    }else {
                        self.likeBtn.setImage(UIImage(named: "grey_like"), for: .normal)
                    }
                    
                    var likeC = String()
                    likeC = String(likeCOUNT)
                    
                    self.likecountlbl.text = likeC
                    
                    var CommentCount = Int()
                    CommentCount = (dict.value(forKey: "comment_count") as? Int)!
                    
                    var CommentC = String()
                    CommentC = String(CommentCount)
                    
                    self.commentCountLbl.text = CommentC
                }
                self.removeAllOverlays()
            }
        }
    }
    
    
    //MARK:- Artist Detail WebService
    @objc func DiscoverPostLikeAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                
                var Data1 = Int()
                Data1 = (notification.userInfo?["data"] as? Int)!
                
                var likeConnt = String()
                likeConnt = String(Data1)
                self.likecountlbl.text = likeConnt
                
                if status == 0 {
                    self.likeBtn.setImage(UIImage(named: "grey_like"), for: .normal)
                }else{
                    self.likeBtn.setImage(UIImage(named: "like_icon"), for: .normal)
                }
                self.removeAllOverlays()
            }
            else{
                var Data1 = Int()
                Data1 = (notification.userInfo?["data"] as? Int)!
                
                var likeConnt = String()
                likeConnt = String(Data1)
                self.likecountlbl.text = likeConnt
                
                if status == 0 {
                    self.likeBtn.setImage(UIImage(named: "grey_like"), for: .normal)
                }else{
                    self.likeBtn.setImage(UIImage(named: "like_icon"), for: .normal)
                }
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistLikeUnlike"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    
    //MARK:- follow
    @objc func FollowArtistAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistFollowUnfollow"), object: nil)
                self.Data1 = (notification.userInfo?["data"] as? Int)!
                if self.Data1 == 1 {
                    self.followBtn.setImage(UIImage(named: "Un_Follow_button"), for: .normal)
                }else {
                    self.followBtn.setImage(UIImage(named: "Follow"), for: .normal)
                }
                self.removeAllOverlays()
                
            }
            else{
                
                self.Data1 = (notification.userInfo?["data"] as? Int)!
                if self.Data1 == 1 {
                    self.followBtn.setImage(UIImage(named: "Un_Follow_button"), for: .normal)
                }else {
                    self.followBtn.setImage(UIImage(named: "Follow"), for: .normal)
                }
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistFollowUnfollow"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        BandId = defaults.integer(forKey: "BandID")
        bandUserID = defaults.integer(forKey: "BandUserID")
        
        
        
        
        self.RatingView.emptyImage = UIImage(named: "star_2")
        self.RatingView.fullImage = UIImage(named: "star_1")
        // Optional params
        self.RatingView.delegate = self
        self.RatingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.RatingView.maxRating = 5
        self.RatingView.minRating = 0
        self.RatingView.editable = false
        self.RatingView.halfRatings = false
        self.RatingView.floatRatings = false
        
        if bandUserID == userId {
           // followBtn.isHidden = true
           // messageBtn.isHidden = true
//            shareBtn.isHidden = false
        }else {
           // followBtn.isHidden = false
           // messageBtn.isHidden = false
//            shareBtn.isHidden = true
        }
        messageBtn.layer.cornerRadius = 18
        genreArray = NSMutableArray()
        communityArray = NSMutableArray()
        
        profileImagvView.layer.cornerRadius = profileImagvView.frame.height/2
        profileImagvView.layer.masksToBounds = true
        profileImagvView.clipsToBounds = true
        
       // NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("ArtistDetail"), object: nil)
        
        if Reachability.isConnectedToNetwork() == true {
            
            showWaitOverlay()
            Parsing().DiscoverBandDetail(BandId: BandId, UserId: userId, BandUserId: bandUserID)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverArtistDetailAction), name: NSNotification.Name(rawValue: "DiscoverBandDetail"), object: nil)
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
        
       
        // Do any additional setup after loading the view.
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().DiscoverBandDetail(BandId: BandId, UserId: userId, BandUserId: bandUserID)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverArtistDetailAction), name: NSNotification.Name(rawValue: "DiscoverBandDetail"), object: nil)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GetGenresCell
        var dict = NSDictionary()
        dict = genreArray.object(at: indexPath.row) as! NSDictionary
        cell.genreBtn.setTitle(dict.value(forKey: "genre_name") as? String, for: .normal)
        return cell
    }
    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        //        self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
        //self.liveLabel.text = String(self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
   
    @IBAction func comentBtnAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.setValue(postId, forKey: "POSTID")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func viewAllbvtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArtistCommunityViewController") as! ArtistCommunityViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func ShareDetailBtnAction(_ sender: Any) {
        let text = "This is some text that I want to share."
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        activityViewController.popoverPresentationController?.sourceRect = self.navigationController?.navigationBar.frame ?? CGRect.zero
        activityViewController.popoverPresentationController?.sourceView = self.navigationController?.navigationBar
        self.present(activityViewController, animated: true)
    }
    
    @IBAction func likeBtnAction(_ sender: Any) {
        showWaitOverlay()
        Parsing().DiscoverArtistLikeUnlike(user_Id: userId, LikeId: likeid, Like_Type: "post_like")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistLikeUnlike"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverPostLikeAction), name: NSNotification.Name(rawValue: "DiscoverArtistLikeUnlike"), object: nil)
        
    }
    
    @IBAction func shareBtnAction(_ sender: Any) {
        let text = "This is some text that I want to share."
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        activityViewController.popoverPresentationController?.sourceRect = self.navigationController?.navigationBar.frame ?? CGRect.zero
        activityViewController.popoverPresentationController?.sourceView = self.navigationController?.navigationBar
        self.present(activityViewController, animated: true)
    }
    
    @IBAction func followBtnAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().DiscoverArtistFollowUnfollow(user_Id: userId, FollowId: BandId, Follow_Type: "band")
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistFollowUnfollow"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.FollowArtistAction), name: NSNotification.Name(rawValue: "DiscoverArtistFollowUnfollow"), object: nil)
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
    
    @IBAction func messageBtnAction(_ sender: Any) {
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
