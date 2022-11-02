//
//  ForgotVerificationViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 26/06/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class ForgotVerificationViewController: BaseViewController,VPMOTPViewDelegate {

    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var otpview: VPMOTPView!
    
    var GetotpString = String()
    var GetComeOtp = String()
    var defaults: UserDefaults!
    var user_Id: Int!
    var str_email:String!
    
    @objc func Discoverotp(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
             //   SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
                
            }
            else {
               
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
                self.navigationController?.pushViewController(vc, animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverForgotOtp"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    //MARK:- ResendOTP WebService
    @objc func ResendOTPAction(_ notification: Notification) {
        
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
               // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
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
                self.removeAllOverlays()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetComeOtp = "00000"
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        str_email = defaults.value(forKey: "Forgotemail") as? String
        continueBtn.layer.cornerRadius = 25
        
        otpview.otpFieldsCount = 4
        otpview.delegate = self
        // Create the UI
        otpview.initalizeUI()


        // Do any additional setup after loading the view.
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        GetotpString = otpString
        print("OTPString: \(otpString)")
    }
    
    func hasEnteredAllOTP(hasEntered: Bool) {
        print("Has entered all OTP? \(hasEntered)")
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func continueBtnAction(_ sender: Any) {
        if !GetotpString.isEmpty {
            if Reachability.isConnectedToNetwork() == true {
                showWaitOverlay()
                Parsing().DiscoverForgotOtp(UserId: user_Id, OTP: GetotpString)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverForgotOtp"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.Discoverotp), name: NSNotification.Name(rawValue: "DiscoverForgotOtp"), object: nil)
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
               // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Internet Connection not Available!" , buttonTitle: "OK")
            }
        }else {
            let test =  SwiftToast(
                text: "Please Enter OTP",
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
           // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Please Enter OTP" , buttonTitle: "OK")
        }
    }
    @IBAction func resendBtnAction(_ sender: Any) {
        showWaitOverlay()
        Parsing().DiscoverResendForgototp(Email: str_email)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ResendOTPAction), name: NSNotification.Name(rawValue: "DiscoverResendForgototpNotification"), object: nil)
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
