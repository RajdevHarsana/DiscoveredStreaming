//
//  OrderSummaryViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 17/01/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class OrderSummaryViewController: UIViewController {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var veneuNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var ticketsLbl: UILabel!
    @IBOutlet weak var ticketsPriceLbl: UILabel!
    @IBOutlet weak var convenceFeeLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var PaymnetBtn: UIButton!
    var eventname:String!
    var venuename:String!
    var venImage:String!
    var price:String!
    var addresven:String!
    var datetime:String!
    var defaults:UserDefaults!
    var notic:String!
    var confee:String!
    var tax:String!
    var tlamnt:Float!
    var ticprice = Float()
    var userId:Int!
    var customerId:String!
    var totalpr:String!
    var processAmout:String!
    @objc func DiscoverticketCalAction(_ notification: Notification) {
           
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
                   //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                   self.removeAllOverlays()
               }
               else{
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                var processAmnt:Int!
                processAmnt = response.value(forKey: "processing_amount") as? Int
                self.processAmout =  String(processAmnt)
                
                self.convenceFeeLbl.text = "$" + self.processAmout
                
                var totalAmout:NSNumber!
                totalAmout = response.value(forKey: "total_amount") as? NSNumber
                
                var NoofTicket:String!
                NoofTicket = response.value(forKey: "no_of_ticket") as? String
                
               
                self.totalpr = response.value(forKey: "ticket_price") as? String
                
                
                var pr = Float()
                pr = Float(NoofTicket)!
                
                var ticprice:NSNumber!
                ticprice = response.value(forKey: "ticket_amount") as? NSNumber
                var price:Int!
                price = response.value(forKey: "ticket_amount") as? Int
                self.ticprice = Float(truncating: totalAmout)
                
                var prnew:Float!
                prnew = ticprice.floatValue
                
                self.ticketsPriceLbl.text = String(NoofTicket) + " * $" + String(price)
            
                var newprice:Float!
                newprice = pr*prnew
                
            
                self.totalAmountLbl.text = "$" + totalAmout.stringValue
                
                
                
                
                self.removeAllOverlays()
               }
           }
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        eventname = defaults.value(forKey: "NEVE") as? String
        venuename = defaults.value(forKey: "NVEN") as? String
        price = defaults.value(forKey: "PriceEve") as? String
        datetime = defaults.value(forKey: "DTEVE") as? String
        addresven = defaults.value(forKey: "ADDEVE") as? String
        venImage = defaults.value(forKey: "ImageEVE") as? String
        notic = defaults.value(forKey: "TICNo") as? String
        confee = defaults.value(forKey: "ConFee") as? String
        tax = defaults.value(forKey: "Tax") as? String
        customerId = defaults.value(forKey: "CUSTOMERID") as? String
        
        self.eventImage.sd_setImage(with: URL(string: (venImage)!), placeholderImage: UIImage(named: "Group 4-1"))
        self.eventNameLbl.text = eventname
        self.veneuNameLbl.text = "Venue:" + " " + venuename
//        self.dateTimeLbl.text = datetime
        self.addressLbl.text = addresven
        self.priceLbl.text = "$\(price ?? "")"
        ticketsLbl.text = notic + " " + "Tickets"

        var pr = Float()
        pr = Float(notic)!
        var prnew:Float!
        prnew = Float(price)
        
       // var ticprice = Float()
        //ticprice = prnew*pr
       // var newvalue = String()
        //newvalue = String(ticprice)
        //self.totalAmountLbl.text = "$" + newvalue
        
        //self.ticketsPriceLbl.text = notic + "*" + price
        
        
        
        showWaitOverlay()
        Parsing().DiscoverTicketCalculation(UserId: userId, Ticket_Price: prnew, NoOfTicket: Int(notic))
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverticketCalAction), name: NSNotification.Name(rawValue: "DiscoverTicketCalculation"), object: nil)
        
        
//        self.convenceFeeLbl.text = "$" + confee
//        self.taxLbl.text = "$" + tax
//
//        var conf = Int()
//        conf = Int(confee)!
//
//        var taxf = Int()
//        taxf = Int(tax)!
        
//        var totalprice = Float()
//        totalprice = ticprice+conf+taxf
//        var tlprice = String()
//        tlprice = String(totalprice)
//
//        tlamnt = Float(tlprice)
//        self.totalAmountLbl.text = "$" + tlprice
        
        
        PaymnetBtn.layer.cornerRadius = 25
        // Do any additional setup after loading the view.
    }
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func paymentBtnAction(_ sender: Any) {
        if customerId == "" {
        let defaults = UserDefaults.standard
        defaults.set(ticprice, forKey: "TLPrice")
        defaults.set(totalpr, forKey: "SingleTicPrice")
        defaults.set(processAmout, forKey: "PRFEE")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "StripePaymentViewController") as! StripePaymentViewController
        navigationController?.pushViewController(vc, animated: true)
        }else {
            let defaults = UserDefaults.standard
            defaults.set(ticprice, forKey: "TLPrice")
            defaults.set(totalpr, forKey: "SingleTicPrice")
            defaults.set(processAmout, forKey: "PRFEE")
            defaults.synchronize()
            let vc = storyboard?.instantiateViewController(withIdentifier: "CardListViewController") as! CardListViewController
            navigationController?.pushViewController(vc, animated: true)
          
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
