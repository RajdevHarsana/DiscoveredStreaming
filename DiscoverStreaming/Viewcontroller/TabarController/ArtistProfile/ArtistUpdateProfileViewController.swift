//
//  ArtistUpdateProfileViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class ArtistUpdateProfileViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UITextFieldDelegate {
   
    

    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var NameLBl: UILabel!
    @IBOutlet weak var EmailLbl: UILabel!
    @IBOutlet weak var arnameTxt: FloatLabelTextField!
    @IBOutlet weak var contactNumberTxt: FloatLabelTextField!
    @IBOutlet weak var addressTxt: FloatLabelTextField!
    @IBOutlet weak var cityTxt: FloatLabelTextField!
    @IBOutlet weak var stateTxt: FloatLabelTextField!
    @IBOutlet weak var countryTxt: FloatLabelTextField!
    @IBOutlet weak var zipocodeTxt: FloatLabelTextField!
    @IBOutlet weak var aboutTxtview: UITextView!
    
    var response = NSMutableArray()
    var genreArray = NSArray()
    var updateimage:String!
    var Genre_Id:Int!
    var selectedIndexes = NSMutableArray()
    var pricearray = NSMutableArray()
    
    var city:String!
    var state:String!
    var country:String!
    var zipcode:String!
    var addres:String!
    var defaults:UserDefaults!
    var userId:Int!
    var ArtistId:Int!
    var artistUserId:Int!
    var chosenImage = UIImage()
    var imagedata: Data!
    var picker = UIImagePickerController()
    
    
    var str_ArtistName:NSString!
    var str_ArtistMobile:NSString!
    var str_City:NSString!
    var Str_State:NSString!
    var str_zipcode:NSString!
    var str_des:NSString!
    var str_address:NSString!
    var str_country:NSString!
    var idArray = NSArray()
    //MARK:- Login WebService
    @objc func DiscoverGenresAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                
                //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else{
                
                
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(self.response)")
                self.genreArray = (self.response.value(forKey: "id") as? NSArray)!
                // self.pricearray.add(self.genreArray!)
                self.genreCollectionView.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    //MARK:- Artist Detail WebService
    @objc func DiscoverArtistDetailAction(_ notification: Notification) {
        
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
                self.removeAllOverlays()
            }
            else{
                
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(response)")
                self.arnameTxt.text = response.value(forKey: "artist_name") as? String
                self.contactNumberTxt.text = response.value(forKey: "mobile_no") as? String
                self.addressTxt.text = response.value(forKey: "address") as? String
                self.cityTxt.text = response.value(forKey: "city") as? String
                self.stateTxt.text = response.value(forKey: "state") as? String
                self.countryTxt.text = response.value(forKey: "country") as? String
                var zipcode = Int()
                zipcode = response.value(forKey: "zipcode") as! Int
                var zip = String()
                zip = String(zipcode)
                self.zipocodeTxt.text = zip
                self.aboutTxtview.text = response.value(forKey: "description") as? String
                self.NameLBl.text = response.value(forKey: "artist_name") as? String
                self.EmailLbl.text = response.value(forKey: "email") as? String
                self.updateimage = response.value(forKey: "artist_image") as? String
                self.profileImageview.sd_setImage(with: URL(string: (response.value(forKey: "artist_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                var genArr = NSMutableArray()
                genArr = response.value(forKey: "genres") as! NSMutableArray
                self.idArray = genArr.value(forKey: "id") as! NSArray
                self.pricearray = NSMutableArray(array: self.idArray)
                print(self.pricearray)
                self.genreArray = genArr.value(forKey: "genre_name") as! NSArray
                self.removeAllOverlays()
            }
        }
    }
    
    //MARK:- Create Artist WebService
    @objc func UpdateArtistAction(_ notification: Notification) {
        
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
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUpdateArtist"), object: nil)
                self.removeAllOverlays()
            }
            else{
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(response)")
                
              //  self.arid = response.value(forKey: "artist_id") as? Int
//                let defaults = UserDefaults.standard
//                defaults.setValue(self.self.arid, forKey: "ARNewID")
//                defaults.set(self.ArtistNameTxt.text!, forKey: "nameofAr")
//                defaults.synchronize()
                
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUpdateArtist"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        ArtistId = defaults.integer(forKey: "ARIDN")
//        artistUserId = defaults.integer(forKey: "ArUserId")
        doneBtn.layer.cornerRadius = 25
        
        addressTxt.delegate = self
        profileImageview.layer.cornerRadius = profileImageview.frame.height/2
        profileImageview.layer.masksToBounds = true
        profileImageview.clipsToBounds = true
        aboutTxtview.delegate = self
        aboutTxtview.text = "Description/About Me"
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("ARTISTUPDATE"), object: nil)
        
        if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().DiscoverArtistDetail(user_Id: userId, Artist_id: ArtistId, ArtistUserId: userId)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverArtistDetailAction), name: NSNotification.Name(rawValue: "DiscoverArtistDetail"), object: nil)
            
            Parsing().GetGenresList()
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverGenresAction), name: NSNotification.Name(rawValue: "GetGenresListNotification"), object: nil)
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
        addressTxt.text = addres
        cityTxt.text = city
        stateTxt.text = state
        countryTxt.text = country
        zipocodeTxt.text = zipcode
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addressTxt {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SelectAddressViewController") as! SelectAddressViewController
            navigationController?.pushViewController(vc, animated: true)
            addressTxt.resignFirstResponder()
        }
    }
    
    // textview delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description/About Me" {
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
            textView.text = "Description/About Me"
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        if response.count>0
        {
            numOfSections            = 1
            collectionView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            noDataLabel.text          = "No Genres Found"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            collectionView.backgroundView  = noDataLabel
        }
        return numOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return response.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ArtistProfileGenreCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.rockBtn.setTitle(dict.value(forKey: "genre_name") as? String, for: .normal)
        if pricearray.contains(dict.object(forKey: "id")!) {
            cell.rockBtn.backgroundColor = UIColor(red: 210/255, green: 20/255, blue: 114/255, alpha: 1.0)
        } else {
            cell.rockBtn.backgroundColor = UIColor.clear
        }
        cell.rockBtn.layer.cornerRadius = 5
        cell.rockBtn.layer.borderColor = UIColor.gray.cgColor
        cell.rockBtn.layer.borderWidth = 1
        cell.rockBtn.tag = indexPath.row
        cell.rockBtn.addTarget(self, action: #selector(HandleTap(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func HandleTap(_ sender: UIButton){
        var btn = sender as? UIButton
        let dict1 = response.object(at: (btn?.tag)!) as! NSDictionary
        
        Genre_Id = dict1.value(forKey: "id") as? Int
        if selectedIndexes == nil {
            
            selectedIndexes = ([AnyHashable]() as? NSMutableArray)!
        }
        if selectedIndexes.contains((btn?.tag)!) {
            selectedIndexes.remove((btn?.tag)!)
            pricearray.remove(Genre_Id!)
            
            
        }
        else {
            selectedIndexes.add((btn?.tag)!)
            pricearray.add(Genre_Id!)
            
        }
        let indexPath = NSIndexPath(row: (btn?.tag)!, section: 0)
        genreCollectionView.reloadItems(at: [indexPath as IndexPath])
        genreCollectionView.reloadData()
    }
   
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func viewProfileBtnAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(self.ArtistId, forKey: "ArtistID")
        defaults.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArtistDetailViewController") as! ArtistDetailViewController
        vc.arName = self.NameLBl.text ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doneBtnAction(_ sender: Any) {
        str_ArtistName = arnameTxt.text as NSString?
        str_ArtistMobile  = contactNumberTxt.text as NSString?
        str_City = cityTxt.text as NSString?
        Str_State = stateTxt.text as NSString?
        str_zipcode = zipocodeTxt.text as NSString?
        str_des = aboutTxtview.text as NSString?
        str_address = addressTxt.text as NSString?
        str_country = countryTxt.text as NSString?
        if str_ArtistName .isEqual(to: ""){
            let test =  SwiftToast(
                text: "Please Enter Artist Name",
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
        }else if str_ArtistMobile .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Artist Mobile Number",
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
        }else if str_ArtistMobile.length < 7 || str_ArtistMobile.length > 15 {
            let test =  SwiftToast(
                text: "Artist mobile number should be 7-15 digits",
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
        }else if str_address .isEqual(to: "") {
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
        }
        else if str_City .isEqual(to: "") {
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
        }else if Str_State .isEqual(to:  "") {
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
        }else if str_country .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Country",
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
        else if str_zipcode .isEqual(to:  "") {
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
        }else if str_des .isEqual(to:  "Description/About Me") {
            let test =  SwiftToast(
                text: "Please Enter Description",
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
        } else if pricearray.count == 0 {
            let test =  SwiftToast(
                text: "Please Select Genres",
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
        else {
            if Reachability.isConnectedToNetwork() == true {
                showWaitOverlay()
                let data = UpdateArtistModel()
                if imagedata == nil {
                    let AddPicture_url: NSURL = NSURL(string: self.updateimage)!
                    let testImage = NSData(contentsOf: AddPicture_url as URL)
                    data.Artist_Image = testImage!
                }
                else {
                    data.Artist_Image = imagedata as NSData
                }
                
                
                data.Id = ArtistId
                data.UserId = userId
                data.ArtistName = str_ArtistName as String
                data.Artist_Mobile = str_ArtistMobile as String
                data.Address = str_address as String
                data.City = str_City as String
                data.State = Str_State as String
                data.Country = str_country as String
                data.Zipcode = str_zipcode as String
                data.Description = str_des as String
                
                let  typeIdArrayString = self.JSONStringify(value: pricearray as AnyObject)
                print(typeIdArrayString)
                
                data.Genres = typeIdArrayString as String
                Parsing().DiscoverUpdateArtist(data: data)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUpdateArtist"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateArtistAction), name: NSNotification.Name(rawValue: "DiscoverUpdateArtist"), object: nil)
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
    
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        if JSONSerialization.isValidJSONObject(value) {
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                print("error")
            }
        }
        return ""
    }
    
    @IBAction func uploadPhotoBtnAction(_ sender: Any) {
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
        let defaults = UserDefaults.standard
        defaults.set(imagedata, forKey: "ARIMAGEDATA")
        defaults.synchronize()
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
