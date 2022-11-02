//
//  ManageSongDetailViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 22/11/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftToast

class ManageSongDetailViewController: UIViewController,FloatRatingViewDelegate {

    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songNameLbl: UILabel!
    @IBOutlet weak var viewLbl: UILabel!
    @IBOutlet weak var likeCountyLbl: UILabel!
    @IBOutlet weak var unlikeCountLbl: UILabel!
    @IBOutlet weak var downloadcountLbl: UILabel!
    @IBOutlet weak var purchaseCountLbl: UILabel!
    
    @IBOutlet weak var feturedTitle_Lbl: UILabel!
    @IBOutlet weak var songFeture_btn: UIButton!
    @IBOutlet weak var featured_img: UIImageView!
    
    @IBOutlet weak var songtypeViewLbl: UILabel!
    @IBOutlet weak var ratingview: FloatRatingView!
    @IBOutlet weak var rateperLbl: UILabel!
    var defaults:UserDefaults!
    var userId:Int!
    var SongID:Int!
    var typeID = Int()
    var flag = Bool()
    var packageId = Int()
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var messgaeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var viewallBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var commenttlLbl: UILabel!
    
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
                self.songNameLbl.text = response.value(forKey: "song_name") as? String
                self.songImage.sd_setImage(with: URL(string: (response.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                var view:Int!
                view = response.value(forKey: "viewer") as? Int
                var viewer:String!
                viewer = String(view)
                self.viewLbl.text = viewer + "  " + "Views"
                
                var TotalLike:Int!
                TotalLike = response.value(forKey: "total_likes") as? Int
                var TlLikeCount:String!
                TlLikeCount = String(TotalLike)
                self.likeCountyLbl.text = TlLikeCount
                self.songtypeViewLbl.text = response.value(forKey: "as_type_name") as? String
                
                var TotalUnLike:Int!
                TotalUnLike = response.value(forKey: "total_unlikes") as? Int
                var TlUnLikeCount:String!
                TlUnLikeCount = String(TotalUnLike)
                self.unlikeCountLbl.text = TlUnLikeCount
                var rating1:NSNumber!
                rating1 = response.value(forKey: "rating") as? NSNumber
                let songIsFeatured = response.value(forKey: "song_is_featured") as? String ?? ""
                if songIsFeatured == "1"{
                self.songFeture_btn.isHidden = true
                self.featured_img.isHidden = false
                let feturedExpDate = response.value(forKey: "feature_expire") as? String ?? ""
                self.feturedTitle_Lbl.text = "Song is featured till : " + "\(feturedExpDate)"
                }else{
                self.songFeture_btn.isHidden = false
                self.featured_img.isHidden = true
                }
                var rate = Float()
                rate = Float(truncating: rating1)
                self.ratingview.rating = Float(truncating: NSNumber(value: rate))
                let rateper = response.value(forKey: "rating_percentage") as? String ?? ""
                self.rateperLbl.text = "\(rateper)" + "%"
                
                var dict:NSDictionary!
                dict = response.value(forKey: "latest_comment") as? NSDictionary
                
                if dict.count == 0 {
                    self.commenttlLbl.isHidden = true
                    self.commentImage.isHidden = true
                    self.userNameLbl.isHidden = true
                    self.messgaeLbl.isHidden = true
                    self.dateLbl.isHidden = true
                    self.reportBtn.isHidden = true
                    self.viewallBtn.isHidden = true
                }else {
                    self.commenttlLbl.isHidden = false
                    self.commentImage.isHidden = false
                    self.userNameLbl.isHidden = false
                    self.messgaeLbl.isHidden = false
                    self.dateLbl.isHidden = false
                    self.reportBtn.isHidden = false
                    self.viewallBtn.isHidden = false
                    
                    self.userNameLbl.text = dict.value(forKey: "name") as? String
                    self.messgaeLbl.text = dict.value(forKey: "post_comment") as? String
                    self.dateLbl.text = dict.value(forKey: "created_date") as? String
                    self.commentImage.sd_setImage(with: URL(string: (dict.value(forKey: "profile_picture") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                }
               
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if flag == true{
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        SongID = typeID
        }else{
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        SongID = defaults.integer(forKey: "Song_Id")
        }
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
        
        commentImage.layer.cornerRadius = commentImage.frame.height/2
        commentImage.layer.masksToBounds = true
        commentImage.clipsToBounds = true
        self.songFeture_btn.layer.cornerRadius = 10
        self.songImage.layer.cornerRadius = 10
        self.songDetailsApi()
//        if Reachability.isConnectedToNetwork() == true{
//            showWaitOverlay()
//            Parsing().DiscoverSongDetail(UserId: userId, SongId: SongID)
//            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongDetailAction), name: NSNotification.Name(rawValue: "DiscoverSongDetail"), object: nil)
//        }else{
//            let test =  SwiftToast(
//                text: "Internet Connection not Available!",
//                textAlignment: .center,
//                image: UIImage(named: "Icon-App-29x29"),
//                backgroundColor: .purple,
//                textColor: .white,
//                font: .boldSystemFont(ofSize: 15.0),
//                duration: 2.0,
//                minimumHeight: CGFloat(80.0),
//                aboveStatusBar: false,
//                target: nil,
//                style: .navigationBar)
//            self.present(test, animated: true)
//
//        }

        // Do any additional setup after loading the view.
    }
    
    func songDetailsApi(){
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
              self.songNameLbl.text = response.value(forKey: "song_name") as? String
              self.songImage.sd_setImage(with: URL(string: (response.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
              var view:Int!
              view = response.value(forKey: "viewer") as? Int
              var viewer:String!
              viewer = String(view)
              self.viewLbl.text = viewer + "  " + "Views"
              var TotalLike:Int!
              TotalLike = response.value(forKey: "total_likes") as? Int
              var TlLikeCount:String!
              TlLikeCount = String(TotalLike)
              self.likeCountyLbl.text = TlLikeCount
              self.songtypeViewLbl.text = response.value(forKey: "as_type_name") as? String
              let package_Id = response.value(forKey: "package_id") as? Int
              self.packageId = package_Id ?? 0
              var TotalUnLike:Int!
              TotalUnLike = response.value(forKey: "total_unlikes") as? Int
              var TlUnLikeCount:String!
              TlUnLikeCount = String(TotalUnLike)
              self.unlikeCountLbl.text = TlUnLikeCount
              var rating1:NSNumber!
              rating1 = response.value(forKey: "rating") as? NSNumber
              let songIsFeatured = response.value(forKey: "song_is_featured") as? Int
              if songIsFeatured == 1 {
              self.songFeture_btn.isHidden = true
              self.featured_img.isHidden = false
              let feturedExpDate = response.value(forKey: "feature_expire") as? String ?? ""
              self.feturedTitle_Lbl.text = "Song is featured till : " + "\(feturedExpDate)"
              }else{
              self.songFeture_btn.isHidden = false
              self.featured_img.isHidden = true
              }
              var rate = Float()
              rate = Float(truncating: rating1)
              self.ratingview.rating = Float(truncating: NSNumber(value: rate))
              let rateper = response.value(forKey: "rating_percentage") as? String ?? ""
              self.rateperLbl.text = "\(rateper)" + "%"
              
              var dict:NSDictionary!
              dict = response.value(forKey: "latest_comment") as? NSDictionary
              
              if dict.count == 0 {
                  self.commenttlLbl.isHidden = true
                  self.commentImage.isHidden = true
                  self.userNameLbl.isHidden = true
                  self.messgaeLbl.isHidden = true
                  self.dateLbl.isHidden = true
                  self.reportBtn.isHidden = true
                  self.viewallBtn.isHidden = true
              }else {
                  self.commenttlLbl.isHidden = false
                  self.commentImage.isHidden = false
                  self.userNameLbl.isHidden = false
                  self.messgaeLbl.isHidden = false
                  self.dateLbl.isHidden = false
                  self.reportBtn.isHidden = false
                  self.viewallBtn.isHidden = false
                  
                  self.userNameLbl.text = dict.value(forKey: "name") as? String
                  self.messgaeLbl.text = dict.value(forKey: "post_comment") as? String
                  self.dateLbl.text = dict.value(forKey: "created_date") as? String
                  self.commentImage.sd_setImage(with: URL(string: (dict.value(forKey: "profile_picture") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
              }
             
              self.removeAllOverlays()
          }else{
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
          self.present(test, animated: true)
          
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
    
    @IBAction func viewAllBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ManageSongCommentViewController") as! ManageSongCommentViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reportBtnAction(_ sender: Any) {
    }
    
    func addFeturedSong(){
    if Reachability.isConnectedToNetwork() == true{
        showWaitOverlay()
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.userId), forKey: "user_id" as NSCopying)
        parameterDictionary.setValue(DataManager.getVal(self.SongID), forKey: "song_id")
        parameterDictionary.setValue(DataManager.getVal(self.packageId), forKey: "purchase_plan_id")
        print(parameterDictionary)
        
        let methodName = "addSongFeatured"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
        DispatchQueue.main.async(execute: {
            let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
            let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
            if status == "1" {
                self.songDetailsApi()
                let test =  SwiftToast(
                text: message,
                textAlignment: .center,
                backgroundColor: .purple,
                textColor: .white,
                font: .boldSystemFont(ofSize: 15.0),
                duration: 2.0,
                minimumHeight: CGFloat(80.0),
                aboveStatusBar: false,
                target: nil,
                style: .navigationBar)
                self.present(test, animated: true)
            }else{
                let test =  SwiftToast(
                text: message,
                textAlignment: .center,
                backgroundColor: .purple,
                textColor: .white,
                font: .boldSystemFont(ofSize: 15.0),
                duration: 2.0,
                minimumHeight: CGFloat(80.0),
                aboveStatusBar: false,
                target: nil,
                style: .navigationBar)
                self.present(test, animated: true)
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
        self.present(test, animated: true)
        
      }
    }
    
    @IBAction func yesButtonAction(_ sender: UIButton) {
        let nextview = Featuredview.intitiateFromNib()
        let model = NewPopModel()
        nextview.buttonDoneHandeler = {
            self.addFeturedSong()
            let flag = "true"
            self.defaults.set(flag, forKey: "song_Featured")
        model.closewithAnimation()
        }
        nextview.buttonCancleHandeler = {
            model.closewithAnimation()
        }
        model.show(view: nextview)
        
    }
    
}
