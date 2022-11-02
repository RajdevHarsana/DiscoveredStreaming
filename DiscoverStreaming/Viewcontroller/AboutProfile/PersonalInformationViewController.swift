//
//  PersonalInformationViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class PersonalInformationViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var updatedBtn: UIButton!
    @IBOutlet weak var changePasswordBtn: UIButton!
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var locationTxt: FloatLabelTextField!
    @IBOutlet weak var genderTxt: FloatLabelTextField!
    @IBOutlet weak var dobTxt: FloatLabelTextField!
    @IBOutlet weak var emailNotificationSwitc: UISwitch!
    @IBOutlet weak var smsNotificationSwitch: UISwitch!
    var defaults:UserDefaults!
    var user_id:Int!
    var updateImage:String!
    var datePickerView  : UIDatePicker = UIDatePicker()
    var PickerView  : UIPickerView = UIPickerView()
    var gender = ["Male","Female"]
    
    var chosenImage = UIImage()
    var imagedata: Data!
    var picker = UIImagePickerController()
    var Gender = String()
    
    var str_location = NSString()
    var str_gener = NSString()
    var str_dob = NSString()
    
    var email_notification = "0"
    var sms_notification = "0"
    
    fileprivate let prices: [Int] = [
        .min,10, 50, 100,500,.max,
    ]
    
    var email_not = Int()
    var sms_not = Int()

    @IBOutlet weak var cityTxt: FloatLabelTextField!
    
    @IBOutlet weak var stateTxt: FloatLabelTextField!
    @IBOutlet weak var zipcodeTxt: FloatLabelTextField!
    
    @IBOutlet weak var rangeLbl: UILabel!
    @IBOutlet weak var rangeSlider: UISlider!
    var str_city: NSString!
    var str_state:NSString!
    var str_zipcoe:NSString!
    
    var default_range:Int!
    @objc func UserDetailAction(_ notification: Notification) {
        
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
                //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else {
                var response = NSDictionary()
                response = (notification.userInfo?["response"] as? NSDictionary)!
                print("response: \(response)")
                self.nameLbl.text = response.object(forKey: "full_name") as? String
                self.emailLbl.text = response.object(forKey: "email") as? String
                self.locationTxt.text = response.object(forKey: "location") as? String
                self.genderTxt.text = response.object(forKey: "gender") as? String
                self.updateImage = response.value(forKey: "profile_picture") as? String
                self.dobTxt.text = response.value(forKey: "dob") as? String
                self.email_not = response.value(forKey: "email_notification") as! Int
//                self.sms_not = response.value(forKey: "sms_notification") as! Int
                self.cityTxt.text = response.object(forKey: "city") as? String
                self.stateTxt.text = response.object(forKey: "state") as? String
                self.zipcodeTxt.text = response.object(forKey: "zipcode") as? String
                self.default_range = response.object(forKey: "default_range") as? Int
               // self.rangeSlider.setValue(Float(self.default_range), animated: true)
                self.rangeSlider.value = Float(self.default_range)
                
                var range:String!
                range = String(self.default_range)
                self.rangeLbl.text = range
                if self.email_not == 1 {
                    self.emailNotificationSwitc.isOn = true
                }else{
                    self.emailNotificationSwitc.isOn = false
                }
                if self.sms_not == 1 {
                    self.smsNotificationSwitch.isOn = true
                }else{
                    self.smsNotificationSwitch.isOn = false
                }
                
                self.removeAllOverlays()
                
                let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                self.profileImageview.sd_setImage(with: AddPicture_url as URL?, placeholderImage: UIImage(named: "active_profile"), options: []) { (image, error, imageCacheType, imageUrl) in
                    
                }
                
            }
        }
    }
    
    @objc func DiscoverUpdateProfile(_ notification: Notification) {
        
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
                var response = NSMutableDictionary()
                response = (notification.userInfo?["response"] as? NSMutableDictionary)!
                print("response: \(response)")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUpdateProfile"), object: nil)
                self.removeAllOverlays()
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        user_id = defaults.integer(forKey: "UserIDGet")
        updatedBtn.layer.cornerRadius = 25
        changePasswordBtn.layer.cornerRadius = 25
        PickerView.delegate = self
        PickerView.dataSource = self
        genderTxt.inputView = PickerView
        picker.delegate = self
        
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        dobTxt.inputView = datePickerView
        datePickerView.maximumDate = Date()
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: UIControl.Event.valueChanged)
        
        profileImageview.layer.cornerRadius = profileImageview.frame.height/2
        profileImageview.layer.masksToBounds = true
        profileImageview.clipsToBounds = true
        
       
        
        rangeSlider.minimumValue = 0
        rangeSlider.maximumValue = Float(CGFloat(prices.count - 1))
        
        if Reachability.isConnectedToNetwork(){
            showWaitOverlay()
            Parsing().DiscoverUserDetail(user_Id: user_id)
            NotificationCenter.default.addObserver(self, selector: #selector(self.UserDetailAction), name: NSNotification.Name(rawValue: "DiscoverUserDetail"), object: nil)
        } else {
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

        // Do any additional setup after loading the view.
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dobTxt.text = dateFormatter.string(from: sender.date)
        //        let dateObj = dateFormatter.date(from: txt_DOB.text!)
        //        selctdate = dateObj!
    }
    
    func priceString(value: CGFloat) -> String {
        let index: Int = Int(roundf(Float(value)))
        let price: Int = prices[index]
        if price == .min {
            return "0"
        } else if price == .max {
            return "Any"
        } else {
           
            let priceString: String? = numberFormatter.string(from: price as NSNumber)
            return priceString ?? ""
        }
    }
    
    open var numberFormatter: NumberFormatter = {
           let formatter: NumberFormatter = NumberFormatter()
           formatter.numberStyle = .decimal
           formatter.maximumFractionDigits = 0
           return formatter
       }()
    
    // PickerView Delegate.....
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        genderTxt.text = gender[row]
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    @IBAction func emailNotBtnAction(_ sender: Any) {
        if emailNotificationSwitc.isOn == true{
            email_notification = "1"
        }else {
            email_notification = "0"
        }
    }
    
    @IBAction func smsNotBtnAction(_ sender: Any) {
        if smsNotificationSwitch.isOn == true{
            sms_notification = "1"
        }else {
            sms_notification = "0"
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rangeSliderAction(_ sender: UISlider) {
        rangeLbl.text = "0"
        rangeLbl.isHidden = false
        rangeLbl.text = priceString(value: CGFloat(sender.value))
    }
    
    
    @IBAction func updateBtnAction(_ sender: Any) {
        str_location = locationTxt.text! as NSString
        str_gener = genderTxt.text! as NSString
        str_dob = dobTxt.text! as NSString
        str_city = cityTxt.text! as NSString
        str_state = stateTxt.text! as NSString
        str_zipcoe = zipcodeTxt.text! as NSString
        
        if str_gener .isEqual(to: "Male"){
            Gender = "1"
        }else if str_gener .isEqual(to: "Female") {
            Gender = "2"
        }
        
        if str_location .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Address",
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
            //  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Enter Full Name" , buttonTitle: "OK")
        } else  if str_city .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter City",
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
            //  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Enter Full Name" , buttonTitle: "OK")
        } else  if str_state .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter State",
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
            //  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Enter Full Name" , buttonTitle: "OK")
        }else  if str_zipcoe .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Zipcode",
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
            //  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Enter Full Name" , buttonTitle: "OK")
        }
        else if str_gener .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Gender",
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
        }else  if str_dob .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Date of birth",
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
            if Reachability.isConnectedToNetwork() == true {
                showWaitOverlay()
                let data = UpdateModel()
                if imagedata == nil {
                let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                    let testImage = NSData(contentsOf: AddPicture_url as URL)
                    data.profile_picture = testImage!
                }
                else {
                    data.profile_picture = imagedata as NSData
                }
                data.userID = user_id
                data.location = str_location as String
                data.dob = str_dob as String
                data.gender = Gender
                data.email_notification = email_notification
                data.sms_notification = sms_notification
                data.City = str_city as String
                data.State = str_state as String
                data.Zipcode = str_zipcoe as String
                data.Range = rangeLbl.text!
                Parsing().DiscoverUpdateProfile(data: data)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUpdateProfile"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverUpdateProfile), name: NSNotification.Name(rawValue: "DiscoverUpdateProfile"), object: nil)
                
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
                //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Internet Connection not Available!" , buttonTitle: "OK")
            }
        }
    }
    @IBAction func changePasswordBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cameraBTnAction(_ sender: Any) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerController.SourceType.camera
        present(picker, animated: true, completion: nil)
    }
    func openGallary()
    {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        chosenImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        profileImageview.image = chosenImage
        profileImageview.image = self.resizeImage(chosenImage)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY hh:mm:ss"
        let dateExtension = formatter.string(from: date)
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dateExtension).appending(".png")
        print(paths)
        
        imagedata = chosenImage.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: paths as String, contents: imagedata, attributes: nil)
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    func resizeImage(_ image:UIImage) -> UIImage
    {
        let actualHeight = Int(image.size.height);
        let actualWidth = Int(image.size.width);
        let compressionQuality:CGFloat = 0.3;//50 percent compression
        
        let newsizeWidth = CGFloat( actualWidth ) * CGFloat(compressionQuality)
        let newsizeHeight = CGFloat( actualHeight ) * CGFloat(compressionQuality)
        let newSize = CGSize(width: newsizeWidth , height: newsizeHeight);
        
        // Scale the original image to match the new size.
        UIGraphicsBeginImageContext(newSize);
        image.draw(in: CGRect(x: 0, y: 0 , width: newSize.width , height: newSize.height))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        return compressedImage!
        
    }
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
