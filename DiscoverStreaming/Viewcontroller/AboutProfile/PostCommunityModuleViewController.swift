//
//  PostCommunityModuleViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 05/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class PostCommunityModuleViewController: UIViewController,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var uploadByn: UIButton!
    @IBOutlet weak var postTitleTxt: FloatLabelTextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var nameTxt: FloatLabelTextField!
    @IBOutlet weak var bandTxt: FloatLabelTextField!
    @IBOutlet weak var bandTxtHeighjtCons: NSLayoutConstraint!
    @IBOutlet weak var linelblHeightCons: NSLayoutConstraint!
    var picker = UIImagePickerController()
    var str_postTitle:NSString!
    var str_postDescription:NSString!
    var chosenImage = UIImage()
    var imagedata: Data!
    var userid = Int()
    var defaults:UserDefaults!
    var artistId:Int!
    var artistId1:Int!
    var str:String!
    var response = NSMutableArray()
    var pickerview  : UIPickerView = UIPickerView()
    var pickerview1  : UIPickerView = UIPickerView()
    var nameArray:NSArray!
    var idArray: NSArray!
    var bandid:Int!
    var TypeView = [String()]
    var artistnew:Int!
    var bnadnew:Int!
    var venunew:Int!
    var arid:String!
    var posttype:String!
    var idpost:Int!
    var strnew:String!
    @objc func DiscoverCreatePostAction(_ notification: Notification) {
        
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
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                self.arid = response.value(forKey: "artist_id") as? String
                var arnewid = Int()
                arnewid = Int(self.arid)!
                let defaults = UserDefaults.standard
                defaults.set(arnewid, forKey: "ARNewID")
                defaults.synchronize()
                print("response: \(response)")
                NotificationCenter.default.post(name: NSNotification.Name("PostCommunity"), object: nil)
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreatePost"), object: nil)
                self.removeAllOverlays()
                
            }
        }
    }
    
    
    @objc func DiscoverUpdatePostAction(_ notification: Notification) {
        
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
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUpdatePost"), object: nil)
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
                self.arid = response.value(forKey: "artist_id") as? String
                var arnewid = Int()
                arnewid = Int(self.arid)!
                let defaults = UserDefaults.standard
                defaults.set(arnewid, forKey: "ARNewID")
                defaults.synchronize()
                print("response: \(response)")
                NotificationCenter.default.post(name: NSNotification.Name("UpdatePostCommunity"), object: nil)
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUpdatePost"), object: nil)
                self.removeAllOverlays()
                
            }
        }
    }
    
    
    @objc func DiscoverEditPostAction(_ notification: Notification) {
        
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
                var response = NSMutableDictionary()
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                print("response: \(response)")
                self.postTitleTxt.text = response.value(forKey: "post_title") as? String
                self.descriptionView.text = response.value(forKey: "description") as? String
                self.postImage.sd_setImage(with: URL(string: (response.value(forKey: "post_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                var posttype:String!
                posttype = response.value(forKey: "post_type") as? String
                if posttype == "artist" {
                    self.nameTxt.text = "artist"
                    self.nameTxt.placeholder = "artist"
                    self.bandTxtHeighjtCons.constant = 0
                    self.linelblHeightCons.constant = 0
                }else if posttype == "band" {
                    self.nameTxt.placeholder = "band"
                    self.bandTxtHeighjtCons.constant = 50
                    self.bandTxt.placeholder = "band"
                    self.linelblHeightCons.constant = 1
                    self.nameTxt.text = "band"
                    self.bandTxt.text = response.value(forKey: "name") as? String
                }else {
                    self.nameTxt.placeholder = "venue"
                    self.nameTxt.text = "venue"
                    self.bandTxtHeighjtCons.constant = 50
                    self.bandTxt.placeholder = "venue"
                    self.linelblHeightCons.constant = 1
                    self.bandTxt.text = response.value(forKey: "name") as? String
                }
                
                self.removeAllOverlays()
                
            }
        }
    }
    
    
   
    @objc func DiscoverBandList1Action(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                self.nameArray = self.response.value(forKey: "name") as? NSArray
                self.idArray = self.response.value(forKey: "id") as? NSArray
//                for i in 0...self.idArray.count{
//                    self.bandid = self.idArray.object(at: i) as? Int
//                    break
//                }
//
              
                print("response: \(String(describing: self.response))")
                self.removeAllOverlays()
            }
        }
    }
    
    @objc func DiscoverGetUserRoleAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
            }
            else{
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                self.artistnew = response.value(forKey: "artist") as? Int
                self.bnadnew = response.value(forKey: "band") as? Int
                self.venunew = response.value(forKey: "venue") as? Int
                if self.artistnew == 1 && self.bnadnew == 1 && self.venunew == 1 {
                    self.TypeView = ["artist","band","venue"]
                }else if self.artistnew == 1 && self.bnadnew == 1 && self.venunew == 0 {
                    self.TypeView = ["artist","band"]
                }else if self.artistnew == 1 && self.bnadnew == 0 && self.venunew == 0{
                    self.TypeView = ["artist"]
                }else if self.artistnew == 1 && self.bnadnew == 0 && self.venunew == 1 {
                    self.TypeView = ["artist","venue"]
                }else if self.artistnew == 0 && self.bnadnew == 0 && self.venunew == 1 {
                    self.TypeView = ["venue"]
                }else if self.artistnew == 0 && self.bnadnew == 0 && self.venunew == 0 {
                   
                }
                self.removeAllOverlays()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        userid = defaults.integer(forKey: "UserIDGet")
        artistId = defaults.integer(forKey: "ARNewID")
        posttype = defaults.value(forKey: "postType") as? String
        idpost = defaults.integer(forKey: "pstid")
        strnew = defaults.value(forKey: "padd") as? String
       // artistId1 = defaults.integer(forKey: "ArtistID")
       // str = defaults.value(forKey: "SelfAR") as? String
       
        if posttype == "artist" {
            nameTxt.text = "artist"
            nameTxt.placeholder = "artist"
            self.bandTxtHeighjtCons.constant = 0
            linelblHeightCons.constant = 0
        }else if posttype == "band" {
            nameTxt.placeholder = "band"
            self.bandTxtHeighjtCons.constant = 50
            self.bandTxt.placeholder = "band"
            linelblHeightCons.constant = 1
             nameTxt.text = "band"
            Parsing().DiscoverRetaltedPostList(UserId: userid, RelatedType: "band")
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBandList1Action), name: NSNotification.Name(rawValue: "DiscoverRetaltedPostList"), object: nil)
        }else {
            nameTxt.placeholder = "venue"
            nameTxt.text = "venue"
            self.bandTxtHeighjtCons.constant = 50
            self.bandTxt.placeholder = "venue"
            linelblHeightCons.constant = 1
            Parsing().DiscoverRetaltedPostList(UserId: userid, RelatedType: "venue")
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBandList1Action), name: NSNotification.Name(rawValue: "DiscoverRetaltedPostList"), object: nil)
        }
     
        nameArray = NSArray()
        idArray = NSArray()
        //pickerview.delegate = self
       // pickerview.dataSource = self
        pickerview1.delegate = self
        pickerview1.dataSource = self
        //nameTxt.inputView = pickerview
        bandTxt.inputView = pickerview1
        submitBtn.layer.cornerRadius = 25
        descriptionView.delegate = self
        descriptionView.text = "Description"
        
        if strnew == "Add" {
            
        }else {
            if Reachability.isConnectedToNetwork() == true{
            showWaitOverlay()
            Parsing().DiscoverPostDetail(UserId: userid, PostId: idpost)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverEditPostAction), name: NSNotification.Name(rawValue: "DiscoverPostDetail"), object: nil)
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
                self.response.removeAllObjects()
            }
        }
      
        
        if Reachability.isConnectedToNetwork() == true{
            Parsing().DiscoverGetUserRole()
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverGetUserRoleAction), name: NSNotification.Name(rawValue: "DiscoverGetUserRole"), object: nil)
           
        
        }else{
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
            self.response.removeAllObjects()
        }
    }
    
    // PickerView Delegate.....
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
//        if pickerView == pickerview {
//        return TypeView.count
//        }else {
            return nameArray.count
       // }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView == pickerview {
