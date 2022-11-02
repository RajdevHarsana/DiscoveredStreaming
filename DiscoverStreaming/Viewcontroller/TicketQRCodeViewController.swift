//
//  TicketQRCodeViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//


import UIKit
import SwiftToast

class TicketQRCodeViewController: UIViewController {

    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var EventNametitle: UILabel!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var dateTimeBtn: UIButton!
    @IBOutlet weak var qrImage: UIImageView!
   // @IBOutlet weak var ticketsLbl: UILabel!
    @IBOutlet weak var ticketpriceLbl: UILabel!
   // @IBOutlet weak var convenceFeeLbl: UILabel!
    //@IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var downLoadBtrn: UIButton!
    @IBOutlet weak var processingFeeLbl: UILabel!
    @IBOutlet weak var totalAmntLbl: UILabel!
    
    var userid:Int!
    var ticketId:Int!
    var defaults:UserDefaults!
    
    @objc func DiscoverTicketDetailAction(_ notification: Notification) {
        
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
                //  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else{
                var response = NSMutableDictionary()
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                print("response: \(response)")
                self.eventNameLbl.text = response.value(forKey: "name") as? String
                self.venueNameLbl.text = response.value(forKey: "venue_name") as? String
                var address:String!
                address = response.value(forKey: "address") as? String
                var City:String!
                City = response.value(forKey: "city") as? String
                var State:String!
                State = response.value(forKey: "state") as? String
                self.addressLbl.text = address + " " + City + " " + State
                var date:String!
                date = response.value(forKey: "event_date") as? String
                var Time:String!
                Time = response.value(forKey: "event_time") as? String
                self.dateTimeBtn.setTitle(date + " " + Time, for: .normal)
                self.EventNametitle.text = response.value(forKey: "name") as? String
                var Notic:Int!
                Notic = response.value(forKey: "no_of_ticket") as? Int
                var ticno = String()
                ticno = String(Notic)
              //  self.ticketsLbl.text = ticno + " " + "Tickets"
               // var Amount:NSNumber!
               // Amount = response.value(forKey: "amount") as? NSNumber

                self.totalAmountLbl.text = response.value(forKey: "ticket_no") as? String
                
                var pirceper:CGFloat!
                pirceper = response.value(forKey: "price_per_sit") as? CGFloat
               
                var ticAmount:Int!
                ticAmount =  response.value(forKey: "price_per_sit") as? Int
                
                
                var fl = CGFloat()
                fl =  CGFloat(Notic)
               
                var Ntic = Float()
                Ntic = Float(pirceper*fl)
               // ticnew = pirceper.intValue*Notic
                var ti = String()
                ti = String(Ntic)
                self.ticketpriceLbl.text = String("$\(ticAmount ?? 0)")
                
                var confee:Int!
                confee = response.value(forKey: "processing_fee") as? Int
                
                var totalnewam:Int!
                totalnewam = ticAmount + confee
                
                self.totalAmntLbl.text = "$" + String(totalnewam)
                
                self.processingFeeLbl.text = "$" + String(confee)
               // var conf = String()
               // conf = String(confee)
                
               //  self.convenceFeeLbl.text = "$" + confee
                
                var taxfee:String!
                taxfee = response.value(forKey: "tax") as? String
               // var taxf = String()
               // taxf = String(taxfee)
               //  self.taxLbl.text = "$" + taxfee
                self.qrImage.sd_setImage(with: URL(string: (response.value(forKey: "qrcode_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                
                self.removeAllOverlays()
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        userid = defaults.integer(forKey: "UserIDGet")
        ticketId = defaults.integer(forKey: "TicID")
        
        shareBtn.layer.cornerRadius = 5
        shareBtn.layer.borderColor = UIColor.lightGray.cgColor
        shareBtn.layer.borderWidth = 1
        
        downLoadBtrn.layer.cornerRadius = 5
        downLoadBtrn.layer.borderColor = UIColor.lightGray.cgColor
        downLoadBtrn.layer.borderWidth = 1
        
        if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().DiscoverTicketDetail(UserId: userid, TicketID: ticketId)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverTicketDetailAction), name: NSNotification.Name(rawValue: "DiscoverTicketDetail"), object: nil)
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
    @IBAction func backBtnActiobn(_ sender: Any) {
//
//        let datanew = UserDefaults.standard.value(forKey: "NewChange") as? String
//        if datanew == "NonSequal" {
            self.navigationController?.popViewController(animated: true)
//        }else {
//            let navigate = storyboard!.instantiateViewController(withIdentifier: "tabbar")
//            navigationController?.pushViewController(navigate, animated: true)
//        }
       
    }
    
    @IBAction func shareBtnAction(_ sender: Any) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var imagesToShare = [AnyObject]()
        imagesToShare.append(image!)
        
        let activityViewController = UIActivityViewController(activityItems: imagesToShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func downloadBtnAction(_ sender: Any) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var imagesToShare = [AnyObject]()
        imagesToShare.append(image!)
        
        let activityViewController = UIActivityViewController(activityItems: imagesToShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func allshareBtnAction(_ sender: Any) {
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
