//
//  LoginViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 26/06/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import TwitterCore
import TwitterKit
import SwiftToast

class LoginViewController: BaseViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailAddressTxt: FloatLabelTextField!
    @IBOutlet weak var passwordTxt: FloatLabelTextField!
    @IBOutlet weak var chrckBtn: UIButton!
    var str_email = NSString()
    var str_passwors = NSString()
    var str_deviceid:NSString!
    var str_devicetype = "1"
    
    var deafults:UserDefaults!
    var UserIDGet: Int!
    var verifiedstatus:Int!
    
    var str_fbname : NSString!
    var str_fbpass : NSString!
    var str_fbemail : NSString!
    var Dic_img : NSDictionary!
    var Dic_imgData : NSDictionary!
    var str_fbimage : NSString!
    var str_fbid : NSString!
    var str_FName : NSString!
    var str_LName : NSString!
    var dict : [String : AnyObject]!
    var emailR:String!
    var firstname:String!
    var str_image:String!
    var isclick: Bool = false
    var user_name:String!
    var user_email:String!
    var user_profile:String!
    
    var rememberMe: Bool = false
    

    
    //MARK:- Login WebService
    @objc func DiscoverLoginAction(_ notification: Notification) {
        
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
                var response = NSMutableDictionary()
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                print("response: \(response)")
                
                
                self.UserIDGet = response.value(forKey: "user_id") as? Int
                self.verifiedstatus = response.value(forKey: "verified_status") as? Int
                self.user_name = response.value(forKey: "full_name") as? String
                self.user_email = response.value(forKey: "email") as? String
                self.user_profile  = response.value(forKey: "profile_picture") as? String
                
                let deafults = UserDefaults.standard
                deafults.set(self.UserIDGet, forKey: "UserIDGet")
                deafults.setValue(self.user_name, forKey: "FullName")
                deafults.setValue(self.user_email, forKey: "Forgotemail")
                deafults.setValue(self.user_profile, forKey: "User_pic")
                deafults.synchronize()
                self.removeAllOverlays()
                
                if self.verifiedstatus == 1 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
                    self.navigationController?.pushViewController(vc, animated: false)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverLoginNotification"), object: nil)
                    
                }
                else if self.verifiedstatus == 2 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileSetUpViewController") as! ProfileSetUpViewController
                    self.navigationController?.pushViewController(vc, animated: false)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverLoginNotification"), object: nil)
                }else {
                    
                    if self.rememberMe == true{
                        let defaults = UserDefaults.standard
                        deafults.set("yes", forKey: "isRemember")
                        defaults.set(self.emailAddressTxt.text!, forKey: "user_email")
                        defaults.set(self.passwordTxt.text!, forKey: "user_password")
                       
                    }else{
                        deafults.set("no", forKey: "isRemember")
                        
                    }
                    
                    let deafults = UserDefaults.standard
                    deafults.set("1", forKey: "Logoutstatus")
                    deafults.synchronize()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                    self.navigationController?.pushViewController(vc!, animated: true)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverLoginNotification"), object: nil)
                }
                
            }
        }
    }
    
    //MARK:- facebookLogin WebService
    @objc func facebookLoginAction(_ notification: Notification) {
        
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
                
                self.UserIDGet = response.value(forKey: "userID") as? Int
                let deafults = UserDefaults.standard
                deafults.set(self.UserIDGet, forKey: "UserIDGet")
                
                deafults.synchronize()
                
                let deafult = UserDefaults.standard
                deafult.set("1", forKey: "Logoutstatus")
                deafult.synchronize()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                self.navigationController?.pushViewController(vc!, animated: true)
                self.removeAllOverlays()
            }
        }
    }
    
    //MARK:- facebookLogin WebService
    @objc func TwitterLoginAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else{
                var response = NSDictionary()
                response = (notification.userInfo?["response"] as? NSDictionary)!
                print("response: \(response)")
                
                self.UserIDGet = response.value(forKey: "userID") as? Int
                let deafults = UserDefaults.standard
                deafults.set(self.UserIDGet, forKey: "UserIDGet")
                
                deafults.synchronize()
                
                let deafult = UserDefaults.standard
                deafult.set("1", forKey: "Logoutstatus")
                deafult.synchronize()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                self.navigationController?.pushViewController(vc!, animated: true)
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deafults = UserDefaults.standard
        str_deviceid = deafults.value(forKey: "Devicetoken") as? NSString
        loginBtn.layer.cornerRadius = 27
        self.emailAddressTxt.delegate = self
        self.passwordTxt.delegate = self
        emailAddressTxt.attributedPlaceholder = NSAttributedString(string:"Email Address", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTxt.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        if let is_remember = deafults.value(forKey: "isRemember") as? String{
            
            if is_remember == "yes"{
                
                let user_email = deafults.value(forKey: "user_email")
                let user_password = deafults.value(forKey: "user_password")
                
                self.emailAddressTxt.text = user_email as? String
                self.passwordTxt.text = user_password as? String
                self.chrckBtn.isSelected = true
                
                chrckBtn.setImage(UIImage(named: "checkbox_1"), for: .normal)
                self.rememberMe = true
            }
            
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func forgotpasswordBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func loginBtnAction(_ sender: Any) {
        str_email = emailAddressTxt.text! as NSString
        str_passwors = passwordTxt.text! as NSString
        if str_email .isEqual(to: "") {
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
        }else if str_passwors .isEqual(to: "") {
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
           // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Enter Password" , buttonTitle: "OK")
        }else {
              if isValidEmail(str_email as String){
            if Reachability.isConnectedToNetwork() == true {
                showWaitOverlay()
                Parsing().DiscoverLogin(Email: str_email as String, Password: str_passwors as String, DeviceId: str_deviceid as String, DeviceType: str_devicetype)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverLoginNotification"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverLoginAction), name: NSNotification.Name(rawValue: "DiscoverLoginNotification"), object: nil)
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
                 //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Please Enter Correct Email Id" , buttonTitle: "OK")
            }
        }
        
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    @IBAction func twitterBtnAction(_ sender: Any) {
//        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
//            if (session != nil) {
//                let user_id = session?.userID
//
//                // DELEGATE.dicSocialSignUpData.setValue(String(user_id!), forKey: "socialId")
//                let socialid = user_id!
//                let client = TWTRAPIClient.withCurrentUser()
//                client.loadUser(withID: user_id!, completion: { (user, error) in
//                    if user != nil
//                    {
//                        print(user as Any)
//                        let name = user!.name
//                        print(name)
//                        if name.contains(" "){
//                            let seprated_name = name.components(separatedBy: " ")
//                            self.firstname = seprated_name[0]
//                            let lastname = seprated_name[1]
//                            print(self.firstname!)
//                            print(lastname)
////                            Config().AppUserDefaults.setValue(firstname, forKey: "social_first_name")
////                            Config().AppUserDefaults.setValue(lastname, forKey: "social_last_name")
//
//                        }else{
//                            let firstname = name
//                          //  Config().AppUserDefaults.setValue(firstname, forKey: "social_first_name")
//
//                        }
//
//                        self.str_image = user!.profileImageURL
//                        print(self.str_image!)
//
//                        //Config().AppUserDefaults.setValue(image, forKey: "social_profile_image")
//
//                    }
//                    client.requestEmail { email, error in
//                        if (email != nil)
//                        {
//                            self.emailR = "(String(describing: email!))"
//
//                          //  Config().AppUserDefaults.setValue(emailR, forKey: "social_email_id")
//
//                        } else
//                        {
//                            print("error: (String(describing: error?.localizedDescription))");
//                        }
//                        let store = TWTRTwitter.sharedInstance().sessionStore
//                        if let userID = store.session()?.userID
//                        {
//                            store.logOutUserID(userID)
//                        }
//                        //  self.socialLogin(social_id: "(String(describing: session?.userName))", social_type: social.twitter.rawValue)
//
//                      //  self.checkSocialExist(type: "twitter", social_id: socialid)
//                        self.showWaitOverlay()
//                        Parsing().TwitterLogin(Email: self.emailR, twitterid: user_id, DeviceID: self.str_deviceid as String, DeviceType: self.str_devicetype, twitterkname: self.firstname, image: self.str_image)
//                         NotificationCenter.default.addObserver(self, selector: #selector(self.TwitterLoginAction), name: NSNotification.Name(rawValue: "twitterloginNotification"), object: nil)
//
//                    }
//                })
//            } else {
//                print("error: \(String(describing: error?.localizedDescription))");
//            }
//        })
//
//         TWTRTwitter.sharedInstance().logIn {(session, error) -> Void in
//         if (session != nil) {
//
//
//
//
//         print(session?.userName as Any)
//         print("signed in as \(String(describing: session?.userName))");
//         UIView.animate(withDuration: 0.0, delay: 3, options: [], animations: {
//
//         }, completion: {(fin) in
//         //self.RootViewWithSideManu(HomeVC())
//         })
//
//         let store = TWTRTwitter.sharedInstance().sessionStore
//         if let userID = store.session()?.userID {
//         store.logOutUserID(userID)
//         self.getUserInfo(userID)
//
//
//         }
//
//         } else {
//         print("error")
//         print("error: \(String(describing: error?.localizedDescription))");
//         }
//         }
//
    }
    
    
    func getUserInfo( _ userID : String){
        let client = TWTRAPIClient(userID: userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/users/show.json"
        let params = ["id": userID]
        var clientError : NSError?
        
        
        
        let request = client.urlRequest(withMethod: "POST", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("json: \(json)")
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
        
        
        
    }
    @IBAction func facceBookBtnAction(_ sender: Any) {
//        let fbLoginManager : LoginManager = LoginManager()
//        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
//            if (error == nil){
//                let fbloginresult : LoginManagerLoginResult = result!
//                if fbloginresult.grantedPermissions != nil {
//                    if(fbloginresult.grantedPermissions.contains("email")) {
//                        if((AccessToken.current) != nil){
//                            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
//                                if (error == nil){
//                                    print(self.dict!)
//
//                                    let userData = result as! NSDictionary
//
//                                    print("userData\(userData)")
//
//                                    self.str_fbname =  userData.object(forKey: "name") as? NSString
//                                    self.str_FName =  userData.object(forKey: "first_name") as? NSString
//                                    self.str_LName =  userData.object(forKey: "last_name") as? NSString
//
//                                    print("str_fbname\(String(describing: self.str_fbname))")
//                                    self.str_fbemail =  userData.object(forKey: "email") as? NSString
//                                    self.str_fbid =  userData.object(forKey: "id") as? NSString
//
//                                    self.Dic_img =  userData.object(forKey: "picture") as? NSDictionary
//                                    self.Dic_imgData = (self.Dic_img.object(forKey: "data") as! NSDictionary)
//                                    self.str_fbimage =  self.Dic_imgData.object(forKey: "url") as? NSString
//                                    let str = String(format:"%@",self.str_fbimage)
//                                    //self.removeAllOverlays()
//                                    self.showWaitOverlay()
//                                    Parsing().FacebookLogin(Email: self.str_fbemail as String?, facebookid: self.str_fbid as String?, DeviceID: self.str_deviceid as String, DeviceType: self.str_devicetype, facebookname: self.str_fbname as String?, image: str as String)
//                                    NotificationCenter.default.addObserver(self, selector: #selector(self.facebookLoginAction), name: NSNotification.Name(rawValue: "facebookloginNotification"), object: nil)
//                                }
//                            })
//                        }
//                    }
//                }
//            }
//        }
    }
    
    @IBAction func dontHaveAccountBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func checkBtnAction(_ sender: UIButton) {
        if sender.isSelected == true {
            self.rememberMe = false
            sender.isSelected = false
             chrckBtn.setImage(UIImage(named: "checkbox"), for: .normal)
            
            
        }else{
            chrckBtn.setImage(UIImage(named: "checkbox_1"), for: .normal)
            self.rememberMe = true
            sender.isSelected = true
            
        }
    }
    
 
}
