//
//  ChangePasswordViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var oldPasswordTxt: FloatLabelTextField!
    @IBOutlet weak var newPasswordTxt: FloatLabelTextField!
    @IBOutlet weak var confirmNewpassword: FloatLabelTextField!
    
    var str_oldpass = NSString()
    var str_newpass = NSString()
    var str_connewpass = NSString()
    
    
    var defaults:UserDefaults!
    var user_id:Int!
    
    @objc func ChangePasswordAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                let test =  SwiftToast(
                    text: str_message,
                    textAlignment: .center,
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
            else {
                let test =  SwiftToast(
                    text: str_message,
                    textAlignment: .center,
                    backgroundColor: .purple,
                    textColor: .white,
                    font: .boldSystemFont(ofSize: 15.0),
                    duration: 2.0,
                    minimumHeight: CGFloat(80.0),
                    aboveStatusBar: false,
                    target: nil,
                    style: .navigationBar)
                self.present(test, animated: true)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                self.navigationController?.pushViewController(vc!, animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverChangePasswordNotification"), object: nil)
                self.removeAllOverlays()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        user_id = defaults.integer(forKey: "UserIDGet")
        updateBtn.layer.cornerRadius = 25

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateBtnAction(_ sender: Any) {
        str_oldpass = oldPasswordTxt.text! as NSString
        str_newpass = newPasswordTxt.text! as NSString
        str_connewpass = confirmNewpassword.text! as NSString
        
        if str_oldpass .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Old Password",
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
            // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Enter Full Name" , buttonTitle: "OK")
        }else if str_newpass .isEqual(to: "") {
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
            // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Enter Full Name" , buttonTitle: "OK")
        } else  if str_connewpass .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Confirm Password",
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
            // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Enter Full Name" , buttonTitle: "OK")
        } else  if (str_newpass != str_connewpass) {
            let test =  SwiftToast(
                text: "Please Enter Full Name",
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
            // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Enter Full Name" , buttonTitle: "OK")
        }else {
            if Reachability.isConnectedToNetwork() == true {
                showWaitOverlay()
                Parsing().DiscoverChangePassword(UserId: user_id, OldPassword: str_oldpass as String, NewPassword: str_newpass as String)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverChangePasswordNotification"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.ChangePasswordAction), name: NSNotification.Name(rawValue: "DiscoverChangePasswordNotification"), object: nil)
                
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