//            return TypeView[row]
//        }else {
            return nameArray[row] as? String
      //  }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
//        if pickerView == pickerview {
//             if self.artistnew == 1 && self.bnadnew == 1 && self.venunew == 1 {
//            if row == 0 {
//                nameTxt.text = TypeView[row]
//                self.bandTxtHeighjtCons.constant = 0
//                linelblHeightCons.constant = 0
//                self.bandTxt.placeholder = "artist"
//                bandTxt.text = ""
//            }else if row == 1 {
//                nameTxt.text = TypeView[row]
//                self.bandTxtHeighjtCons.constant = 50
//                self.bandTxt.placeholder = "band"
//                linelblHeightCons.constant = 1
//                self.nameTxt.placeholder = "band"
//                bandTxt.text = ""
//               // bandid = idArray[row] as? Int
//                Parsing().DiscoverRetaltedPostList(UserId: userid, RelatedType: "band")
//                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBandList1Action), name: NSNotification.Name(rawValue: "DiscoverRetaltedPostList"), object: nil)
//            }else {
//                nameTxt.text = TypeView[row]
//                self.bandTxtHeighjtCons.constant = 50
//                self.bandTxt.placeholder = "venue"
//                linelblHeightCons.constant = 1
//                self.nameTxt.placeholder = "venue"
//                bandTxt.text = ""
//              //  bandid = idArray[row] as? Int
//                Parsing().DiscoverRetaltedPostList(UserId: userid, RelatedType: "venue")
//                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBandList1Action), name: NSNotification.Name(rawValue: "DiscoverRetaltedPostList"), object: nil)
//
//            }
//             }else if self.artistnew == 1 && self.bnadnew == 1 && self.venunew == 0 {
//                if row == 0 {
//                    nameTxt.text = TypeView[row]
//                    self.bandTxtHeighjtCons.constant = 0
//                    linelblHeightCons.constant = 0
//                    self.bandTxt.placeholder = "artist"
//                    bandTxt.text = ""
//                }else {
//                    nameTxt.text = TypeView[row]
//                    self.bandTxtHeighjtCons.constant = 50
//                    self.bandTxt.placeholder = "band"
//                    linelblHeightCons.constant = 1
//                    self.nameTxt.placeholder = "band"
//                    bandTxt.text = ""
//                  //  bandid = idArray[row] as? Int
//                    Parsing().DiscoverRetaltedPostList(UserId: userid, RelatedType: "band")
//                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBandList1Action), name: NSNotification.Name(rawValue: "DiscoverRetaltedPostList"), object: nil)
//                }
//             }else if self.artistnew == 1 && self.bnadnew == 0 && self.venunew == 0  {
//                nameTxt.text = TypeView[row]
//                self.bandTxtHeighjtCons.constant = 0
//                linelblHeightCons.constant = 0
//                self.bandTxt.placeholder = "artist"
//                bandTxt.text = ""
//             }else if self.artistnew == 1 && self.bnadnew == 0 && self.venunew == 1 {
//                if row == 0 {
//                    nameTxt.text = TypeView[row]
//                    self.bandTxtHeighjtCons.constant = 0
//                    linelblHeightCons.constant = 0
//                    self.bandTxt.placeholder = "artist"
//                    bandTxt.text = ""
//                }else {
//                    nameTxt.text = TypeView[row]
//                    self.bandTxtHeighjtCons.constant = 50
//                    self.bandTxt.placeholder = "venue"
//                    linelblHeightCons.constant = 1
//                    self.nameTxt.placeholder = "venue"
//                    bandTxt.text = ""
//                   // bandid = idArray[row] as? Int
//                    Parsing().DiscoverRetaltedPostList(UserId: userid, RelatedType: "venue")
//                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBandList1Action), name: NSNotification.Name(rawValue: "DiscoverRetaltedPostList"), object: nil)
//
//                }
//             }else if self.artistnew == 0 && self.bnadnew == 0 && self.venunew == 1 {
//                nameTxt.text = TypeView[row]
//                self.bandTxtHeighjtCons.constant = 50
//                self.bandTxt.placeholder = "venue"
//                linelblHeightCons.constant = 1
//                self.nameTxt.placeholder = "venue"
//                bandTxt.text = ""
//               // bandid = idArray[row] as? Int
//                Parsing().DiscoverRetaltedPostList(UserId: userid, RelatedType: "venue")
//                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBandList1Action), name: NSNotification.Name(rawValue: "DiscoverRetaltedPostList"), object: nil)
//            }
//        }
//        else {
            bandTxt.text = nameArray[row] as? String
            bandid = idArray[row] as? Int
       // }
        
      
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    // textview delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description" {
            textView.text = ""
            textView.textColor = UIColor.white
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Description"
            textView.textColor = UIColor.white
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    @IBAction func uploadBtnAction(_ sender: Any) {
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
        postImage.image = chosenImage
        postImage.image = self.resizeImage(chosenImage)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY hh:mm:ss"
        let dateExtension = formatter.string(from: date)
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dateExtension).appending(".png")
        print(paths)
       // uploadByn.isHidden = true
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
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func submitBtnAction(_ sender: Any) {
        if strnew == "Add" {
            str_postTitle = postTitleTxt.text as NSString?
            str_postDescription = descriptionView.text as NSString?
            
            if str_postTitle .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Post Title",
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
            }else if str_postDescription .isEqual(to: "Description") {
                let test =  SwiftToast(
                    text: "Please Enter Post Description",
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
                    let data = CreatePostModel()
                    if imagedata == nil {
                    }
                    else {
                        data.PostImage = imagedata as NSData
                    }
                    data.UserId = userid
                    data.artistID = artistId
                    data.postType = nameTxt.text!
                    if bandid == nil {
                        
                    }else {
                        data.postTypeId = bandid
                    }
                    
                    data.PostTitle = str_postTitle as String
                    data.PostDescroption = str_postDescription as String
                    Parsing().DiscoverCreatePost(data: data)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreatePost"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverCreatePostAction), name: NSNotification.Name(rawValue: "DiscoverCreatePost"), object: nil)
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
        }else {
            str_postTitle = postTitleTxt.text as NSString?
            str_postDescription = descriptionView.text as NSString?
            
            if str_postTitle .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Post Title",
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
            }else if str_postDescription .isEqual(to: "Description") {
                let test =  SwiftToast(
                    text: "Please Enter Post Description",
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
                    let data = UpdatePostModel()
                    if imagedata == nil {
                        
                    }
                    else {
                        data.PostImage = imagedata as NSData
                    }
                    data.UserId = userid
                    data.artistID = artistId
                    data.postType = nameTxt.text!
                    if bandid == nil {
                        
                    }else {
                        data.postTypeId = bandid
                    }
                    
                    data.PostTitle = str_postTitle as String
                    data.PostDescroption = str_postDescription as String
                    data.Id = idpost
                    Parsing().DiscoverUpdatePost(data: data)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUpdatePost"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverUpdatePostAction), name: NSNotification.Name(rawValue: "DiscoverUpdatePost"), object: nil)
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
    

}
