//
//  LoyaltyProgramViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class LoyaltyProgramViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var rereralBtnAction: UIButton!
    var userid:Int!
    var defaults:UserDefaults!
    var response = NSMutableArray()
    @IBOutlet weak var totalpointLbl: UILabel!
    @IBOutlet weak var pointTableview: UITableView!
    var refralpoint:Int!
    @objc func DiscoverPostCommentListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverRewardList"), object: nil)
                // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else{
               
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                self.pointTableview.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverRewardList"), object: nil)
                var TlPoint:Int!
                TlPoint = (notification.userInfo?["total_point"] as? Int)!
                var TlpointStr:String!
                TlpointStr = String(TlPoint)
                self.totalpointLbl.text = TlpointStr
                self.refralpoint = (notification.userInfo?["referral_point"] as? Int)!
                let defaults = UserDefaults.standard
                defaults.set(self.refralpoint, forKey: "REFPOINT")
                defaults.synchronize()
                self.removeAllOverlays()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        userid = defaults.integer(forKey: "UserIDGet")
        rereralBtnAction.layer.cornerRadius = 25
         if Reachability.isConnectedToNetwork() {
        showWaitOverlay()
        Parsing().DiscoverRewardList(UserId: userid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverRewardList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverPostCommentListAction), name: NSNotification.Name(rawValue: "DiscoverRewardList"), object: nil)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LoyaltyPointCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.programNameLbl.text = dict.value(forKey: "activity_name") as? String
        cell.pointsLbl.text =  dict.value(forKey: "point") as? String
        return cell
    }
    @IBAction func referalBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReferralCodeViewController") as! ReferralCodeViewController
        navigationController?.pushViewController(vc, animated: true)
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
