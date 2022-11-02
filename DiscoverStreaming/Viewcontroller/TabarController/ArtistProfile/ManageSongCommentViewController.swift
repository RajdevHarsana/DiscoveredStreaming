//
//  ManageSongCommentViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/03/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class ManageSongCommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var commentTableview: UITableView!
    var defaults:UserDefaults!
    var userId:Int!
    var postId:Int!
    var response = NSMutableArray()
    var SongID:Int!
    
    @objc func DiscoverPostCommentListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverPostCommentList"), object: nil)
                // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.commentTableview.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverPostCommentList"), object: nil)
                
                self.removeAllOverlays()
                
            }
        }
    }
    
    
  
    @objc func DiscoverReportAction(_ notification: Notification) {
        
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
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverReport"), object: nil)
                self.removeAllOverlays()
            }
            else{
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
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverReport"), object: nil)
                self.removeAllOverlays()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        SongID = defaults.integer(forKey: "Song_Id")
        if Reachability.isConnectedToNetwork() {
            showWaitOverlay()
            Parsing().DiscoverPostCommentList(UserId: userId, PostId: SongID, CommentType: "song")
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverPostCommentListAction), name: NSNotification.Name(rawValue: "DiscoverPostCommentList"), object: nil)
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
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
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
            noDataLabel.text          = "No Comments Found"
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ManageCommentCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.UsernameLbl.text = dict.value(forKey: "name") as? String
        cell.messageLbl.text = dict.value(forKey: "post_comment") as? String
        cell.dateLbl.text = dict.value(forKey: "created_date") as? String
        cell.commentImage.sd_setImage(with: URL(string: (dict.value(forKey: "user_picture") as? String)!), placeholderImage: UIImage(named: "profile_image_1"))
        var userid:Int!
        userid = dict.value(forKey: "user_id") as? Int
        if userid == userId {
            cell.reportBtn.isHidden = true
        }else {
             cell.reportBtn.isHidden = false
             cell.reportBtn.tag = indexPath.row
             cell.reportBtn.addTarget(self, action: #selector(HandleTap(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    @objc func HandleTap(_ sender:UIButton) {
        var dict = NSDictionary()
        dict = response.object(at: sender.tag) as! NSDictionary
        var coomentid:Int!
        coomentid = dict.value(forKey: "id") as? Int
        
        let nextview = ReportView.intitiateFromNib()
        let model = NewPopModel()
        nextview.buttonDoneHandler = { (Reason) in
            self.showWaitOverlay()
            Parsing().DiscoverReport(UserId: self.userId, ReportType: "song", ReportTypeId: self.SongID, CommentId: coomentid, Description: Reason)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverReport"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverReportAction), name: NSNotification.Name(rawValue: "DiscoverReport"), object: nil)
            model.closewithAnimation()
        }
        nextview.buttonCancleHandler = {
            model.closewithAnimation()
        }
        model.show(view: nextview)
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
