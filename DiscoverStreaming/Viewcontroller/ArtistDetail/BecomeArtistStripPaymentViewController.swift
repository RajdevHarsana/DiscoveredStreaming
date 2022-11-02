//
//  BecomeArtistStripPaymentViewController.swift
//  DiscoverStreaming
//
//  Created by MAC-27 on 02/09/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import Stripe
import SwiftToast

class BecomeArtistStripPaymentViewController: UIViewController,STPPaymentCardTextFieldDelegate {
    
    @IBOutlet weak var addNowBtn: UIButton!
    @IBOutlet weak var cardnumber: UIImageView!
    
    var cardtextfield:STPPaymentCardTextField!
     var isclick: Bool = false
    @IBOutlet weak var checkBtn: UIButton!
    
    var response = NSMutableDictionary()
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
    var artistid:Int!
    var artistName:String!
    var ArtistUserId:Int!
    var strAmount = String()
    var ticId:Int!
    var customerId:String!
    var cardToken:String!
    var accountId:String!
    var cardid:String!
    var singleTic:String!
    var processingFee:String!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        defaults = UserDefaults.standard
        email = defaults.value(forKey: "email") as? String
        artistid = defaults.integer(forKey: "ARNewID")
        ArtistUserId = defaults.integer(forKey: "user_id")
        artistName = defaults.string(forKey: "nameofAr")
        addNowBtn.layer.cornerRadius = 25
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
//        self.cardnumber.addSubview(paymentTextField)
        self.view.addSubview(paymentTextField)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 11
        let width: CGFloat = view.frame.width - (padding * 4.2)
        cardtextfield.frame = CGRect(x: padding * 2, y: 218, width: width, height: 50)
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        addNowBtn.isEnabled = textField.isValid
    }
    
    @IBAction func skipBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArtistDetailViewController") as! ArtistDetailViewController
        let defaults = UserDefaults.standard
        defaults.set(self.artistid, forKey: "ArtistID")
        defaults.set(self.ArtistUserId, forKey: "ArUserId")
        defaults.set(self.artistName, forKey: "ArName")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addNowBtnAction(_ sender: Any) {
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
                
                if Reachability.isConnectedToNetwork() == true {
                showWaitOverlay()
                let parameterDictionary = NSMutableDictionary()
                  parameterDictionary.setObject(DataManager.getVal(artistid), forKey: "account_type_id" as NSCopying )
                  parameterDictionary.setValue(DataManager.getVal("Artists"), forKey: "account_type")
                  parameterDictionary.setValue(DataManager.getVal(email), forKey: "email")
                  parameterDictionary.setValue(DataManager.getVal(str_cardNumber), forKey: "card[number]")
                  parameterDictionary.setValue(DataManager.getVal(str_cardcvv), forKey: "card[cvc]")
                  parameterDictionary.setValue(DataManager.getVal(str_cardexpmonth), forKey: "card[exp_month]")
                  parameterDictionary.setValue(DataManager.getVal(str_cardexpyear), forKey: "card[exp_year]")
                  parameterDictionary.setValue(DataManager.getVal("usd"), forKey: "card[currency]")
                    
                  print(parameterDictionary)
                  
                  let methodName = "addConnectAccount"
                  
                  DataManager.getpaymentAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                  DispatchQueue.main.async(execute: {
                      let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as? String ?? ""
                      let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as? String ?? ""
                      
                      if status == "0"{
                        let test =  SwiftToast(
                            text: message,
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
                          self.removeAllOverlays()
                      }
                      else{
                        let dict = DataManager.getVal(responseData?.object(forKey: "data")) as! NSDictionary
                        self.accountId = DataManager.getVal(dict["artist_account_id"]) as? String ?? ""
                        
                        let defaults = UserDefaults.standard
                        defaults.set(self.accountId, forKey: "AccountID")
                        defaults.set(self.artistid, forKey: "ArtistID")
                        defaults.set(self.ArtistUserId, forKey: "ArUserId")
                        defaults.set(self.artistName, forKey: "ArName")
                        self.removeAllOverlays()
                      let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                      self.navigationController?.pushViewController(vc, animated: true)
                      self.removeAllOverlays()
                      }
                  })
                }
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

}
