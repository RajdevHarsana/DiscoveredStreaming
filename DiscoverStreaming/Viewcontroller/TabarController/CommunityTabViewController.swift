//
//  CommunityTabViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast


class CommunityTabViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var communityTableview: UITableView!
    var response = NSMutableArray()
    var userid = Int()
    var defaults:UserDefaults!
    var myindexpath = NSIndexPath()
    var PostId: Int!
    var dict1 = NSDictionary()
    var arryFav:NSMutableArray!
    var indexPath = IndexPath()
    var Data1 = Int()
    var slooooooooooot = Int()
    var APICall = Bool()
    var communityRefreshControl: UIRefreshControl!
    
    //MARK:- Login WebService
    @objc func DiscoverPostListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                 self.APICall = false
                self.removeAllOverlays()
                self.communityTableview.reloadData()
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
                print("response: \(String(describing: self.response))")
                for i in 0..<self.response.count {
                    
                    var dict = NSDictionary()
                    dict = self.response.object(at: i) as! NSDictionary
                    
                    let s_id = dict.object(forKey: "id") ?? NSString()
                    var isFav = Int()
                    isFav = dict.object(forKey: "like_status") as! Int
                    //self.arryFav = []
                    if isFav == 1
                    {
                        self.arryFav.add(s_id)
                    }
                    
                }
                self.communityTableview.reloadData()
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
//                let test =  SwiftToast(
//                    text: str_message,
//                    textAlignment: .center,
//                    image: UIImage(named: "ic_alert"),
//                    backgroundColor: .purple,
//                    textColor: .white,
//                    font: .boldSystemFont(ofSize: 15.0),
//                    duration: 2.0,
//                    minimumHeight: CGFloat(100.0),
//                    statusBarStyle: .lightContent,
//                    aboveStatusBar: true,
//                    target: nil,
//                    style: .navigationBar)
//                self.present(test, animated: true)
                self.Data1 = (notification.userInfo?["data"] as? Int)!
                let dict = self.response.object(at: self.indexPath.row) as! NSMutableDictionary
                dict["like_count"] =  self.Data1;
                self.response[self.indexPath.row] = dict
                self.communityTableview.reloadRows(at: [self.indexPath], with: .fade)            
                self.removeAllOverlays()
            }
            else{
//                let test =  SwiftToast(
//                    text: str_message,
//                    textAlignment: .center,
//                    image: UIImage(named: "ic_alert"),
//                    backgroundColor: .purple,
//                    textColor: .white,
//                    font: .boldSystemFont(ofSize: 15.0),
//                    duration: 2.0,
//                    minimumHeight: CGFloat(100.0),
//                    statusBarStyle: .lightContent,
//                    aboveStatusBar: true,
//                    target: nil,
//                    style: .navigationBar)
//                self.present(test, animated: true)
                self.Data1 = (notification.userInfo?["data"] as? Int)!
                let dict = self.response.object(at: self.indexPath.row) as! NSMutableDictionary
                dict["like_count"] =  self.Data1;
                self.response[self.indexPath.row] = dict
                self.communityTableview.reloadRows(at: [self.indexPath], with: .fade)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistLikeUnlike"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            self.communityRefreshControl = UIRefreshControl()
            self.communityRefreshControl.tintColor = UIColor.systemPink
//            self.venueRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.communityRefreshControl.addTarget(self,action: #selector(self.refreshCommunityList),for: .valueChanged)
            self.communityTableview.addSubview(self.communityRefreshControl)
        }
        defaults = UserDefaults.standard
        userid = defaults.integer(forKey: "UserIDGet")
        
        response = NSMutableArray()
        arryFav = NSMutableArray()
        slooooooooooot = 0
        APICall = true
//        response.removeAllObjects()
        self.postListAPI()
        
