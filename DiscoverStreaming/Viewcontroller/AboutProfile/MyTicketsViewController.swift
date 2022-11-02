//
//  MyTicketsViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 05/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class MyTicketsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   

    @IBOutlet weak var ticketTableview: UITableView!
    var defaults:UserDefaults!
    var userId:Int!
    var response = NSMutableArray()
    var slooooooooooot = Int()
    var APICall = Bool()
    
    @objc func DiscoverTicketListAction(_ notification: Notification) {
        
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
                 self.APICall = false
                //  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverTicketsList"), object: nil)
                self.removeAllOverlays()
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
//                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
//                print("response: \(self.response)")
                self.ticketTableview.reloadData()
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverTicketsList"), object: nil)
                self.removeAllOverlays()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        
        slooooooooooot = 0
        APICall = true
        response.removeAllObjects()
        
        if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().DiscoverTicketsList(UserId: userId, ListType: "user", Offset: slooooooooooot)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverTicketsList"), object: nil)
             NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverTicketListAction), name: NSNotification.Name(rawValue: "DiscoverTicketsList"), object: nil)
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
            noDataLabel.text = "No Tickets Available."
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTicketsCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        var date:String!
        date = dict.value(forKey: "event_date") as? String
        var Time:String!
        Time = dict.value(forKey: "event_time") as? String
        cell.timeLbl.text =  date + " " + Time
        cell.nameLbl.text = dict.value(forKey: "name") as? String
        cell.ticketNumberLbl.text = dict.value(forKey: "ticket_no") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        var ticId:Int!
        ticId = dict.value(forKey: "id") as? Int
        let defaults = UserDefaults.standard
        defaults.set(ticId, forKey:"TicID")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "TicketQRCodeViewController") as! TicketQRCodeViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true {
            showWaitOverlay()
           Parsing().DiscoverTicketsList(UserId: userId, ListType: "user", Offset: slooooooooooot)
           NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverTicketsList"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverTicketListAction), name: NSNotification.Name(rawValue: "DiscoverTicketsList"), object: nil)
        }
    }
    
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        let datanew = UserDefaults.standard.value(forKey: "NewChange") as? String
        if datanew == "NonSequal" {
            self.navigationController?.popViewController(animated: true)
        }else {
            let navigate = storyboard!.instantiateViewController(withIdentifier: "tabbar")
            navigationController?.pushViewController(navigate, animated: true)
        }
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
