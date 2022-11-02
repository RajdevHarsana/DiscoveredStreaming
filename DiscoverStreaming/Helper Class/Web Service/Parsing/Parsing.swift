//
//  Parsing.swift
//  Receipt Catcher
//
//  Created by tarun-mac-6 on 04/03/19.
//  Copyright © 2019 Tarun Nagar. All rights reserved.
//

import UIKit
import MobileCoreServices
class Parsing: NSObject,URLSessionDelegate {

    //MARK: SignUp API ---- SignUpViewController
    func postRequest(_ postString: String?, request method: String?, completion completionBlock: @escaping (_ result: [AnyHashable: Any]?) -> Void) {
        
        
        let Parameter = String(format: "%@%@", Config().API_URL,method!)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.httpBody = postString?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            var jsonResult  = NSDictionary()
            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
            
            var status = Int()
            status = jsonResult.object(forKey: "status") as! Int
            
            if status==1
            {
                completionBlock(jsonResult as? [AnyHashable : Any])
            }
            else
            {
                print("Error")
            }
            print("jsonResult: \(jsonResult)")
            
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RegistrationOTP"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
        }
        task.resume()
        
    }
    
    
    //MARK:- Discover Login
    func DiscoverLogin(Email:String!,Password:String!,DeviceId:String!,DeviceType:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_Login)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "email=%@&password=%@&deviceId=%@&deviceType=%@",Email,Password,DeviceId,DeviceType)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverLoginNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
          
        }
        task.resume()
    }

    //MARK:- Discover SignUp
    func DiscoverSignup(Email:String!,Password:String!,FullName:String!,DeviceType:String!,DeviceId:String!,ReferalCode:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_Signup)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "email=%@&password=%@&full_name=%@&deviceType=%@&deviceId=%@&referral_code=%@",Email,Password,FullName,DeviceType,DeviceId,ReferalCode)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverSignUpNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    //MARK:- Discover Verification
    func DiscoverVerification(UserId:Int!,OTP:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_OtpVerification)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "userID=%d&otp=%@",UserId,OTP)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverVerificationNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- Discover Verification
    func DiscoverForgotOtp(UserId:Int!,OTP:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_ForgotOtp)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "userID=%d&otp=%@",UserId,OTP)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverForgotOtp"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    // MARK:- facebooklogin API -----
    func FacebookLogin(Email: String!, facebookid: String!, DeviceID: String!, DeviceType: String!,facebookname: String!,image:String!){
        
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_FacebookLogin)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "email=%@&facebookId=%@&deviceId=%@&deviceType=%@&full_name=%@&profile_picture=%@", Email,facebookid,DeviceID,DeviceType,facebookname,image)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                    }else {
                        
                        DispatchQueue.main.async() {
                            if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                                var jsonResult  = NSDictionary()
                                jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                                print("jsonResult: \(jsonResult)")
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "facebookloginNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                            }else {
                                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    // MARK:- twitterlogin API -----
    func TwitterLogin(Email: String!, twitterid: String!, DeviceID: String!, DeviceType: String!,twitterkname: String!,image:String!){
        
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_TwitterLogin)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "email=%@&twitterId=%@&deviceId=%@&deviceType=%@&full_name=%@&profile_picture=%@", Email,twitterid,DeviceID,DeviceType,twitterkname,image)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                    }else {
                        
                        DispatchQueue.main.async() {
                            if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                                var jsonResult  = NSDictionary()
                                jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                                print("jsonResult: \(jsonResult)")
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "twitterloginNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                            }else {
                                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                            }
                        }
                    }
                }
                
            }
        }
        task.resume()
    }
    
    //MARK:- Discover Forgot Password
    func DiscoverForgotPassword(Email:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_ForgotPassword)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "email=%@",Email)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverForgotPasswordNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    //MARK:- Discover Reset Password
    func DiscoverResetPassword(UserId:Int!,NewPassword:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_ResetPassword)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "userID=%d&newPassword=%@",UserId,NewPassword)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverResetPasswordNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- Discover Resend OTP
    func DiscoverResendotp(Email:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_ResendOtp)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "email=%@",Email)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverResendOtpNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- Discover Resend Forgot OTP
    func DiscoverResendForgototp(Email:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_ResendForgotOtp)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "email=%@",Email)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverResendForgototpNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    
    /// MARK: --- User Profile Detail API ---
    func DiscoverUserDetail(user_Id: Int!) {
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_UserDetail)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "userID=%d", user_Id)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverUserDetail"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    //MARK:- Discover Reset Password
    func DiscoverChangePassword(UserId:Int!,OldPassword:String!,NewPassword:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_ChangePassword)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "userID=%d&oldPassword=%@&newPassword=%@",UserId,OldPassword,NewPassword)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverChangePasswordNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    ///Get Genres List----
    func GetGenresList(){
        
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_GenresList)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "GET"
        
        let postString = String(format: "")
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            // else {
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetGenresListNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    
    /// MARK: --- Artist Listing API ---
    func DiscoverArtistListing(user_Id: Int!,List_type:String!,Lat:String!,Long:String!,Offset:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_ArtistListing)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&list_type=%@&lat=%@&lng=%@&offset=%d", user_Id,List_type,Lat,Long,Offset)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverArtistListing"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    /// MARK: --- Artist/Band Listing API ---
    func DiscoverArtistBandListing(user_Id: Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_ArtistBandListing)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d", user_Id)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverArtistBandListing"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    /// MARK: --- Artist Detail API ---
    func DiscoverArtistDetail(user_Id: Int!,Artist_id:Int!,ArtistUserId:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_ArtistDetail)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&artist_id=%d&artist_user_id=%d", user_Id,Artist_id,ArtistUserId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverArtistDetail"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    ///Get Promotional Plan List----
    func GetPromotionalPlanList(){
        
        let API_Path = "\(Config().API_PackageUrl)"
        let API_Method = "\(Config().API_PromotionalPlan)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "GET"
        
        let postString = String(format: "")
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            // else {
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetPromotionalPlanListNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    ///Get Featured Artist Plan List----
    func GetFeaturedArtistPlanList(){
        
        let API_Path = "\(Config().API_FeaturedUrl)"
        let API_Method = "\(Config().API_FeaturedArtist)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "GET"
        
        let postString = String(format: "")
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            // else {
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetFaeturedArtistPlanListNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    ///Get Featured Songs Plan List----
    func GetFeaturedSongPlanList(){
        
        let API_Path = "\(Config().API_FeaturedUrl)"
        let API_Method = "\(Config().API_FeaturedSongList)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "GET"
        
        let postString = String(format: "")
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            // else {
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetFaeturedSongPlanListNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    /// MARK: --- Tickets Detail API ---
    func DiscoverTicketDetails(scan_number: String!) {
        let API_Path = "\(Config().API_TicketsUrl)"
        let API_Method = "\(Config().API_TicketScan)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "scan_number=%@", scan_number)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverTicketDetail"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Artist Folloew Unfollow API ---
    func DiscoverArtistFollowUnfollow(user_Id: Int!,FollowId:Int!,Follow_Type:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_ArtistFollowUnfollow)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        let postString = String(format: "user_id=%d&follower_id=%d&follow_type=%@", user_Id,FollowId,Follow_Type)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverArtistFollowUnfollow"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Artist Like Unlike API ---
    func DiscoverArtistLikeUnlike(user_Id: Int!,LikeId:Int!,Like_Type:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_ArtistLikeUnlike)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&like_id=%d&like_type=%@", user_Id,LikeId,Like_Type)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverArtistLikeUnlike"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Current Plan API ---
    func DiscoverFeaturedCurrentPlan(user_Id: Int!,PlanTypeid:Int!,PlanType:String!) {
        let API_Path = "\(Config().API_PaymentUrl)"
        let API_Method = "\(Config().API_CurrentPlan)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&plan_type_id=%d&plan_type=%@", user_Id,PlanTypeid,PlanType)
        print(postString)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverFeaturedCurrentPlan"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Band Listing API ---
    func DiscoverBandListing(user_Id: Int!,ArtistId:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_BandList)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&artist_id=%d", user_Id,ArtistId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverBandListing"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Band Invitation API ---
    func DiscoverBandInvitation(user_Id: Int!,ArtistId:Int!,Invitetype:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_BandInvitation)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&artist_id=%d&invitation_type=%@", user_Id,ArtistId,Invitetype)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverBandInvitation"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Band Detail API ---
    func DiscoverBandDetail(BandId: Int!,UserId:Int!,BandUserId:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_BandDetail)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "band_id=%d&user_id=%d&band_user_id=%d", BandId,UserId,BandUserId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverBandDetail"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Get Member List API ---
    func DiscoverGetMemberList(UserId: Int!,GetType:String!,GetTypeId:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_GetMemberList)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&get_type=%@&get_type_id=%d", UserId,GetType,GetTypeId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverGetMemberList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Post Listing API ---
    func DiscoverPostListing(PostId: Int!,ArtistId:Int!,postType:String!,postTypeId:String!,Offset:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_PostListing)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&artist_id=%d&post_type=%@&post_type_id=%@&offset=%d", PostId,ArtistId,postType,postTypeId,Offset)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverPostListing"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    
    // MARK: --- Post Listing API ---
    func DiscoverPostListing1(PostId: Int!,ArtistId:Int!,postType:String!,postTypeId:String!,Offset:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_PostListing)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&artist_id=%d&post_type=%@&post_type_id=%@&offset=%d", PostId,ArtistId,postType,postTypeId,Offset)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverPostListing1"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    
    
    // MARK: --- Event Listing API ---
    func DiscoverEventListing(UserId: Int!,EventStatus:String!,ArtistId:Int!,Lat:String!,Long:String!,Offset:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_EventListing)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&related_type=%@&related_type_id=%d&lat=%@&lng=%@&offset=%d", UserId,EventStatus,ArtistId,Lat,Long,Offset)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverEventListing"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    
    // MARK: --- Ticket Calculation API ---
       func DiscoverTicketCalculation(UserId: Int!,Ticket_Price:Float!,NoOfTicket:Int!) {
           let API_Path = "\(Config().API_TicketsUrl)"
           let API_Method = "\(Config().API_TicketCalculation)"
           
           let Parameter = String(format: "%@%@",API_Path,API_Method)
           var request = URLRequest(url: URL(string: Parameter)!)
           request.httpMethod = "POST"
           
           let postString = String(format: "user_id=%d&ticket_price=%f&no_of_ticket=%d", UserId,Ticket_Price,NoOfTicket)
           
           request.httpBody = postString.data(using: .utf8)
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data, error == nil else {
                   
                   // check for fundamental networking error
                   print("error=\(String(describing: error))")
                   return
               }
               if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                   print("statusCode should be 200, but is \(httpStatus.statusCode)")
                   print("response = \(String(describing: response))")
               }
               
               let responseString = String(data: data, encoding: .utf8)
               print("responseString = \(String(describing: responseString))")
               
               if let httpResponse = response as? HTTPURLResponse {
                   if httpResponse.statusCode != 200 {
                       SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                   }else {
                       
                       DispatchQueue.main.async() {
                           if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                               var jsonResult  = NSDictionary()
                               jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                               print("jsonResult: \(jsonResult)")
                               
                               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverTicketCalculation"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                           }else {
                               SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                           }
                       }
                   }
               }
           }
           task.resume()
           
       }
    
    
    
    // MARK: --- Event All Listing API ---
    func DiscoverEventListing1(UserId: Int!,EventStatus:String!,ArtistId:Int!,Lat:String!,Long:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_EventListing)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&related_type=%@&related_type_id=%d&lat=%@&lng=%@", UserId,EventStatus,ArtistId,Lat,Long)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverEventListing1"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Event Detail API ---
    func DiscoverEventDetail(UserId: Int!,EventId:Int!,ArtistId:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_EventDetail)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&event_id=%d&artist_id=%d", UserId,EventId,ArtistId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverEventDetail"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Event Ticket Sold API ---
    func DiscoverTicketSoldOut(UserId: Int!,EventId:Int!,VenueId:Int!) {
        let API_Path = "\(Config().API_TicketsUrl)"
        let API_Method = "\(Config().API_SoldOutTicket)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&event_id=%d&venue_id=%d", UserId,EventId,VenueId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverTicketsSold"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Related PostList API ---
    func DiscoverRetaltedPostList(UserId: Int!,RelatedType:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_RalatedPostList)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&related_type=%@", UserId,RelatedType)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverRetaltedPostList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    // MARK: --- Venue Listing API ---
    func DiscoverVenueListing(UserId: Int!,ListType:String!,Lat:String!,Long:String!,Offset:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_VenueList)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&list_type=%@&lat=%@&lng=%@&offset=%d", UserId,ListType,Lat,Long,Offset)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverVenueListing"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Venue Detail API ---
    func DiscoverVenueDetail(UserId: Int!,Venue_id:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_VenueDetail)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&venue_id=%d", UserId,Venue_id)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverVenueDetail"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Ger User Role API ---
    func DiscoverGetUserRole() {
        var defaults = UserDefaults()
        defaults = UserDefaults.standard
        let userid:Int!
        userid = defaults.integer(forKey: "UserIDGet")
        let strid = String(userid)
        let data = (strid).data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        var newid = String()
        newid  = "/" + base64
        let API_Method = "\(Config().API_GetUserRole)"
        let API_Path = "\(Config().API_ArtistUrl)"
        let Parameter = String(format: "%@%@%@",API_Path,API_Method,newid)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "GET"
       
        let postString = String(format: "")
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverGetUserRole"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Artist Profile Band List API ---
    func DiscoverProfileArtistBandList() {
        var defaults = UserDefaults()
        defaults = UserDefaults.standard
        let userid:Int!
        userid = defaults.integer(forKey: "UserIDGet")
        let strid = String(userid)
        let data = (strid).data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        var newid = String()
        newid  = "/" + base64
        let API_Method = "\(Config().API_ArtistProfileBandList)"
        let API_Path = "\(Config().API_ArtistUrl)"
        let Parameter = String(format: "%@%@%@",API_Path,API_Method,newid)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "GET"
        
        let postString = String(format: "")
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverProfileArtistBandList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Artist Profile Band List API ---
    func DiscoverProfileArtistBandList1() {
        var defaults = UserDefaults()
        defaults = UserDefaults.standard
        let userid:Int!
        userid = defaults.integer(forKey: "UserIDGet")
        let strid = String(userid)
        let data = (strid).data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        var newid = String()
        newid  = "/" + base64
        let API_Method = "\(Config().API_ArtistProfileBandList)"
        let API_Path = "\(Config().API_ArtistUrl)"
        let Parameter = String(format: "%@%@%@",API_Path,API_Method,newid)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "GET"
        
        let postString = String(format: "")
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverProfileArtistBandList1"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Event Cancel API ---
    func DiscoverCancelEvent(UserId: Int!,EventId:Int!,Event_Type:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_CancelEvent)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&event_id=%d&event_type=%@", UserId,EventId,Event_Type)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverCancelEvent"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Comment Post API ---
    func DiscoverPostComment(UserId: Int!,PostId:Int!,PostComment:String!,CommentType:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_PostComment)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&post_id=%d&post_comment=%@&comment_type=%@", UserId,PostId,PostComment,CommentType)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverPostComment"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Comment Post List API ---
    func DiscoverPostCommentList(UserId: Int!,PostId:Int!,CommentType:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_CommentList)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&post_id=%d&comment_type=%@", UserId,PostId,CommentType)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverPostCommentList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Search API ---
    func DiscoverSearch(UserId: Int!,SearchType:String!,SearchKetword:String! ,Offset:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_Search)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&search_type=%@&search_keyword=%@&offset=%d", UserId,SearchType,SearchKetword,Offset)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverSearchNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Accept Reject API ---
    func DiscoverAcceptRejectRequest(ID:Int!,ArtistId:Int!,JoinStatus: Int!,UserId:Int!,StatusType:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_AcceptReject)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "id=%d&artist_id=%d&request_status=%d&user_id=%d&status_type=%@", ID,ArtistId,JoinStatus,UserId,StatusType)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Accept Reject Event API ---
    func DiscoverAcceptRejectRequestEvent(ID:Int!,ArtistId:Int!,JoinStatus: Int!,UserId:Int!,StatusType:String!,bandId:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_AcceptReject)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "id=%d&artist_id=%d&request_status=%d&user_id=%d&status_type=%@&band_id=%d", ID,ArtistId,JoinStatus,UserId,StatusType,bandId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverAcceptRejectRequestEvent"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Song List API ---
    func DiscoverSongList(UserId: Int!,AsType:String!,AstypeId:Int!,ListType:String!,Lat:String!,Long:String!,Offset:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_SongList)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&as_type=%@&as_type_id=%d&list_type=%@&lat=%@&lng=%@&offset=%d", UserId,AsType,AstypeId,ListType,Lat,Long,Offset)
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverSongList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Song List API ---
    func DiscoverSongList1(UserId: Int!,AsType:String!,AstypeId:String!,ListType:String!,Lat:String!,Long:String!,Offset:Int!,ListTypeID:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_SongList)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&as_type=%@&as_type_id=%@&list_type=%@&lat=%@&lng=%@&offset=%d&list_type_id=%d", UserId,AsType,AstypeId,ListType,Lat,Long,Offset,ListTypeID)
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverSongList1"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- All Song List API ---
    func DiscoverAllSongList(UserId: Int!,AsType:String!,ListType:String!,Lat:String!,Long:String!,Offset:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_SongList)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&as_type=%@&list_type=%@&lat=%@&lng=%@&offset=%d", UserId,AsType,ListType,Lat,Long,Offset)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverAllSongList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Song Detail API ---
    func DiscoverSongDetail(UserId: Int!,SongId:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_SongDetail)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&song_id=%d", UserId,SongId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverSongDetail"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Delete Data API ---
    func DiscoverDeleteData(UserId: Int!,DeleteType:String!,DeleteTypeId:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_DeleteData)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&delete_type=%@&delete_type_id=%d", UserId,DeleteType,DeleteTypeId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverDeleteData"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Song Like Unlike API ---
    func DiscoverSongLikeUnlike(UserId: Int!,SongId:Int!,Status:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_SongLikeUnlike)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&song_id=%d&status=%d", UserId,SongId,Status)
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverSongLikeUnlike"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Song Favourite API ---
    func DiscoverSongFavourite(UserId: Int!,FavId:Int!,Fav_Tyape:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_FavouriteSong)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&favourite_id=%d&favourite_type=%@", UserId,FavId,Fav_Tyape)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverSongFavourite"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Search Filter Sort API ---
    func DiscoverSearchFilterSort(UserId: Int!,FilterType:String!,SearchKeyword:String!,Sort:String!,Limit:Int!,Offset:Int!,str_Lat:String!,str_Long:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_SearchFilterSort)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&filter_type=%@&search_keyword=%@&sort=%@&limit=%d&offset=%d&lat=%@&lng=%@", UserId,FilterType,SearchKeyword,Sort,Limit,Offset,str_Lat,str_Long)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverSearchFilterSort"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Search Filter Song API ---
    func DiscoverSearchSongFilter(UserId: Int!,FilterType:String!,SearchKeyword:String!,Sort:String!,Limit:Int!,Offset:Int!,Rating:String!,Geners:String!,StrDate:String!,EndDate:String!,Views:String!,SongType:String!,AnyAllSts:Int!,Lat:String!,Long:String!,Distance:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_SearchFilterSort)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&filter_type=%@&search_keyword=%@&sort=%@&limit=%d&offset=%d&rating=%@&genres=%@&start_date=%@&end_date=%@&views=%@&song_type=%@&include_genres=%d&lat=%@&lng=%@&distance=%@", UserId,FilterType,SearchKeyword,Sort,Limit,Offset,Rating,Geners,StrDate,EndDate,Views,SongType,AnyAllSts,Lat,Long,Distance)
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Search Filter Artist API ---
    func DiscoverSearchSongFilter1(UserId: Int!,FilterType:String!,SearchKeyword:String!,Sort:String!,Limit:Int!,Offset:Int!,Rating:String!,Geners:String!,Views:String!,AnyAllSts:Int!,Lat:String!,Long:String!,Distance:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_SearchFilterSort)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&filter_type=%@&search_keyword=%@&sort=%@&limit=%d&offset=%d&rating=%@&genres=%@&views=%@&include_genres=%d&lat=%@&lng=%@&distance=%@", UserId,FilterType,SearchKeyword,Sort,Limit,Offset,Rating,Geners,Views,AnyAllSts,Lat,Long,Distance)
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverSearchSongFilter1"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    
    // MARK: --- Search Filter Event API ---
    func DiscoverSearchEventFilter(UserId: Int!,FilterType:String!,SearchKeyword:String!,Sort:String!,Limit:Int!,Offset:Int!,Rating:String!,Geners:String!,Distance:String!,Price:String!,StartDate:String!,EndDate:String!,Lat:String!,Long:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_SearchFilterSort)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&filter_type=%@&search_keyword=%@&sort=%@&limit=%d&offset=%d&rating=%@&genres=%@&distance=%@&price=%@&start_date=%@&end_date=%@&lat=%@&lng=%@", UserId,FilterType,SearchKeyword,Sort,Limit,Offset,Rating,Geners,Distance,Price,StartDate,EndDate,Lat,Long)
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverSearchEventFilter"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Search Filter Venue API ---
    func DiscoverSearchVenueFilter(UserId: Int!,FilterType:String!,SearchKeyword:String!,Sort:String!,Limit:Int!,Offset:Int!,Rating:String!,Distance:String!,Size:String!,Lat:String!,Long:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_SearchFilterSort)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&filter_type=%@&search_keyword=%@&sort=%@&limit=%d&offset=%d&rating=%@&distance=%@&capacity=%@&lat=%@&lng=%@", UserId,FilterType,SearchKeyword,Sort,Limit,Offset,Rating,Distance,Size,Lat,Long)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverSearchVenueFilter"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    
    ///Get Basic Details ----
    func GetBasicDetails(){
        
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_GetBasicDetail)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "GET"
        
        let postString = String(format: "")
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            // else {
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetBasicDetailsNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    
    // MARK: --- Upcoming Past Event API ---
    func DiscoverUpcomingPastEvents(UserId: Int!,RelatedType:String!,Related_TypeId:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_UpcomingPastEvent)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&related_type=%@&related_type_id=%d", UserId,RelatedType,Related_TypeId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverUpcomingPastEvents"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Invitaion API ---
    func DiscoverEventInvites(UserId: Int!,InviteType:String!,Invite_TypeId:Int!,InviteForm:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_EventInvites)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&invitation_type=%@&invitation_type_id=%d&invitation_from=%@", UserId,InviteType,Invite_TypeId,InviteForm)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverEventInvites"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    
    // MARK: --- Following List API ---
    func DiscoverGetFollowingList(UserId: Int!,FollowType:String!,Lat:String!,Long:String!,Offset:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_GetFollowingList)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&follow_type=%@&lat=%@&lng=%@&offset=%d", UserId,FollowType,Lat,Long,Offset)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverGetFollowingList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    
    
    // MARK: --- Delete Venue API ---
    func DiscoverDeleteVenue(UserId: Int!,VenueId:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_DeleteVenue)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&venue_id=%d", UserId,VenueId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverDeleteVenue"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- AllPayment Package API ---
    func DiscoverAllPaymentsPackage(user_Id:Int!,package_id:Int!,package_type:String!,package_for:String!,package_for_id:Int!,Amount:String,Currency:String!,CardId:String!,CustomerId:String!) {
        let API_Path = "\(Config().API_PaymentUrl)"
        let API_Method = "\(Config().API_AllPayment)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
    let postString = String(format:"user_id=%d&package_id=%d&package_type=%@&package_for=%@&package_for_id=%d&payment[amount]=%@&payment[currency]=%@&payment[source]=%@&payment[customer]=%@", user_Id,package_id,package_type,package_for,package_for_id,Amount,Currency,CardId,CustomerId)
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverAllPaymentsPackage"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Book Tickets API ---
    func DiscoverBookTickets(Email: String!,Name:String!,user_Id:Int!,Event_Id:Int!,NoOfTickets:Int!,Amount:String,SingleTicketNumber:String!,ProcessingFee:String!,Currency:String!,CardId:String!,CustomerId:String!,AccountId:String!) {
        let API_Path = "\(Config().API_PaymentUrl)"
        let API_Method = "\(Config().API_BookTickets)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "email=%@&name=%@&user_id=%d&ticket[event_id]=%d&ticket[no_of_ticket]=%d&payment[amount]=%@&ticket[single_ticket_amount]=%@&ticket[processing_fee]=%@&payment[currency]=%@&payment[source]=%@&payment[customer]=%@&payment[account_id]=%@", Email,Name,user_Id,Event_Id,NoOfTickets,Amount,SingleTicketNumber,ProcessingFee,Currency,CardId,CustomerId,AccountId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverBookTickets"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Ticket Detail API ---
    func DiscoverTicketDetail(UserId: Int!,TicketID:Int!) {
        let API_Path = "\(Config().API_TicketsUrl)"
        let API_Method = "\(Config().API_TicketDetail)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&ticket_id=%d", UserId,TicketID)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverTicketDetail"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Ticket List API ---
    func DiscoverTicketsList(UserId: Int!,ListType:String!,Offset:Int!) {
        let API_Path = "\(Config().API_TicketsUrl)"
        let API_Method = "\(Config().API_TicketList)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&list_type=%@&offset=%d", UserId,ListType,Offset)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverTicketsList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Delete Post API ---
    func DiscoverDeletePost(UserId: Int!,Delete_Type:String!,Delete_Type_Id:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_DeletePost)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&delete_type=%@&delete_type_id=%d", UserId,Delete_Type,Delete_Type_Id)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverDeletePost"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    
    // MARK: ---  Post Detail API ---
    func DiscoverPostDetail(UserId: Int!,PostId:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_PostDetail)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&post_id=%d", UserId,PostId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverPostDetail"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    
    // MARK: --- Dashboard API ---
    func DiscoverDashboard(UserId: Int!,Lat:String!,Long:String!,Range:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_Dashboard)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&lat=%@&lng=%@&range=%d", UserId,Lat,Long,Range)
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverDashboard"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Reward List API ---
    func DiscoverRewardList(UserId: Int!) {
        let API_Path = "\(Config().API_TicketsUrl)"
        let API_Method = "\(Config().API_RewardList)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d", UserId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverRewardList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Myplay List API ---
    func DiscoverMyplayList(UserId: Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_Myplaylist)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d", UserId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverMyplayList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Create play List API ---
    func DiscoverCreateplayList(UserId: Int!,ListName:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_Createplaylist)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&playlist_name=%@", UserId,ListName)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverCreateplayList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: --- Remove Song  PlayList API ---
    func DiscoverRemoveSongPlaylist(UserId: Int!,RemoveType:String!,SongId:Int!,PlayListId:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_RemovePlaylistSong)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&remove_type=%@&song_id=%d&playlist_id=%d", UserId,RemoveType,SongId,PlayListId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverRemoveSongPlaylist"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    
    // MARK: --- Report API ---
    func DiscoverReport(UserId: Int!,ReportType:String!,ReportTypeId:Int!,CommentId:Int!,Description:String!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_Report)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&report_type=%@&report_type_id=%d&comment_id=%d&description=%@", UserId,ReportType,ReportTypeId,CommentId,Description)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverReport"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    
    // MARK: --- Add Song Playlist API ---
    func DiscoverAddSongPlayList(UserId: Int!,SongId:Int!,PlaylistId:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_AddSongPlayList)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&song_id=%d&playlist_id=%d", UserId,SongId,PlaylistId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverAddSongPlayList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Delete Song API ---
    func DiscoverDeleteSong(UserId: Int!,SongId:Int!) {
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_SongDelete)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&song_id=%d", UserId,SongId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverDeleteSong"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    
    // MARK: Update Song
    func DiscoverUpdateSong(data: UpdateSongModel){
        let parameters = [
            "id" : data.Id,
            "user_id" : data.UserId,
            "song_name": data.SongName,
            "song_type" : data.SongType,
            "genres" : data.Geners,
            "orginal_artist":data.OriginalArtist,
            "as_type" : data.AsType,
            "as_type_id" : data.AsId,
            "description" : data.deescription,
            "price" : data.Price
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString1()
        
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_UpdateSong)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        //request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.ProfilePicture, imageName: "ProfilePicture.png", boundary: boundary) as Data
        
        request.httpBody = try createBodyWithParameters1(parameters: parameters, filePathKey: "song_image", imageData: data.SongImage, imageName: "songimage.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", filePathKey2: "song_file", imageData2: data.SongFile, imageName2: "songfile.mp3", boundary: boundary) as Data
        
        
        
        //        request.httpBody = try createBodyWithParameters_ID(parameters: parameters, filePathKey: "proof_id", imageData: data.IDProof, imageName: "IDProof.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverUpdateSong"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    
    
    // MARK: --- Card List API ---
    func DiscoverCardList(UserId: Int!,Customer_Id:String!) {
        let API_Path = "\(Config().API_PaymentUrl)"
        let API_Method = "\(Config().API_GetCardList)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&customer_id=%@", UserId,Customer_Id)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverCardList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Save Card API ---
    func DiscoverSaveCard(UserId: Int!,Customer_Id:String!,CardNumber:String!,CardExpYear:String!,CardExpMonth:String!,CardCVV:String!) {
        let API_Path = "\(Config().API_PaymentUrl)"
        let API_Method = "\(Config().API_SaveCard)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "user_id=%d&customer_id=%@&card[number]=%@&card[exp_year]=%@&card[exp_month]=%@&card[cvc]=%@", UserId,Customer_Id,CardNumber,CardExpYear,CardExpMonth,CardCVV)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverSaveCard"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    // MARK: --- Get Card Token API ---
       func DiscoverGetCardToken(UserId: Int!,CardNumber:String!,CardExpYear:String!,CardExpMonth:String!,CardCVV:String!) {
           let API_Path = "\(Config().API_PaymentUrl)"
           let API_Method = "\(Config().API_GetCardToken)"
           
           let Parameter = String(format: "%@%@",API_Path,API_Method)
           var request = URLRequest(url: URL(string: Parameter)!)
           request.httpMethod = "POST"
           
           let postString = String(format: "user_id=%d&card[number]=%@&card[exp_year]=%@&card[exp_month]=%@&card[cvc]=%@", UserId,CardNumber,CardExpYear,CardExpMonth,CardCVV)
           
           request.httpBody = postString.data(using: .utf8)
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data, error == nil else {
                   
                   // check for fundamental networking error
                   print("error=\(String(describing: error))")
                   return
               }
               if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                   print("statusCode should be 200, but is \(httpStatus.statusCode)")
                   print("response = \(String(describing: response))")
               }
               
               let responseString = String(data: data, encoding: .utf8)
               print("responseString = \(String(describing: responseString))")
               
               if let httpResponse = response as? HTTPURLResponse {
                   if httpResponse.statusCode != 200 {
                       SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                   }else {
                       
                       DispatchQueue.main.async() {
                           if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                               var jsonResult  = NSDictionary()
                               jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                               print("jsonResult: \(jsonResult)")
                               
                               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverGetCardToken"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                           }else {
                               SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                           }
                       }
                   }
               }
           }
           task.resume()
           
       }
    
    
    // MARK: Upload Song
    func DiscoverUploadSong(data: AddSongModel){
        let parameters = [
            
            "user_id" : data.UserId,
            "artist_account_id":data.AccountID,
            "song_name": data.SongName,
            "song_type" : data.SongType,
            "genres" : data.Geners,
            "orginal_artist":data.OriginalArtist,
            "as_type" : data.AsType,
            "as_type_id" : data.AsId,
            "description" : data.deescription,
            "price" : data.Price
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString1()
        
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_UploadSong)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        //request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.ProfilePicture, imageName: "ProfilePicture.png", boundary: boundary) as Data
        
        request.httpBody = try createBodyWithParameters1(parameters: parameters, filePathKey: "song_image", imageData: data.SongImage, imageName: "songimage.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", filePathKey2: "song_file", imageData2: data.SongFile, imageName2: "songfile.mp3", boundary: boundary) as Data
        
        
        
        //        request.httpBody = try createBodyWithParameters_ID(parameters: parameters, filePathKey: "proof_id", imageData: data.IDProof, imageName: "IDProof.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverUploadSong"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    
    
    
   
    
    
    
    
    
    // MARK: Craete Event
    func DiscoverCreateEvent(data: CreateEventModel){
        let parameters = [
            "user_id" : data.UserId,
            "event_title": data.EventName,
            "event_date" : data.EventDate,
            "event_time" : data.EventTime,
            "price_per_sit" : data.EventPricePerSeat,
            "no_of_ticket" : data.EventNoOftickets,
            "about_event" : data.AboutEvent,
            "venue_id" : data.VenueID,
            "event_type" : data.VenueAddress,
            "invited_artist" : data.Invite_Artist,
            "invited_bands":data.Invite_Band,
            "event_status" : data.Event_Status,
            "lat":   data.latittude,
            "lng":   data.longitude
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_CreateEvent)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        //request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.ProfilePicture, imageName: "ProfilePicture.png", boundary: boundary) as Data
        
        request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "event_image", imageData: data.Event_Image, imageName: "ProfilePicture.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", boundary: boundary) as Data
        
        
        
        //        request.httpBody = try createBodyWithParameters_ID(parameters: parameters, filePathKey: "proof_id", imageData: data.IDProof, imageName: "IDProof.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverCreateEvent"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    
    // MARK: Post Create
    func DiscoverCreatePost(data: CreatePostModel){
        let parameters = [
            "user_id" : data.UserId,
            "artist_id":data.artistID,
            "post_type": data.postType,
            "post_type_id":data.postTypeId,
            "post_title": data.PostTitle,
            "description" : data.PostDescroption
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_CreatePost)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        //request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.ProfilePicture, imageName: "ProfilePicture.png", boundary: boundary) as Data
        
        request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "post_image", imageData: data.PostImage, imageName: "ProfilePicture.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", boundary: boundary) as Data
        
        
        
        //        request.httpBody = try createBodyWithParameters_ID(parameters: parameters, filePathKey: "proof_id", imageData: data.IDProof, imageName: "IDProof.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverCreatePost"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    
    
    // MARK: Post Update
    func DiscoverUpdatePost(data: UpdatePostModel){
        let parameters = [
            "user_id" : data.UserId,
            "artist_id":data.artistID,
            "post_type": data.postType,
            "post_type_id":data.postTypeId,
            "post_title": data.PostTitle,
            "description" : data.PostDescroption,
            "id": data.Id
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_UpdatePost)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        //request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.ProfilePicture, imageName: "ProfilePicture.png", boundary: boundary) as Data
        
        request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "post_image", imageData: data.PostImage, imageName: "ProfilePicture.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", boundary: boundary) as Data
        
        
        
        //        request.httpBody = try createBodyWithParameters_ID(parameters: parameters, filePathKey: "proof_id", imageData: data.IDProof, imageName: "IDProof.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverUpdatePost"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    
    
    // MARK: Craete Band
    func DiscoverCreateBand(data: CreateBandModel){
        let parameters = [
            "user_id" : data.UserId,
            "artist_id" : data.ArtistId,
            "band_name": data.BandName,
            "mobile_no" : data.MobileNo,
            "address" : data.Address,
            "city" : data.City,
            "state" : data.State,
            "country" : data.Country,
            "zipcode" : data.Zipcode,
            "description" : data.Description,
            "genres" : data.Genres,
            "invited_artist" : data.InviteArtist
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_CreateBand)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        //request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.ProfilePicture, imageName: "ProfilePicture.png", boundary: boundary) as Data
        
        request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "band_image", imageData: data.Band_Image, imageName: "ProfilePicture.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", boundary: boundary) as Data
        
        
        
        //        request.httpBody = try createBodyWithParameters_ID(parameters: parameters, filePathKey: "proof_id", imageData: data.IDProof, imageName: "IDProof.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverCreateBand"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    
    
    // MARK: Update Band
    func DiscoverUpdateBand(data: UpdateBandModel){
        let parameters = [
            "id" : data.Id,
            "user_id" : data.UserId,
            "artist_id" : data.ArtistId,
            "band_name": data.BandName,
            "mobile_no" : data.MobileNo,
            "address" : data.Address,
            "city" : data.City,
            "state" : data.State,
            "country" : data.Country,
            "zipcode" : data.Zipcode,
            "description" : data.Description,
            "genres" : data.Genres,
            "invited_artist" : data.InviteArtist
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_UpdateBand)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        //request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.ProfilePicture, imageName: "ProfilePicture.png", boundary: boundary) as Data
        
        request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "band_image", imageData: data.Band_Image, imageName: "ProfilePicture.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", boundary: boundary) as Data
        
        
        
        //        request.httpBody = try createBodyWithParameters_ID(parameters: parameters, filePathKey: "proof_id", imageData: data.IDProof, imageName: "IDProof.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverUpdateBand"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    
    // MARK: Craete Artist
    func DiscoverCreateArtist(data: CreateArtistModel){
        let parameters = [
            "user_id" : data.UserId,
            "artist_name": data.ArtistName,
            "mobile_no" : data.Artist_Mobile,
             "address" : data.Address,
            "city" : data.City,
            "state" : data.State,
             "country" : data.Country,
            "zipcode" : data.Zipcode,
            "description" : data.Description,
            "genres" : data.Genres
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_CreateArtist)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        //request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.ProfilePicture, imageName: "ProfilePicture.png", boundary: boundary) as Data
        
        request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "artist_image", imageData: data.Artist_Image, imageName: "ProfilePicture.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", boundary: boundary) as Data
        
        
        
        //        request.httpBody = try createBodyWithParameters_ID(parameters: parameters, filePathKey: "proof_id", imageData: data.IDProof, imageName: "IDProof.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverCreateArtist"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    
    // MARK: Update Artist
    func DiscoverUpdateArtist(data: UpdateArtistModel){
        let parameters = [
            "id" : data.Id,
            "user_id" : data.UserId,
            "artist_name": data.ArtistName,
            "mobile_no" : data.Artist_Mobile,
            "address" : data.Address,
            "city" : data.City,
            "state" : data.State,
            "country" : data.Country,
            "zipcode" : data.Zipcode,
            "description" : data.Description,
            "genres" : data.Genres
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let API_Path = "\(Config().API_ArtistUrl)"
        let API_Method = "\(Config().API_UpdateArtist)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        //request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.ProfilePicture, imageName: "ProfilePicture.png", boundary: boundary) as Data
        
        request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "artist_image", imageData: data.Artist_Image, imageName: "ProfilePicture.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", boundary: boundary) as Data
        
        
        
        //        request.httpBody = try createBodyWithParameters_ID(parameters: parameters, filePathKey: "proof_id", imageData: data.IDProof, imageName: "IDProof.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverUpdateArtist"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    
    
    // MARK: Update Profile
    func DiscoverUpdateProfile(data: UpdateModel){
        let parameters = [
            "userID" : data.userID,
            "gender": data.gender,
            "location" : data.location,
            "city" : data.City,
            "state" : data.State,
            "zipcode" : data.Zipcode,
            "dob" : data.dob,
            "email_notification": data.email_notification,
            "sms_notification" : data.sms_notification,
            "default_range": data.Range
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_Updateprofile)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        //request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.ProfilePicture, imageName: "ProfilePicture.png", boundary: boundary) as Data
        
        request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.profile_picture, imageName: "ProfilePicture.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", boundary: boundary) as Data
        
        
        
        //        request.httpBody = try createBodyWithParameters_ID(parameters: parameters, filePathKey: "proof_id", imageData: data.IDProof, imageName: "IDProof.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverUpdateProfile"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    

    // MARK: Profile set up
    func DiscoverProfileSetUp(data: Editdatamodel){
        let parameters = [
            "email" : data.email,
            "userID": data.userID,
            "full_name" : data.full_name,
            "gender" : data.gender,
            "location": data.location,
            "city":data.City,
            "state":data.State,
            "zipcode":data.Zipocode,
            "dob" : data.dob
            ] as [String : Any]

        print(parameters)
        // build your dictionary however appropriate

        let boundary = generateBoundaryString()

        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_ProfileSetup)"

        let Parameter = String(format: "%@%@", API_Path,API_Method)

        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        //let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        //request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.ProfilePicture, imageName: "ProfilePicture.png", boundary: boundary) as Data

         request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.profile_picture, imageName: "ProfilePicture.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", boundary: boundary) as Data



        //        request.httpBody = try createBodyWithParameters_ID(parameters: parameters, filePathKey: "proof_id", imageData: data.IDProof, imageName: "IDProof.png", boundary: boundary) as Data

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }

            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {

                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")

                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiscoverProfileSetUp"), object: self, userInfo: jsonResult as? [AnyHashable : Any])

                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    
    func mimeType(for path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?, imageData: NSData!,imageName : String?, filePathKey1: String?, imageData1: NSData!,imageName1 : String?, boundary: String) -> NSData {
        
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        if (imageData != nil) {
            
            
            let mimetype = mimeType(for: imageName!)
            
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(imageName! as String)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageData as Data)
            body.appendString(string: "\r\n")
            
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey1!)\"; filename=\"\(imageName1! as String)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageData1 as Data)
            body.appendString(string: "\r\n")
            
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        return body
    }
    
    
    func mimeType1(for path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }
    
    func generateBoundaryString1() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createBodyWithParameters1(parameters: [String: Any]?, filePathKey: String?, imageData: NSData!,imageName : String?, filePathKey1: String?, imageData1: NSData!,imageName1 : String?,filePathKey2: String?, imageData2: NSData!,imageName2 : String?, boundary: String) -> NSData {
        
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        if (imageData != nil) {
            
            
            let mimetype = mimeType1(for: imageName!)
            
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(imageName! as String)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageData as Data)
            body.appendString(string: "\r\n")
            
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey1!)\"; filename=\"\(imageName1! as String)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageData1 as Data)
            body.appendString(string: "\r\n")
            
            
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey2!)\"; filename=\"\(imageName2! as String)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageData2 as Data)
            body.appendString(string: "\r\n")
            
          
            
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        return body
    }
    
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}


    

