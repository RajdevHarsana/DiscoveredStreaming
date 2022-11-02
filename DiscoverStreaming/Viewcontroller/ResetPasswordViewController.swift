//
//  ResetPasswordViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 26/06/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class ResetPasswordViewController: BaseViewController {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var newpasswordTxt: FloatLabelTextField!
    @IBOutlet weak var confirmPasswordTxt: FloatLabelTextField!
    
    var str_newpassword: NSString!
    var str_confirmnewpassword: NSString!
    var UserId: Int!
    var defaults:UserDefaults!
    
    @objc func DiscoverResetPassword(_ notification: Notification) {
        
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
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(vc, animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverResetPasswordNotification"), object: nil)
                self.removeAllOverlays()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        UserId = defaults.integer(forKey: "UserIDGet")
        submitBtn.layer.cornerRadius = 25
        newpasswordTxt.delegate = self
        confirmPasswordTxt.delegate = self
        newpasswordTxt.attributedPlaceholder = NSAttributedString(string:"New Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        confirmPasswordTxt.attributedPlaceholder = NSAttributedString(string:"Confirm Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        // Do any additional setup after loading the view.
    }
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnaction(_ sender: Any) {
        str_newpassword = newpasswordTxt.text! as NSString
        str_confirmnewpassword = confirmPasswordTxt.text! as NSString
        
         if str_newpassword .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter New Password",
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
           //  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Enter New Password" , buttonTitle: "OK")
         }else if str_confirmnewpassword .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Confirm New Password",
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
           //  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Enter Confirm New Password" , buttonTitle: "OK")
         }else if str_newpassword.length < 6 {
            let test =  SwiftToast(
                text: "Password is too short",
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
         else if (str_newpassword != str_confirmnewpassword) {
            let test =  SwiftToast(
                text: "Password Are Not Matched",
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
          //  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Password Are Not Matched" , buttonTitle: "OK")
         }else {
             if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().DiscoverResetPassword(UserId: UserId, NewPassword: str_newpassword as String?)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverResetPasswordNotification"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverResetPassword), name: NSNotification.Name(rawValue: "DiscoverResetPasswordNotification"), object: nil)
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
