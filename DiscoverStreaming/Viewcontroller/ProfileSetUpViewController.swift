//
//  ProfileSetUpViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 04/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import MapKit

class ProfileSetUpViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,GMSMapViewDelegate {

    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var locationTxt: FloatLabelTextField!
    @IBOutlet weak var genderTxt: FloatLabelTextField!
    @IBOutlet weak var dobTxt: FloatLabelTextField!
    @IBOutlet weak var countryTxt: FloatLabelTextField!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    var str_location = NSString()
    var str_gener = NSString()
    var str_dob = NSString()
    
    var str_name = String()
    var str_email = String()
    var userid = Int()
    var defaults:UserDefaults!
    var chosenImage = UIImage()
    var imagedata: Data!
    var picker = UIImagePickerController()
    var Gender = String()
    var datePickerView  : UIDatePicker = UIDatePicker()
    var PickerView  : UIPickerView = UIPickerView()
    
    var gender = ["Male","Female"]
    var user_name:String!
    var user_email:String!
    var user_profile:String!
    
    @IBOutlet weak var cityTxt: FloatLabelTextField!
    
    @IBOutlet weak var stateTxt: FloatLabelTextField!
    
    @IBOutlet weak var zipcodeTxt: FloatLabelTextField!
    private(set) var selectedRow: Int = 0
    
    var str_city: NSString!
    var str_state:NSString!
    var str_zipcoe:NSString!
    
    var city:String!
    var state:String!
    var country:String!
    var zipcode:String!
    var addres:String!
    
    @objc func DiscoverProfile(_ notification: Notification) {
        
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
                self.user_name = response.value(forKey: "full_name") as? String
                self.user_email = response.value(forKey: "email") as? String
                self.user_profile  = response.value(forKey: "profile_picture") as? String
                self.defaults.removeObject(forKey: "SHOEVEN")
                self.defaults.removeObject(forKey: "SHOWAR")
                let deafults = UserDefaults.standard
                deafults.set("1", forKey: "Logoutstatus")
                deafults.setValue(self.user_name, forKey: "FullName")
                deafults.setValue(self.user_email, forKey: "Forgotemail")
                deafults.setValue(self.user_profile, forKey: "User_pic")
                deafults.synchronize()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                self.navigationController?.pushViewController(vc!, animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverProfileSetUp"), object: nil)
                self.removeAllOverlays()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        userid = defaults.integer(forKey: "UserIDGet")
        str_name = defaults.value(forKey: "FullName") as! String
        str_email = defaults.value(forKey: "Forgotemail") as! String
        nameLbl.text = str_name
        emailLbl.text = str_email
        updateBtn.layer.cornerRadius = 25
        PickerView.delegate = self
        PickerView.dataSource = self
        locationTxt.delegate = self
        genderTxt.delegate = self
        
        
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        dobTxt.inputView = datePickerView
        datePickerView.maximumDate = Date()
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: UIControl.Event.valueChanged)
        
        genderTxt.inputView = PickerView
        
        picker.delegate = self
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("PROFILESETUP"), object: nil)
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.layer.masksToBounds = true
        profilePicture.clipsToBounds = true
    

        // Do any additional setup after loading the view.
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        city = defaults.value(forKey: "CITY") as? String
        state = defaults.value(forKey: "STATE") as? String
        country = defaults.value(forKey: "COUNTRY") as? String
        zipcode = defaults.value(forKey: "ZIPCODE") as? String
        addres = defaults.value(forKey: "ADDRESS") as? String
        view.endEditing(true)
        locationTxt.text = addres
        cityTxt.text = city
        stateTxt.text = state
        countryTxt.text = country
        zipcodeTxt.text = zipcode
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
//        if textField == locationTxt {
//            let acController = GMSAutocompleteViewController()
//            acController.delegate = self
//            
//            let filter = GMSAutocompleteFilter()
//            filter.type = .address
//            acController.autocompleteFilter = filter
//            
//            self.present(acController, animated: true, completion: nil)
//        }
//        else {
//        }
        
            if textField == genderTxt{
                if genderTxt.text == "" {
                      self.pickerView(PickerView, didSelectRow: 0, inComponent: 0)
                }else if genderTxt.text == "Male" {
                     self.pickerView(PickerView, didSelectRow: 0, inComponent: 0)
                }else {
                    
                }
              
            }else if textField == locationTxt {
                let vc = storyboard?.instantiateViewController(withIdentifier: "SelectAddressViewController") as! SelectAddressViewController
                navigationController?.pushViewController(vc, animated: true)
                locationTxt.resignFirstResponder()
        }
    }
    
    
    
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
    
  
    
    //MARK:- Date Button Action
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dobTxt.text = dateFormatter.string(from: sender.date)
//        let dateObj = dateFormatter.date(from: txt_DOB.text!)
//        selctdate = dateObj!
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
        }else if str_city .isEqual(to: "") {
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
        }else if str_state .isEqual(to: "") {
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
        }else if str_zipcoe .isEqual(to: "") {
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
                let data = Editdatamodel()
                if imagedata == nil {
                }
                else {
                    data.profile_picture = imagedata as NSData
                }
                data.userID = userid
                data.email = str_email
                data.full_name = str_name
                data.location = str_location as String
                data.dob = str_dob as String
                data.gender = Gender
                data.City = str_city as String
                data.State = str_state as String
                data.Zipocode = str_zipcoe as String
                Parsing().DiscoverProfileSetUp(data: data)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverProfileSetUp"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverProfile), name: NSNotification.Name(rawValue: "DiscoverProfileSetUp"), object: nil)
                
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
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func cameraBtnaction(_ sender: Any) {
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
        profilePicture.image = chosenImage
        profilePicture.image = self.resizeImage(chosenImage)
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
    
}

// Handle the user's selection.
extension ProfileSetUpViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        locationTxt.text = place.formattedAddress
        // Do something with the selected place.
        print("Pickup Place name: ", place.name)
        print("Pickup Place address: ", place.formattedAddress!)
        print("Pickup Place attributions: ", place.placeID)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    
}

