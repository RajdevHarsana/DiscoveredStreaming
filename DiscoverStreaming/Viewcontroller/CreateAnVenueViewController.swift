//
//  CreateAnVenueViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 05/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit
import AVFoundation
import AssetsLibrary
import Photos
import AVKit
import DKImagePickerController
import MobileCoreServices
import SwiftToast
import AutoCompletion
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import MapKit
import CoreLocation
class CreateAnVenueViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,GMSMapViewDelegate,UITextFieldDelegate,UITextViewDelegate {
   
    

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var venueNameLbl: FloatLabelTextField!
    @IBOutlet weak var AddressTxt: FloatLabelTextField!
    @IBOutlet weak var stateTxt: FloatLabelTextField!
    @IBOutlet weak var cityTxt: FloatLabelTextField!
    @IBOutlet weak var zipcodeTxt: FloatLabelTextField!
    @IBOutlet weak var ambienceTxt: FloatLabelTextField!
    @IBOutlet weak var aboutVenueTxtview: UITextView!
    @IBOutlet weak var venueImageCollectionview: UICollectionView!
    @IBOutlet weak var collectionHeightCons: NSLayoutConstraint!
    @IBOutlet weak var countyTxt: FloatLabelTextField!
    
    @IBOutlet weak var titleLbl: UILabel!
    var imageArray = NSMutableArray()
    var CollectionImageArray = NSMutableArray()
    var picker = UIImagePickerController()
    var chosenImage = UIImage()
    var imagedata: Data!
    var assets: [DKAsset]?
    let types: [DKImagePickerControllerAssetType] = [.allAssets, .allPhotos, .allAssets]
    var pickerController: DKImagePickerController!
    
    var str_VenueName:NSString!
    var str_VenueAddress:NSString!
    var str_State:NSString!
    var str_City:NSString!
    var str_ZipCode:NSString!
    var str_Ambience:NSString!
    var str_Country:NSString!
    var str_Aboutvenue:NSString!
    var ArtistId:Int!
    var defaults:UserDefaults!
    var user_Id:Int!
    
