//
//  EventRevenueTicketViewController.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 28/08/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class EventRevenueTicketViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var ticketListTable: UITableView!
    @IBOutlet weak var eventName_Lbl: UILabel!
    
    var defaults:UserDefaults!
    var user_Id:Int!
    var eventID:Int!
    var eventName:String!
    var as_type_id:Int!
    var response = NSMutableArray()
    var isCall = Bool()
    var table = UITableView()
    var slooooooooooot = Int()
    var APICall = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        eventID = defaults.integer(forKey: "EventID")
        eventName = defaults.string(forKey: "EventTitle")
        eventName_Lbl.text = eventName
        self.ticketListTable.delegate = self
        self.ticketListTable.dataSource = self
        slooooooooooot = 0
        APICall = true
        ticketEventListApi()
        response.removeAllObjects()
        // Do any additional setup after loading the view.
    }
    
    func ticketEventListApi(){
                
        if !isCall{
        if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setObject(DataManager.getVal(self.user_Id), forKey: "user_id" as NSCopying)
            parameterDictionary.setValue(DataManager.getVal(self.eventID), forKey: "event_id")
            parameterDictionary.setValue(DataManager.getVal(10), forKey: "limit")
            parameterDictionary.setValue(DataManager.getVal(slooooooooooot), forKey: "offset")
            print(parameterDictionary)
            let methodName = "eventRevenueDetail"
            DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            DispatchQueue.main.async(execute: {
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                if status == "0" {
                    self.ticketListTable.reloadData()
                    self.removeAllOverlays()
                }else{
                    var arr_data = NSMutableArray()
                    arr_data = (responseData?.object(forKey: "data") as? NSMutableArray)!
                    self.APICall = true
                    if arr_data.count != 0 {
                    self.response.addObjects(from: arr_data as NSMutableArray? as! [Any])
                    self.slooooooooooot = self.slooooooooooot + 10
                    arr_data.removeAllObjects()
                }
                  self.ticketListTable.reloadData()
                  self.removeAllOverlays()
              }
                self.removeAllOverlays()
            })
            }
        }else{
        }
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
            noDataLabel.text = "No Ticket List Found"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RevenueEventTicketListCell
        let color: UIColor = UIColor.darkGray
        cell.detailView.layer.cornerRadius = 10
        cell.detailView.layer.borderWidth = 1
        cell.detailView.layer.borderColor = color.cgColor
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.ticketBuyerName_Lbl.text = dict.value(forKey: "name") as? String
        cell.purchaseDate_Lbl.text = dict.value(forKey: "booking_date") as? String
        cell.numOfTickets_Lbl.text = dict.value(forKey: "total_ticket") as? String
        var fees = Int()
        fees = dict.value(forKey: "processing_fee") as? Int ?? 0
        cell.proceessFee_Lbl.text = String(fees)
        var price = String()
        price = dict.value(forKey: "total_amount") as? String ?? ""
        cell.totalAmount_Lbl.text =  "$ " + price
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.slooooooooooot - 2) && self.APICall ==  true{
           ticketEventListApi()
        }
    }
    
    
    
    @IBAction func backButtonAction_btn(_ sender: Any) {
       navigationController?.popViewController(animated:true)
    }
    
}
