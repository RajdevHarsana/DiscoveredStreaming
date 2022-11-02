//
//  VenueUserDetailViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class VenueUserDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FloatRatingViewDelegate {
   

    @IBOutlet weak var imagescroll: ImageScroller!
    @IBOutlet weak var ratingview: FloatRatingView!
    @IBOutlet weak var ratingpercentagelbl: UILabel!
    @IBOutlet weak var VenuenameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var viewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var viewCommunity: UIView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var communityiomageview: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDes: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var messBtn: UIButton!
    @IBOutlet weak var mesCount: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var ambiencelbl: UILabel!
    var venueId:Int!
    var user_id:Int!
    var defaults:UserDefaults!
    var venueImage = NSMutableArray()
    var communityArray = NSMutableArray()
    var likeid:Int!
    var postId:Int!
    var typeID = Int()
    var flag = Bool()
    
    //MARK:- Artist Detail WebService
    @objc func DiscoverVenueDetailAction(_ notification: Notification) {
        
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
                
                self.VenuenameLbl.text = response.value(forKey: "venue_name") as? String
                self.venueImage = response.value(forKey: "venue_image") as! NSMutableArray
                self.descriptionLbl.text = response.value(forKey: "about_venue") as? String
                self.imageCollection.reloadData()
                var str_address = String()
                str_address = (response.value(forKey: "address") as? String)!
                
                var str_city = String()
                str_city = (response.value(forKey: "city") as? String)!

                var str_state = String()
                str_state = (response.value(forKey: "state") as? String)!
                
                var str_zipcode = Int()
                str_zipcode = (response.value(forKey: "zipcode") as? Int)!
                
                var zip = String()
                zip = String(str_zipcode)
                var str_country = String()
                str_country = (response.value(forKey: "country") as? String)!
                
                self.addressLbl.text = str_address + " " + str_city + " " + str_state + " " + str_country + " " + zip
                var amb:Int!
                amb = response.value(forKey: "ambience") as? Int
                var capamb:String!
                capamb = String(amb)
                var rating1 = NSNumber()
                rating1 = response.value(forKey: "rating") as! NSNumber
                self.ratingview.rating = Float(truncating: rating1)
                self.ambiencelbl.text = capamb
                
                var ratingper:Int!
                ratingper = response.value(forKey: "rating_percentage") as? Int
                var rateper = String()
                rateper = String(ratingper)
                self.ratingpercentagelbl.text = rateper + "%"
                
//                self.AddressLbl.text = str_city + "," + str_state
//                self.descriptionLbl.text = response.value(forKey: "description") as? String
//                var str_rating = NSNumber()
//                str_rating  = response.value(forKey: "rating") as! NSNumber
//                self.RatingView.rating = Float(truncating: str_rating)
//                var str_view = Int()
//                str_view = response.value(forKey: "viewer") as! Int
//                var viewer = String()
//                viewer = String(str_view)
//                self.Viewer.text = viewer + " Views"
//                self.profileImagvView.sd_setImage(with: URL(string: (response.value(forKey: "artist_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))

                var dict = NSDictionary()
                dict = (response.value(forKey: "latest_post") as? NSDictionary)!
               
                if dict.count == 0 {
                    self.viewHeightCons.constant = 0
                    self.viewCommunity.isHidden = true
                
                }else {
                     self.communityArray.add(dict)
                    self.viewHeightCons.constant = 310
                    self.viewCommunity.isHidden = false
                    self.communityiomageview.sd_setImage(with: URL(string: (dict.value(forKey: "post_image") as? String)!), placeholderImage: UIImage(named: ""))
                    self.postTitle.text = dict.value(forKey: "post_title") as? String
                    self.postDes.text = dict.value(forKey: "description") as? String
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

                    self.likeCount.text = likeC

                    var CommentCount = Int()
                    CommentCount = (dict.value(forKey: "comment_count") as? Int)!

                    var CommentC = String()
                    CommentC = String(CommentCount)

                    self.mesCount.text = CommentC
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
                self.likeCount.text = likeConnt
                
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
                self.likeCount.text = likeConnt
                
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
    override func viewDidLoad() {
        super.viewDidLoad()
        if flag == true{
        defaults = UserDefaults.standard
        user_id = defaults.integer(forKey: "UserIDGet")
        venueId = typeID
        }else{
        defaults = UserDefaults.standard
        venueId = defaults.integer(forKey: "VenueID")
        user_id = defaults.integer(forKey: "UserIDGet")
        }
//        var vid:Int!
//        vid = Int(venueId)
        
        let screenWidth = UIScreen.main.bounds.size.width
        //  let screenHeight = UIScreen.main.bounds.size.height
        let LiberaryLayOut = UICollectionViewFlowLayout()
        LiberaryLayOut.itemSize = CGSize(width: screenWidth-16, height: 231)
        LiberaryLayOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        LiberaryLayOut.minimumInteritemSpacing = 0
        LiberaryLayOut.minimumLineSpacing = 0
        LiberaryLayOut.scrollDirection = .horizontal
        
        self.ratingview.emptyImage = UIImage(named: "star_2")
        self.ratingview.fullImage = UIImage(named: "star_1")
        // Optional params
        self.ratingview.delegate = self
        self.ratingview.contentMode = UIView.ContentMode.scaleAspectFit
        self.ratingview.maxRating = 5
        self.ratingview.minRating = 0
        self.ratingview.editable = false
        self.ratingview.halfRatings = false
        self.ratingview.floatRatings = false
        
        
        imageCollection.collectionViewLayout = LiberaryLayOut
        if Reachability.isConnectedToNetwork() == true {
            
            showWaitOverlay()
            Parsing().DiscoverVenueDetail(UserId: user_id, Venue_id: venueId)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverVenueDetailAction), name: NSNotification.Name(rawValue: "DiscoverVenueDetail"), object: nil)
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
    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        //        self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
        //self.liveLabel.text = String(self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venueImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageScrollCell
        cell.imageview.contentMode = .scaleAspectFit
        var dict = NSDictionary()
        dict = venueImage.object(at: indexPath.item) as! NSDictionary
        cell.imageview.sd_setImage(with: URL(string: (dict.value(forKey: "image") as! String)), placeholderImage: UIImage(named: "Group 4-1"))
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageCollection.frame.size.width, height: 231)
    }
    
    
    
    @IBAction func commentBtnAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.setValue(postId, forKey: "POSTID")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func viewAllBtnAction(_ sender: Any) {
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
  
    @IBAction func likeBtnAction(_ sender: Any) {
        showWaitOverlay()
        Parsing().DiscoverArtistLikeUnlike(user_Id: user_id, LikeId: likeid, Like_Type: "post_like")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistLikeUnlike"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverPostLikeAction), name: NSNotification.Name(rawValue: "DiscoverArtistLikeUnlike"), object: nil)
    }
    
    @IBAction func shreBtnAction(_ sender: Any) {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