    var street_number = String()
    var locality  = String()
    var  administrative_area_level_1 = String()
    var country = String()
    var route = String()
    var postalCode = String()
    var str_latitude: NSString!
    var str_longitude: NSString!
    var strvn:String!
    var venid:Int!
    var imagear = NSMutableArray()
    var deleteArray = NSMutableArray()
    var newiamge = NSArray()
    var Addproof:String!
    var Ownproof:String!
    var Idproof:String!
    var imageidarray = NSArray()
    var idv:Int!
    var delArray = NSMutableArray()
    //MARK:- Artist Detail WebService
    @objc func DiscoverVenueDetailAction(_ notification: Notification) {
        
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
                self.venueNameLbl.text = response.value(forKey: "venue_name") as? String
                self.AddressTxt.text = response.value(forKey: "address") as? String
                self.countyTxt.text = response.value(forKey: "country") as? String
                self.stateTxt.text = response.value(forKey: "state") as? String
                self.cityTxt.text = response.value(forKey: "city") as? String
                var Zip:Int!
                Zip = response.value(forKey: "zipcode") as? Int
                var Zipcode = String()
                Zipcode = String(Zip)
                self.zipcodeTxt.text = Zipcode
                var cap:Int!
                cap = response.value(forKey: "ambience") as? Int
                var capcity = String()
                capcity = String(cap)
                self.ambienceTxt.text = capcity
                self.aboutVenueTxtview.text = response.value(forKey: "about_venue") as? String
                self.idv = response.value(forKey: "id") as? Int
                self.imagear = response.value(forKey: "venue_image") as! NSMutableArray
                self.newiamge = (self.imagear.value(forKey: "image") as? NSArray)!
                self.imageidarray = (self.imagear.value(forKey: "id") as? NSArray)!
                for i in 0..<self.newiamge.count {
                    var imageurl = String()
                    imageurl = self.newiamge.object(at:i) as! String
                    let AddPicture_url: NSURL = NSURL(string: imageurl)!
                    let imageData = try! Data(contentsOf: AddPicture_url as URL)
                    self.imageArray.add(imageData)
                    
                }
                
                for i in 0..<self.imageidarray.count - 1 {
                    var imageurl = Int()
                    imageurl = self.imageidarray.object(at:i) as! Int
                    self.deleteArray.add(imageurl)
                    
                }
                
                
                
                self.Addproof = response.value(forKey: "address_proof") as? String
                self.Ownproof = response.value(forKey: "owner_ship") as? String
                self.Idproof = response.value(forKey: "id_proof") as? String
               
                self.CollectionImageArray = NSMutableArray(array: self.newiamge)
                
                if self.CollectionImageArray.count == 0 {
                    self.collectionHeightCons.constant = 0
                }else {
                     self.collectionHeightCons.constant = 130
                    self.venueImageCollectionview.reloadData()
                }
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.layer.cornerRadius = 25
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        ArtistId = defaults.integer(forKey: "ARNewID")
        venid = defaults.integer(forKey: "ARVenID")
        strvn = defaults.value(forKey: "VnAdd") as? String
        if strvn == "Add"{
             self.titleLbl.text = "Create Venue"
        }else {
            self.titleLbl.text = "Edit Venue"
            if Reachability.isConnectedToNetwork() == true {
                
                showWaitOverlay()
                Parsing().DiscoverVenueDetail(UserId: user_Id, Venue_id: venid)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverVenueDetailAction), name: NSNotification.Name(rawValue: "DiscoverVenueDetail"), object: nil)
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
        
        picker.delegate = self
        AddressTxt.delegate = self
        venueNameLbl.delegate = self
        ambienceTxt.delegate = self
        aboutVenueTxtview.text = "About the venue"
        aboutVenueTxtview.delegate = self
        stateTxt.delegate = self
        cityTxt.delegate = self
        zipcodeTxt.delegate = self
        countyTxt.delegate = self
        venueImageCollectionview.delegate = self
        venueImageCollectionview.dataSource = self
        collectionHeightCons.constant = 0
        venueNameLbl.attributedPlaceholder = NSAttributedString(string:"Venue Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        ambienceTxt.attributedPlaceholder = NSAttributedString(string:"Capacity", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        stateTxt.attributedPlaceholder = NSAttributedString(string:"State Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        cityTxt.attributedPlaceholder = NSAttributedString(string:"City Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        zipcodeTxt.attributedPlaceholder = NSAttributedString(string:"Zip Code", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        AddressTxt.attributedPlaceholder = NSAttributedString(string:"Address", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        countyTxt.attributedPlaceholder = NSAttributedString(string:"Country", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        // Do any additional setup after loading the view.
    }
    
   
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == AddressTxt {
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            
            let filter = GMSAutocompleteFilter()
            filter.type = .address
            acController.autocompleteFilter = filter
            
            self.present(acController, animated: true, completion: nil)
        }else {
            
        }
       
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == venueNameLbl {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 55
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
        }else  if textField == ambienceTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 8
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
        }
        else {
            return true
        }
    }
    func isBlank (_ textfield:UITextField) -> Bool {
        
        let thetext = textfield.text
        let trimmedString = thetext!.trimmingCharacters(in: CharacterSet.whitespaces)
        if trimmedString.isEmpty {
            return true
        }
        return false
    }
    func validate(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }
    
