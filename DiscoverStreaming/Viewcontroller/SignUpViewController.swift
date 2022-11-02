//
//  SignUpViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 26/06/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class SignUpViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signupScrollview: UIScrollView!
    
    @IBOutlet weak var fullnameTxt: FloatLabelTextField!
    @IBOutlet weak var referalCodeTxt: FloatLabelTextField!
    @IBOutlet weak var emailAddressTxt: FloatLabelTextField!
    @IBOutlet weak var passwordTxt: FloatLabelTextField!
    @IBOutlet weak var confirmPaswordTxt: FloatLabelTextField!
    @IBOutlet weak var checkBtn: UIButton!
    
    var deafults:UserDefaults!
    var isclick: Bool = false
    var termndCondition = NSString()
    var str_devicetype = "1"
    var str_deviceid: NSString!
    var str_Fullname:NSString!
    var str_emailAddress:NSString!
    var str_Referalcode:NSString!
    var str_password:NSString!
    var str_confirmpassword:NSString!
    
    var userId:Int!
    var Stremail:NSString!
    var fullname:String!
    
    
    @objc func DiscoverResgistration(_ notification: Notification) {
        
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
                var response = NSDictionary()
                response = (notification.userInfo?["response"] as? NSDictionary)!
                print("response: \(response)")
                
                
                self.userId = response.value(forKey: "userID") as? Int
                self.Stremail = response.value(forKey: "email") as? NSString
                self.fullname = response.value(forKey: "full_name") as? String
                let deafults = UserDefaults.standard
                deafults.set(nil, forKey: "Logoutstatus")
                deafults.set(self.userId, forKey: "UserIDGet")
                deafults.set(self.Stremail, forKey: "Forgotemail")
                deafults.set(self.fullname, forKey: "FullName")
                deafults.synchronize()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
                self.navigationController?.pushViewController(vc, animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSignUpNotification"), object: nil)
                
                self.removeAllOverlays()
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deafults = UserDefaults.standard
        str_deviceid = deafults.string(forKey: "Devicetoken")! as NSString
        signUpBtn.layer.cornerRadius = 25
        termndCondition = "No"
        fullnameTxt.delegate = self
        referalCodeTxt.delegate = self
        emailAddressTxt.delegate = self
        passwordTxt.delegate = self
        confirmPaswordTxt.delegate = self
        fullnameTxt.attributedPlaceholder = NSAttributedString(string:"Full Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        referalCodeTxt.attributedPlaceholder = NSAttributedString(string:"Referal Code", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        emailAddressTxt.attributedPlaceholder = NSAttributedString(string:"Email Address", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTxt.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        confirmPaswordTxt.attributedPlaceholder = NSAttributedString(string:"Confirm Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("signUpReset"), object: nil)

        // Do any additional setup after loading the view.
    }
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        self.fullnameTxt.text = ""
        self.emailAddressTxt.text = ""
        self.confirmPaswordTxt.text = ""
        self.passwordTxt.text = ""
        self.referalCodeTxt.text = ""
        checkBtn.setImage(UIImage(named: "checkbox"), for: .normal)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return  validate(string: newString)
    }
    func validate(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }
    
    func validate(whiteSpaceString: String) -> Bool {
        return whiteSpaceString.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        str_Fullname = fullnameTxt.text! as NSString
        str_Referalcode = referalCodeTxt.text! as NSString
        str_emailAddress = emailAddressTxt.text! as NSString
        str_password = passwordTxt.text! as NSString
        str_confirmpassword = confirmPaswordTxt.text! as NSString
        
        
        if str_Fullname .isEqual(to: "") {
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
        }else if str_emailAddress .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Email",
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
           //  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Enter Email" , buttonTitle: "OK")
        }else  if str_password .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Password",
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
          //  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Enter Password" , buttonTitle: "OK")
        }else  if str_confirmpassword .isEqual(to: "") {
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
           // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Enter Confirm Password" , buttonTitle: "OK")
        } else if str_password.length < 6 {
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
        }else if (str_password != str_confirmpassword) {
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
          // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Password Are Not Matched" , buttonTitle: "OK")
        }
        else if termndCondition .isEqual(to: "No") {
            let test =  SwiftToast(
                text: "Please Accept terms & conditions",
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
            // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Please Accept terms & conditions" , buttonTitle: "OK")
        }else {
            if isValidEmail(str_emailAddress as String){
                if Reachability.isConnectedToNetwork() == true {
                    showWaitOverlay()
                    Parsing().DiscoverSignup(Email: str_emailAddress as String?, Password: str_password as String?, FullName: str_Fullname as String?, DeviceType: str_devicetype, DeviceId: str_deviceid as String?, ReferalCode: str_Referalcode as String?)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverSignUpNotification"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverResgistration), name: NSNotification.Name(rawValue: "DiscoverSignUpNotification"), object: nil)
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
                   //  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Internet Connection not Available!" , buttonTitle: "OK")
                }
            }else {
                let test =  SwiftToast(
                    text: "Please Enter Correct Email Id",
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
                // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Please Enter Correct Email Id" , buttonTitle: "OK")
            }
        }
       
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //END
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
   
    
    override func viewDidLayoutSubviews() {
        signupScrollview.isScrollEnabled = true
        signupScrollview.contentSize = CGSize(width: self.view.frame.size.width, height: 600)
    }
    @IBAction func checkBtnAction(_ sender: Any) {
        if (!isclick){
            checkBtn.setImage(UIImage(named: "checkbox_1"), for: .normal)
            isclick=true
            termndCondition = "yes"
        }
        else
        {
            checkBtn.setImage(UIImage(named: "checkbox"), for: .normal)
            isclick=false
            termndCondition = "No"
        }
    }
    @IBAction func alreadyHaveAccountAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
