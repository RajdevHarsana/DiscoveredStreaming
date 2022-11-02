//
//  StripePaymentViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 17/01/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import Stripe
import SwiftToast

class StripePaymentViewController: UIViewController,STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var cardnumber: UIImageView!
    
    var cardtextfield:STPPaymentCardTextField!
     var isclick: Bool = false
    @IBOutlet weak var checkBtn: UIButton!
    var userId:Int!
    var PlanId:Int!
    var TotalAmount:Float!
    var defaults:UserDefaults!
    var str_cardNumber:NSString!
    var str_cardcvv:NSString!
    var str_cardexpmonth:NSString!
    var str_cardexpyear:NSString!
    var RequestUser_id:Int!
    var email:String!
    var name:String!
    var tickno:String!
    var userid:Int!
    var eventid:Int!
    var strAmount = String()
    var ticId:Int!
    var customerId:String!
    var cardToken:String!
    var accountId:String!
    var cardid:String!
    var singleTic:String!
    var processingFee:String!
    @objc func DiscoverPaymentAction(_ notification: Notification) {
        
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
                var response = NSMutableArray()
                response = DataManager.getVal(notification.userInfo?["data"]) as? NSMutableArray ?? []
                let dict = DataManager.getVal(response[0]) as! NSDictionary
                let id_new = DataManager.getVal(dict["id"]) as? String ?? ""
                print(id_new)
                
                self.ticId = Int(id_new)
                let deafults = UserDefaults.standard
                deafults.setValue(self.ticId, forKey: "TicID")
                deafults.synchronize()
                let defaults = UserDefaults.standard
                defaults.setValue("Sequal", forKey: "NewChange")
                defaults.synchronize()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TicketQRCodeViewController") as! TicketQRCodeViewController
                self.navigationController?.pushViewController(vc, animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverBookTickets"), object: nil)
                self.removeAllOverlays()
                
            }
        }
    }
    
    @objc func DiscoverSaveCardAction(_ notification: Notification) {
           
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
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSaveCard"), object: nil)
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
                   var response = NSDictionary()
                   response = (notification.userInfo?["data"] as? NSDictionary)!
                   self.customerId = response.value(forKey: "customer_id") as? String
                   self.cardid = response.value(forKey: "card_id") as? String
                   let defaults = UserDefaults.standard
                   defaults.setValue(self.customerId, forKey: "CUSTOMERID")
                   defaults.synchronize()
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSaveCard"), object: nil)
                   self.removeAllOverlays()
                   
               }
           }
       }
    
    
    @objc func DiscoverGetCardTokenAction(_ notification: Notification) {
              
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
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverGetCardToken"), object: nil)
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
                      self.cardid = (notification.userInfo?["data"] as? String)!
                      NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverGetCardToken"), object: nil)
                      self.removeAllOverlays()
                      
                  }
              }
          }
       
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        TotalAmount = defaults.float(forKey: "TLPrice")
        email = defaults.value(forKey: "email") as? String
        name = defaults.value(forKey: "full_name") as? String
        tickno = defaults.value(forKey: "TICNo") as? String
        eventid = defaults.integer(forKey: "EveId")
        userId = defaults.integer(forKey: "UserIDGet")
        customerId = defaults.value(forKey: "CUSTOMERID") as? String
        accountId = defaults.value(forKey: "ACCOUNTID") as? String
        singleTic = defaults.value(forKey: "SingleTicPrice") as? String
        processingFee = defaults.value(forKey: "PRFEE") as? String
        strAmount =  String(format: "%.02f",TotalAmount!)
        payBtn.layer.cornerRadius = 25
        payBtn.setTitle("PAY" + " " + "$" + strAmount, for: .normal)
        cardnumber.isHidden = true
        stripeMethod()
        // Do any additional setup after loading the view.
    }
    
    func stripeMethod() {
        let paymentTextField = STPPaymentCardTextField()
        let cardParams = STPPaymentMethodCardParams()
        // Only successful 3D Secure transactions on this test card will succeed.
        //cardParams.number = @"4000000000003063";
        //cardParams.cvc = @"232";
        paymentTextField.cardParams = cardParams
        paymentTextField.delegate = self
        paymentTextField.cursorColor = UIColor.yellow
        paymentTextField.textColor = UIColor.white
        cardtextfield = paymentTextField
        cardtextfield.layer.borderColor = UIColor.white.cgColor
       // self.cardnumber.addSubview(paymentTextField)
        self.view.addSubview(paymentTextField)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 11
        let width: CGFloat = view.frame.width - (padding * 4.2)
        cardtextfield.frame = CGRect(x: padding * 2, y: 150, width: width, height: 50)
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        payBtn.isEnabled = textField.isValid
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func checkBtnAction(_ sender: Any) {
        checkBtn.isSelected = !checkBtn.isSelected
        if checkBtn.isSelected == true{
          
            str_cardNumber = cardtextfield.cardNumber! as NSString
            str_cardcvv = cardtextfield.cardParams.cvc! as NSString
            str_cardexpyear = cardtextfield.cardParams.expYear?.stringValue as? NSString
            str_cardexpmonth = cardtextfield.cardParams.expMonth?.stringValue as? NSString
            
            if str_cardNumber .isEqual(to: "") {
                       let test =  SwiftToast(
                           text: "Enter card Number",
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
                       
                   }else if str_cardcvv .isEqual(to: "") {
                       let test =  SwiftToast(
                           text: "Enter card CVV",
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
                      
                   }else if str_cardexpmonth .isEqual(to: "") {
                       let test =  SwiftToast(
                           text: "Enter card expire month",
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
                       
                   }else if str_cardexpyear .isEqual(to: "") {
                       let test =  SwiftToast(
                           text: "Enter card expire year",
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
                       
                }else {
                 checkBtn.setImage(UIImage(named: "checkbox_1"), for: .normal)
                showWaitOverlay()
                Parsing().DiscoverSaveCard(UserId: userId, Customer_Id: customerId, CardNumber: str_cardNumber as String?, CardExpYear: str_cardexpyear as String?, CardExpMonth: str_cardexpmonth as String?, CardCVV: str_cardcvv as String?)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSaveCard"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSaveCardAction), name: NSNotification.Name(rawValue: "DiscoverSaveCard"), object: nil)
             }
            
            
           isclick=true
           
            
       }
       else
       {
       
        str_cardNumber = cardtextfield.cardNumber! as NSString
        str_cardcvv = cardtextfield.cardParams.cvc! as NSString
        str_cardexpyear = cardtextfield.cardParams.expYear?.stringValue as? NSString
        str_cardexpmonth = cardtextfield.cardParams.expMonth?.stringValue as? NSString
                  
        if str_cardNumber .isEqual(to: "") {
          let test =  SwiftToast(
              text: "Enter card Number",
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
                  
      }else if str_cardcvv .isEqual(to: "") {
          let test =  SwiftToast(
              text: "Enter card CVV",
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
                 
              }else if str_cardexpmonth .isEqual(to: "") {
                  let test =  SwiftToast(
                      text: "Enter card expire month",
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
                  
              }else if str_cardexpyear .isEqual(to: "") {
                  let test =  SwiftToast(
                      text: "Enter card expire year",
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
                  
           }else {
             checkBtn.setImage(UIImage(named: "checkbox"), for: .normal)
            showWaitOverlay()
           Parsing().DiscoverGetCardToken(UserId: userId, CardNumber: str_cardNumber as String?, CardExpYear: str_cardexpyear as String?, CardExpMonth: str_cardexpmonth as String?, CardCVV: str_cardcvv as String?)
           NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverGetCardToken"), object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverGetCardTokenAction), name: NSNotification.Name(rawValue: "DiscoverGetCardToken"), object: nil)
        }
        
       
           isclick=false
       }
    }
    
    @IBAction func payBtnAction(_ sender: Any) {
        str_cardNumber = cardtextfield.cardNumber! as NSString
        str_cardcvv = cardtextfield.cardParams.cvc! as NSString
        str_cardexpyear = cardtextfield.cardParams.expYear?.stringValue as? NSString
        str_cardexpmonth = cardtextfield.cardParams.expMonth?.stringValue as? NSString
        
        if str_cardNumber .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Enter card Number",
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
            
        }else if str_cardcvv .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Enter card CVV",
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
           
        }else if str_cardexpmonth .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Enter card expire month",
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
            
        }else if str_cardexpyear .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Enter card expire year",
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
            
        }else {
            var Tict = Int()
            Tict = Int(tickno)!
            var SingleTict = Float()
            SingleTict = Float(singleTic)!
            
            var proFee = Float()
            proFee = Float(processingFee)!
            
            if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().DiscoverBookTickets(Email: email, Name: name, user_Id: userId, Event_Id: eventid, NoOfTickets: Tict, Amount: strAmount, SingleTicketNumber: singleTic, ProcessingFee: processingFee, Currency: "USD", CardId: cardid, CustomerId: customerId, AccountId: accountId)
                
//                DiscoverBookTickets(Email: email, Name: name, user_Id: userId, Event_Id: eventid, NoOfTickets: Tict, Amount: strAmount, CardNumber: str_cardNumber as String?, CardCvv: str_cardcvv as String?, CardExpMonth: str_cardexpmonth as String?, CardExpYear: str_cardexpyear as String?, Currency: "USD")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverBookTickets"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverPaymentAction), name: NSNotification.Name(rawValue: "DiscoverBookTickets"), object: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