    func validate(whiteSpaceString: String) -> Bool {
        return whiteSpaceString.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
    
   
    func fetchImageData(){
                var dict = [String: Any]()
                 if self.assets != nil{
        
                    self.CollectionImageArray.removeAllObjects()
                    var isEnter: Bool = false
                    for index in 0..<(self.assets?.count)!{
        
                        let asset = self.assets![index]
                        asset.fetchImage(with: CGSize(width: 800, height: 800), completeBlock: { image, info in
                       // asset.fetchImageWithSize(CGSize(width: 800, height: 800), completeBlock: { image, info in
        
        
                            if isEnter == true{
                                dict["type"] = "image"
                                dict["content"] = image
        
                                let imageData_two = image!.jpegData(compressionQuality: 0.5)
        
                                self.CollectionImageArray.add(imageData_two!)
                              
//                                print(self.CollectionImageArray)
//                                print("imageArray: \(self.imageArray.count)")
//                                print("CollectionImageArray: \(self.CollectionImageArray.count)")
//                                print("index = \(index)")
                                var imageurl = Data()
                                for i in 0..<self.CollectionImageArray.count {
                                    imageurl = self.CollectionImageArray.object(at:i) as! Data
                                    
                                }
                                self.imageArray.add(imageurl)
                                self.collectionHeightCons.constant = 130
                                self.venueImageCollectionview.reloadData()
                            }
        
                        })
        
        
                    }
                    isEnter = true
                    self.venueImageCollectionview.reloadData()
                }
        }
    

    @IBAction func UploadImageBtnAction(_ sender: Any) {
       
        let types: [DKImagePickerControllerAssetType] = [.allAssets, .allPhotos, .allAssets]
        let assetType = types[1]
        
        let sourceType: DKImagePickerControllerSourceType =  .both
        self.showImagePickerWithAssetType(
            assetType,
            sourceType: sourceType,singleSelect:false)
    }
    func showImagePickerWithAssetType(_ assetType: DKImagePickerControllerAssetType,sourceType: DKImagePickerControllerSourceType = .both,singleSelect: Bool) {
        
        let pickerController = DKImagePickerController()
        pickerController.assetType = assetType
        pickerController.sourceType = sourceType
        pickerController.singleSelect = singleSelect
        pickerController.allowMultipleTypes = true
//        if self.imageArray.count == 0 {
//            pickerController.assetType = assetType
//            pickerController.sourceType = sourceType
//            pickerController.singleSelect = singleSelect
//            pickerController.allowMultipleTypes = true
//            pickerController.maxSelectableCount = 5
//        }
//        else if self.imageArray.count == 1 {
//            pickerController.assetType = assetType
//            pickerController.sourceType = sourceType
//            pickerController.singleSelect = singleSelect
//            pickerController.allowMultipleTypes = true
//           pickerController.maxSelectableCount = 4
//        }else if self.imageArray.count == 2 {
//            pickerController.assetType = assetType
//            pickerController.sourceType = sourceType
//            pickerController.singleSelect = singleSelect
//            pickerController.allowMultipleTypes = true
//             pickerController.maxSelectableCount = 3
//        }else if self.imageArray.count == 3 {
//            pickerController.assetType = assetType
//            pickerController.sourceType = sourceType
//            pickerController.singleSelect = singleSelect
//            pickerController.allowMultipleTypes = true
//             pickerController.maxSelectableCount = 2
//        }else if self.imageArray.count == 4 {
//            pickerController.assetType = assetType
//            pickerController.sourceType = sourceType
//            pickerController.singleSelect = singleSelect
//           // pickerController.allowMultipleTypes = true
//             pickerController.maxSelectableCount = 1
//        }else {
//            pickerController.assetType = assetType
//            pickerController.sourceType = sourceType
//            pickerController.singleSelect = singleSelect
//            pickerController.allowMultipleTypes = true
//            pickerController.maxSelectableCount = 5
//        }
//
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets.count)
            
            print(assets.count)
            if assets.count > 0{
            self.assets = assets
                self.fetchImageData()
                
            }
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        self.present(pickerController, animated: true) {}
    }
    
   
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VenueImageCell
//            var image = String()
//            image  = self.newiamge.object(at: indexPath.item) as! String
//            let AddPicture_url: NSURL = NSURL(string: image)!
//            let testImage = NSData(contentsOf: AddPicture_url as URL)
//            let image_show = UIImage(data: testImage! as Data)
//            cell.venueImage.image = image_show
            //cell.venueImage.sd_setImage(with:AddPicture_url as URL, placeholderImage: UIImage(named: "Group 4-1"))
        let image_show = UIImage(data: self.imageArray[indexPath.row] as! Data)
        cell.venueImage.image = image_show
        cell.cancleBtn.tag = indexPath.item
        cell.cancleBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func handleTap(_ sender:UIButton){
        
        if strvn == "Add"{
            DispatchQueue.main.async(execute: {
                var dict = Data()
                dict = self.imageArray.object(at: sender.tag) as! Data
                self.imageArray.removeObject(at: sender.tag)
                if self.imageArray.count == 0 {
                 self.collectionHeightCons.constant = 0
            }else{
                 self.collectionHeightCons.constant = 130
            }
                self.venueImageCollectionview.reloadData()
        })
        }else {
            DispatchQueue.main.async(execute: {
                if self.deleteArray.count >= sender.tag{
                var dict = Data()
                var Id = Int()
                dict = self.imageArray.object(at: sender.tag) as! Data
               // Id = self.deleteArray.object(at: sender.tag) as! Int
               // self.delArray.add(Id)
               // print(self.delArray)
                self.imageArray.removeObject(at: sender.tag)
              //  self.deleteArray.removeObject(at: sender.tag)
                if self.imageArray.count == 0 {
                 self.collectionHeightCons.constant = 0
            }else{
                 self.collectionHeightCons.constant = 130
            }
                self.venueImageCollectionview.reloadData()
            }
        })
        }
       
}
    
   
    // MARK:- UITextViewDelegates
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "About the venue" {
            textView.text = ""
            textView.textColor = UIColor.white
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        if textView.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            guard range.location == 0 else {
                return true
            }
            let currentString: NSString = (textView.text ?? "About the venue") as NSString
            let newString = currentString.replacingCharacters(in: range, with: text)
            return  validate(string: newString)
        }else {
            
            let maxLength = 255
            let currentString: NSString = textView.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: text) as NSString
            return newString.length <= maxLength
        }
        // return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "About the venue"
            textView.textColor = UIColor.white
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func nextBtnAction(_ sender: Any) {
        if strvn == "Add"{
            str_VenueName = venueNameLbl.text as NSString?
            str_VenueAddress  = AddressTxt.text as NSString?
            str_State = stateTxt.text as NSString?
            str_City = cityTxt.text as NSString?
            str_ZipCode = zipcodeTxt.text as NSString?
            str_Ambience = ambienceTxt.text as NSString?
            str_Aboutvenue = aboutVenueTxtview.text as NSString?
            str_Country = countyTxt.text as NSString?
            if str_VenueName .isEqual(to: ""){
                let test =  SwiftToast(
                    text: "Please Enter Venue Name",
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
            }else if str_VenueAddress .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Venue Address",
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
            }else if str_Country .isEqual(to: "") {
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
            else if str_State .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Venue State",
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
                    text: "Please Enter Venue City",
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
            }else if str_Ambience .isEqual(to: "") {
                let test =  SwiftToast(
                    text: "Please Enter Venue Ambience",
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
            }else if str_Ambience .isEqual(to: "0") {
                let test =  SwiftToast(
                    text: "Please enter valid venue ambience",
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
            }else if str_Ambience .isEqual(to: "00") {
                let test =  SwiftToast(
                    text: "Please enter valid venue ambience",
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
            }else if str_Ambience .isEqual(to: "000") {
                let test =  SwiftToast(
                    text: "Please enter valid venue ambience",
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
            }else if str_Ambience .isEqual(to: "0000") {
                let test =  SwiftToast(
                    text: "Please enter valid venue ambience",
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
            }else if str_Ambience .isEqual(to: "00000") {
                let test =  SwiftToast(
                    text: "Please enter valid venue ambience",
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
            }else if str_Ambience .isEqual(to: "000000") {
                let test =  SwiftToast(
                    text: "Please enter valid venue ambience",
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
            }else if str_Ambience .isEqual(to: "0000000") {
                let test =  SwiftToast(
                    text: "Please enter valid venue ambience",
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
            }else if str_Ambience .isEqual(to: "00000000") {
                let test =  SwiftToast(
                    text: "Please enter valid venue ambience",
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
            else if str_Aboutvenue .isEqual(to:  "About the venue") {
                let test =  SwiftToast(
                    text: "Please Enter Venue Description",
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
            }else if imageArray.count == 0 {
                let test =  SwiftToast(
                    text: "Please upload at least one image",
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
                let defaults = UserDefaults.standard
                defaults.set(str_VenueName, forKey: "VenueName")
                defaults.set(str_VenueAddress, forKey: "VenueAddress")
                defaults.set(str_State, forKey: "VenueState")
                defaults.set(str_City, forKey: "VenueCity")
                defaults.set(str_ZipCode, forKey: "VenueZip")
                defaults.set(str_Ambience, forKey: "VenueAbience")
                defaults.set(str_Aboutvenue, forKey: "AboutVence")
                defaults.set(str_Country, forKey: "VenueCountry")
                defaults.set(imageArray, forKey: "ImageArray")
                defaults.set(str_latitude, forKey: "Lat")
                defaults.set(str_longitude, forKey: "Long")
                defaults.synchronize()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostVenueRequetsViewController") as! PostVenueRequetsViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }else {
        str_VenueName = venueNameLbl.text as NSString?
        str_VenueAddress  = AddressTxt.text as NSString?
        str_State = stateTxt.text as NSString?
        str_City = cityTxt.text as NSString?
        str_ZipCode = zipcodeTxt.text as NSString?
        str_Ambience = ambienceTxt.text as NSString?
        str_Aboutvenue = aboutVenueTxtview.text as NSString?
        str_Country = countyTxt.text as NSString?
        if str_VenueName .isEqual(to: ""){
            let test =  SwiftToast(
                text: "Please Enter Venue Name",
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
        }else if str_VenueAddress .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Venue Address",
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
        }else if str_Country .isEqual(to: "") {
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
        else if str_State .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Venue State",
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
                text: "Please Enter Venue City",
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
        }else if str_Ambience .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter Venue Ambience",
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
        }else if str_Ambience .isEqual(to: "0") {
            let test =  SwiftToast(
                text: "Please enter valid venue ambience",
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
        }else if str_Ambience .isEqual(to: "00") {
            let test =  SwiftToast(
                text: "Please enter valid venue ambience",
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
        }else if str_Ambience .isEqual(to: "000") {
            let test =  SwiftToast(
                text: "Please enter valid venue ambience",
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
        }else if str_Ambience .isEqual(to: "0000") {
            let test =  SwiftToast(
                text: "Please enter valid venue ambience",
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
        }else if str_Ambience .isEqual(to: "00000") {
            let test =  SwiftToast(
                text: "Please enter valid venue ambience",
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
        }else if str_Ambience .isEqual(to: "000000") {
            let test =  SwiftToast(
                text: "Please enter valid venue ambience",
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
        }else if str_Ambience .isEqual(to: "0000000") {
            let test =  SwiftToast(
                text: "Please enter valid venue ambience",
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
        }else if str_Ambience .isEqual(to: "00000000") {
            let test =  SwiftToast(
                text: "Please enter valid venue ambience",
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
        else if str_Aboutvenue .isEqual(to:  "About the venue") {
            let test =  SwiftToast(
                text: "Please Enter Venue Description",
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
        }else if imageArray.count == 0 {
            let test =  SwiftToast(
                text: "Please upload at least one image",
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
              let defaults = UserDefaults.standard
              defaults.set(str_VenueName, forKey: "VenueName")
              defaults.set(str_VenueAddress, forKey: "VenueAddress")
              defaults.set(str_State, forKey: "VenueState")
              defaults.set(str_City, forKey: "VenueCity")
              defaults.set(str_ZipCode, forKey: "VenueZip")
              defaults.set(str_Ambience, forKey: "VenueAbience")
              defaults.set(str_Aboutvenue, forKey: "AboutVence")
              defaults.set(str_Country, forKey: "VenueCountry")
              defaults.set(imageArray, forKey: "ImageArray")
              defaults.set(str_latitude, forKey: "Lat")
              defaults.set(str_longitude, forKey: "Long")
              defaults.set(Addproof, forKey: "ADDP")
              defaults.set(Ownproof, forKey: "OWNP")
              defaults.set(Idproof, forKey: "IDP")
              defaults.set(idv, forKey: "VId")
              let  typeIdArrayString = self.JSONStringify(value: delArray as AnyObject)
              defaults.set(typeIdArrayString, forKey: "ArraydeleteImage")
              defaults.synchronize()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostVenueRequetsViewController") as! PostVenueRequetsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        
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
   

}

extension CreateAnVenueViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        AddressTxt.text = place.formattedAddress
        cityTxt.text = place.name
        
        let address =  place.formattedAddress
        
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { (plaacemark, error) in
            if plaacemark != nil {
                let placemarks = plaacemark
                let location = placemarks?.first?.location
                let long = location?.coordinate.longitude
                let lat = location?.coordinate.latitude
                self.str_latitude = lat?.debugDescription as NSString?
                self.str_longitude = long?.debugDescription as NSString?
                
                
            }
            else {
                // handle no location found
                
                return
            }
            
            // Use your location
        }
        
        
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    street_number = field.name
                case kGMSPlaceTypeRoute:
                    route = field.name
                case kGMSPlaceTypeLocality:
                    locality = field.name
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    administrative_area_level_1 = field.name
                case kGMSPlaceTypeCountry:
                    country = field.name
                case kGMSPlaceTypePostalCode:
                    postalCode = field.name
                // Print the items we aren't using.
                default:
                    print("Type: \(field.type), Name: \(field.name)")
                }
            }
        }
        fillAddressForm()
        dismiss(animated: true, completion: nil)
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func fillAddressForm() {
        AddressTxt.text = street_number + " " + route
        cityTxt.text = locality
        stateTxt.text = administrative_area_level_1
        zipcodeTxt.text = postalCode
        countyTxt.text = country
        // Clear values for next time.
        street_number = ""
        locality = ""
        route = ""
        administrative_area_level_1  = ""
        country = ""
        postalCode = ""
        
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
