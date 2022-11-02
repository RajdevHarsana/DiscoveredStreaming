//
//  CardListViewController.swift
//  DiscoverStreaming
//
//  Created by Ashish Soni on 06/04/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class CardListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var cradlistTableview: UITableView!
    var defaults:UserDefaults!
    var userId:Int!
    var customerId:String!
    var response = NSMutableArray()
    var email:String!
    var name:String!
    var tickno:String!
    var eventid:Int!
    var strAmount = String()
    var ticId:Int!
    var cardToken:String!
    var accountId:String!
    var cardid:String!
    var singleTic:String!
    var processingFee:String!
    var TotalAmount:Float!
//    (user_Id:Int!,package_id:Int!,package_type:String!,package_for:String!,package_for_id:Int!,Amount:String,Currency:String!,CardId:String!,CustomerId:String!)
    @IBOutlet weak var addcardBtn: UIButton!
    var packageId:Int!
    var packageType:String!
    var packageFor:String!
    var packageForID:Int!
    
    @objc func DiscoverCardListAction(_ notification: Notification) {
           
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
                   self.cradlistTableview.reloadData()
                   self.removeAllOverlays()
               }
               else{
                   
                   self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                   print("response: \(self.response)")
                   self.cradlistTableview.reloadData()
                   self.addcardBtn.isHidden = false
                  
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCardList"), object: nil)
                   self.removeAllOverlays()
                   
               }
           }
       }
    
    
    @objc func DiscoverTicketPaymentAction(_ notification: Notification) {
        
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
                var response = NSMutableArray()
                response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(response)")
                
//                self.ticId = response.value(forKey: "id") as? Int
//                let deafults = UserDefaults.standard
//                deafults.setValue(self.ticId, forKey: "TicID")
//                deafults.synchronize()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyTicketsViewController") as! MyTicketsViewController
                self.navigationController?.pushViewController(vc, animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverBookTickets"), object: nil)
                self.removeAllOverlays()
                
            }
        }
    }
    
    @objc func DiscoverAllPaymentAction(_ notification: Notification) {
            
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
                    var response = NSMutableArray()
                    response = (notification.userInfo?["data"] as? NSMutableArray)!
                    print("response: \(response)")
                    
    //                self.ticId = response.value(forKey: "id") as? Int
    //                let deafults = UserDefaults.standard
    //                deafults.setValue(self.ticId, forKey: "TicID")
    //                deafults.synchronize()
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAllPaymentsPackage"), object: nil)
                    self.removeAllOverlays()
                    
                }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        customerId = defaults.value(forKey: "CUSTOMERID") as? String
        TotalAmount = defaults.float(forKey: "TLPrice")
        defaults.removeObject(forKey: "PackageFor")
        defaults.removeObject(forKey: "Package_Id")
        defaults.removeObject(forKey: "Package_Type")
        defaults.removeObject(forKey: "PackageForId")
    
        addcardBtn.layer.cornerRadius = 5
        addcardBtn.layer.borderColor = UIColor.white.cgColor
        addcardBtn.layer.borderWidth =  1.5
        addcardBtn.isHidden = true
        
        email = defaults.value(forKey: "BookEmail") as? String
        if email ==  nil {
            email = "miya@getnada.com"
        }else {
             email = defaults.value(forKey: "BookEmail") as? String
        }
        name = defaults.value(forKey: "BookName") as? String
        if name == nil {
            name = "Ashish"
        }else {
            name = defaults.value(forKey: "BookName") as? String
        }
        
        tickno = defaults.value(forKey: "TICNo") as? String
        eventid = defaults.integer(forKey: "EveId")
        userId = defaults.integer(forKey: "UserIDGet")
        customerId = defaults.value(forKey: "CUSTOMERID") as? String
        accountId = defaults.value(forKey: "ACCOUNTID") as? String
        singleTic = defaults.value(forKey: "SingleTicPrice") as? String
        processingFee = defaults.value(forKey: "PRFEE") as? String
        strAmount =  String(format: "%.02f",TotalAmount!)
        packageId = defaults.integer(forKey: "Package_Id") as? Int ?? 0
        packageType = defaults.string(forKey: "Package_Type") as? String ?? ""
        packageFor = defaults.string(forKey: "PackageFor") as? String ?? ""
        packageForID = defaults.integer(forKey: "PackageForId") as? Int ?? 0
        
        showWaitOverlay()
        Parsing().DiscoverCardList(UserId: userId, Customer_Id: customerId)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCardList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverCardListAction), name: NSNotification.Name(rawValue: "DiscoverCardList"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addCardBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StripePaymentViewController") as! StripePaymentViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//           var numOfSections: Int = 0
//           if response.count>0
//           {
//               tableView.separatorStyle = .none
//               numOfSections            = 1
//               tableView.backgroundView = nil
//           }
//           else
//           {
//               let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
//               noDataLabel.text          = "No Card Available."
//
//               noDataLabel.textColor     = UIColor.white
//               noDataLabel.textAlignment = .center
//               tableView.backgroundView  = noDataLabel
//               tableView.separatorStyle  = .none
//           }
//           return numOfSections
//       }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CardlistCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        
        //var cardNumber:String!
        //cardNumber = dict.value(forKey: "last4") as? String
        
        cell.cardNumberLbl.text = dict.value(forKey: "last4") as? String
        var cardexpY:Int!
        cardexpY = dict.value(forKey: "exp_year") as? Int
        
        var cardexpM:Int!
        cardexpM = dict.value(forKey: "exp_month") as? Int
        
        var expY:String!
        expY = String(cardexpY)
        
        var expM:String!
        expM = String(cardexpM)
        cell.bankNameLbl.text = "Expire Date:" + expM + "/" + expY
        
        var brand:String!
        brand = dict.value(forKey: "brand") as? String
        
        if brand == "MasterCard" {
            cell.cardImage.image = UIImage(named: "mastercard")
        }else if brand == "Visa" {
            cell.cardImage.image = UIImage(named: "visa")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            var dict = NSDictionary()
            dict = response.object(at: indexPath.row) as! NSDictionary
       
            cardid = dict.value(forKey: "card_id") as? String
        
            var Tict = Int()
            Tict = Int(tickno)!
            var SingleTict = Float()
            SingleTict = Float(singleTic)!
            
            var proFee = Float()
            proFee = Float(processingFee)!
        if packageFor != "" {
            
            if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().DiscoverAllPaymentsPackage(user_Id: userId, package_id: packageId, package_type: packageType, package_for: packageFor, package_for_id: packageForID, Amount: strAmount, Currency: "USD", CardId: cardid, CustomerId: customerId)
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverAllPaymentsPackage"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(DiscoverAllPaymentAction(_:)), name: NSNotification.Name(rawValue: "DiscoverAllPaymentsPackage"), object: nil)
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
            
            
        }else{
        
            
            if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().DiscoverBookTickets(Email: email, Name: name, user_Id: userId, Event_Id: eventid, NoOfTickets: Tict, Amount: strAmount, SingleTicketNumber: singleTic, ProcessingFee: processingFee, Currency: "USD", CardId: cardid, CustomerId: customerId, AccountId: accountId)
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverBookTickets"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverTicketPaymentAction), name: NSNotification.Name(rawValue: "DiscoverBookTickets"), object: nil)
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
        }
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