//         NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("CommentUpdate"), object: nil)
       
     
       

        // Do any additional setup after loading the view.
    }
    
    @objc func refreshCommunityList(sender: UIRefreshControl) {
       // Code to refresh table view
        self.communityTableview.reloadData()
        self.communityRefreshControl.endRefreshing()
        self.postListAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func postListAPI(){
        if Reachability.isConnectedToNetwork(){
            self.showWaitOverlay()
            Parsing().DiscoverPostListing(PostId: userid, ArtistId: 0, postType: "", postTypeId: "", Offset:slooooooooooot)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverPostListAction), name: NSNotification.Name(rawValue: "DiscoverPostListing"), object: nil)
        } else {
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
            // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Internet Connection not Available!" , buttonTitle: "OK")
        }
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        if Reachability.isConnectedToNetwork() == true {
        self.showWaitOverlay()
            Parsing().DiscoverPostListing(PostId: userid, ArtistId: 0, postType: "", postTypeId: "", Offset: slooooooooooot)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverPostListAction), name: NSNotification.Name(rawValue: "DiscoverPostListing"), object: nil)
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
            self.response.removeAllObjects()
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
            self.communityTableview.addSubview(communityRefreshControl)
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Community Module Found"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return response.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommunityTabCell
       
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.postNamelbl.text = dict.value(forKey: "post_title") as? String
        cell.posttitle.text = dict.value(forKey: "name") as? String
        cell.postImageView.sd_setImage(with: URL(string: (dict.value(forKey: "post_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
        cell.postDescription.text =  dict.value(forKey: "description") as? String
        cell.commentBtn.tag = indexPath.row
        cell.commentBtn.addTarget(self, action: #selector(handletap(_:)), for: .touchUpInside)
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(handletap1(_:)), for: .touchUpInside)
        cell.shareBtn.tag = indexPath.row
        cell.shareBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        if arryFav.contains(dict.object(forKey: "id")!) {
            cell.likeBtn.setImage(UIImage(named: "like_icon"), for: .normal)
        }else {
            cell.likeBtn.setImage(UIImage(named: "grey_like"), for: .normal)
        }
        
        var likeCount = Int()
        likeCount =  dict.value(forKey: "like_count") as! Int
        
        var likeSts = Int()
        likeSts =  dict.value(forKey: "like_status") as! Int
        
        if likeSts == 1 {
            cell.likeBtn.setImage(UIImage(named: "like_icon"), for: .normal)
        }else{
             cell.likeBtn.setImage(UIImage(named: "grey_like"), for: .normal)
        }
        
        if arryFav.contains(dict.object(forKey: "id")!) {
            cell.likeBtn.setImage(UIImage(named: "like_icon"), for: .normal)
        }else {
            cell.likeBtn.setImage(UIImage(named: "grey_like"), for: .normal)
        }
        
        var countLike = String()
        countLike = String(likeCount)
        
        cell.likeCountLbl.text = countLike
        
        var CommentCount = Int()
        CommentCount =  dict.value(forKey: "comment_count") as! Int
        
        var countComment = String()
        countComment = String(CommentCount)
        
        cell.commentcountLbl.text = countComment
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
            showWaitOverlay()
            Parsing().DiscoverPostListing(PostId: userid, ArtistId: 0, postType: "", postTypeId: "", Offset:slooooooooooot)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverPostListAction), name: NSNotification.Name(rawValue: "DiscoverPostListing"), object: nil)
            
        }
    }
    
    @objc func handletap(_ sender:UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: communityTableview)
        myindexpath = communityTableview.indexPathForRow(at: buttonPosition)! as NSIndexPath
        dict1 = (response.object(at: myindexpath.row) as? NSDictionary)!
        PostId = dict1.object(forKey: "id") as? Int
        let defaults = UserDefaults.standard
        defaults.set(self.PostId, forKey: "POSTID")
        defaults.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handletap1(_ sender:UIButton) {
        var btn = sender as? UIButton
        let dict1 = response.object(at: (btn?.tag)!) as! NSDictionary
        
        let s_id = dict1.object(forKey: "id") ?? NSString()
        
        if arryFav.contains(s_id)
        {
            arryFav.remove(s_id)
        }
        else
        {
            arryFav.add(s_id)
        }
        
        indexPath = IndexPath(row: (btn?.tag)!, section: 0)
        //communityTableview.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.none)
        
        if Reachability.isConnectedToNetwork() == true {
//        showWaitOverlay()
        Parsing().DiscoverArtistLikeUnlike(user_Id: userid, LikeId: s_id as? Int, Like_Type: "post_like")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverArtistLikeUnlike"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverPostLikeAction), name: NSNotification.Name(rawValue: "DiscoverArtistLikeUnlike"), object: nil)
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
    @objc func handleTap(_ sender:UIButton) {
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
