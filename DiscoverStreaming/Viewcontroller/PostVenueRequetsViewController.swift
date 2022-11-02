//
//  PostVenueRequetsViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import MobileCoreServices

class PostVenueRequetsViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate {

    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var uploadIdProofImage: UIImageView!
    @IBOutlet weak var uploadOwnershipImage: UITextField!
    @IBOutlet weak var uploadaddressProofImage: UITextField!
    var name:String!
    var address:String!
    var State:String!
    var City:String!
    var Zipcode:String!
    var ambience:String!
    var aboutavneue:String!
    var user_id:Int!
    var ArtistId:Int!
    var str_lat:String!
    var str_long:String!
    var ImageArray :NSArray!
    var defaults:UserDefaults!
    var Countrry:String!
    
    var str_uploadOwner:NSString!
    var str_addresproof:NSString!
    var picker = UIImagePickerController()
    var chosenImage = UIImage()
    var chosenImage1 = UIImage()
    var chosenImage2 = UIImage()
    var imagedata: Data!
    var imagedata1: Data!
    var imagedata2: Data!
    var strImg:String!
    var path = String()
    var tagvalueBtnSelected:Int!
    var idpr:String!
    var ownpr:String!
    var addpr:String!
    var strvn:String!
    var deleteImageArray:String!
    var venId:Int!
    
    @IBOutlet weak var viewdocbtnOwn: UIButton!
    @IBOutlet weak var viewDocBtnAdd: UIButton!
    //MARK:- Create Artist WebService
    @objc func CreateVenueAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateVenue"), object: nil)
                self.removeAllOverlays()
            }
            else{
               
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverCreateVenue"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults = UserDefaults.standard
        user_id = defaults.integer(forKey: "UserIDGet")
        ArtistId = defaults.integer(forKey: "ARNewID")
        name = defaults.value(forKey: "VenueName") as? String
        address = defaults.value(forKey: "VenueAddress") as? String
        State = defaults.value(forKey: "VenueState") as? String
        City = defaults.value(forKey: "VenueCity") as? String
        Countrry = defaults.value(forKey: "VenueCountry") as? String
        Zipcode = defaults.value(forKey: "VenueZip") as? String
        ambience = defaults.value(forKey: "VenueAbience") as? String
        aboutavneue = defaults.value(forKey: "AboutVence") as? String
        str_lat = defaults.value(forKey: "Lat") as? String
        str_long = defaults.value(forKey: "Long") as? String
        ImageArray = defaults.value(forKey: "ImageArray") as? NSArray
        deleteImageArray = defaults.value(forKey: "ArraydeleteImage") as? String
        addpr = defaults.value(forKey: "ADDP") as? String
        ownpr = defaults.value(forKey: "OWNP") as? String
        idpr = defaults.value(forKey: "IDP") as? String
        strvn = defaults.value(forKey: "VnAdd") as? String
        venId = defaults.integer(forKey: "VId")
        uploadOwnershipImage.tag = 10
        uploadaddressProofImage.tag = 11
        
        if strvn == "Add"{
            self.viewDocBtnAdd.isHidden = true
            self.viewdocbtnOwn.isHidden = true
        }else {
            
            self.viewDocBtnAdd.isHidden = false
            self.viewdocbtnOwn.isHidden = false
            
            self.viewdocbtnOwn.layer.cornerRadius = 8
            self.viewdocbtnOwn.layer.borderWidth = 1
            self.viewdocbtnOwn.layer.borderColor = UIColor.lightGray.cgColor
            
            self.viewDocBtnAdd.layer.cornerRadius = 8
            self.viewDocBtnAdd.layer.borderWidth = 1
            self.viewDocBtnAdd.layer.borderColor = UIColor.lightGray.cgColor
            
            let AddPicture_url: NSURL = NSURL(string: idpr)!
            uploadIdProofImage.sd_setImage(with: AddPicture_url as URL, placeholderImage: UIImage(named: "Group 4-1"))
            imagedata = try! Data(contentsOf: AddPicture_url as URL)
            
            
            let AddPicture_url1: NSURL = NSURL(string: ownpr)!
            imagedata1 = try! Data(contentsOf: AddPicture_url1 as URL)
            uploadOwnershipImage.text = ownpr
            
            let AddPicture_url2: NSURL = NSURL(string: addpr)!
            imagedata2 = try! Data(contentsOf: AddPicture_url2 as URL)
            uploadaddressProofImage.text = addpr
        }
      
        uploadOwnershipImage.attributedPlaceholder = NSAttributedString(string:"Upload ownership proof", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
       uploadaddressProofImage.attributedPlaceholder = NSAttributedString(string:"Upload address proof", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        postBtn.layer.cornerRadius = 25

        // Do any additional setup after loading the view.
    }
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewDoctBtnOwnAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(uploadOwnershipImage.text, forKey: "Image")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewDocViewController") as! ViewDocViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func viewDoctBtnAddAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(uploadaddressProofImage.text, forKey: "Image")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewDocViewController") as! ViewDocViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    func resize(_ image: UIImage) -> UIImage {
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = 100.0
        let maxWidth: Float = 100.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.5
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img?.jpegData(compressionQuality: 0.5)
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!) ?? UIImage()
    }
    @IBAction func postBtnAction(_ sender: Any) {
        str_uploadOwner = uploadOwnershipImage.text as NSString?
        str_addresproof = uploadaddressProofImage.text as NSString?
       if uploadIdProofImage.image == UIImage(named: "Group 4-1"){
            let test =  SwiftToast(
                text: "Please Upload ID Proof",
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
        }else if str_uploadOwner .isEqual(to: ""){
            let test =  SwiftToast(
                text: "Please Upload Ownership Proof",
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
        }else if str_addresproof .isEqual(to: ""){
            let test =  SwiftToast(
                text: "Please Upload Address Proof",
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
        
        if strvn == "Add" {
            if Reachability.isConnectedToNetwork() == true {
                showWaitOverlay()
                let data = CreateVenueModel()
                data.UserId = user_id
                data.ArtistId = ArtistId
                data.VenueName = name
                data.VenueAddress = address
                data.State = State
                data.City = City
                data.Country = Countrry
                data.Zipcode = Zipcode
                data.Ambience = ambience
                data.AboutVenue = aboutavneue
                if str_lat == nil {
                    data.latitude = "27.85965"
                }else {
                    data.latitude = str_lat
                }
                if str_long == nil {
                    data.longitude = "75.891363"
                }else{
                    data.longitude = str_long
                }
                sendMedia1(data: data)
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
        }else {
            if Reachability.isConnectedToNetwork() == true {
                showWaitOverlay()
                let data = UpdateVenueModel()
                data.UserId = user_id
                data.ArtistId = ArtistId
                data.VenueName = name
                data.VenueAddress = address
                data.State = State
                data.City = City
                data.Country = Countrry
                data.Zipcode = Zipcode
                data.Ambience = ambience
                data.AboutVenue = aboutavneue
                data.deleteArray = deleteImageArray
                data.Id = venId
                data.UniqueStr = "ios"
                if str_lat == nil {
                    data.latitude = "27.85965"
                }else {
                    data.latitude = str_lat
                }
                if str_long == nil {
                    data.longitude = "75.891363"
                }else{
                    data.longitude = str_long
                }
                sendMedia2(data: data)
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
 
    func sendMedia1(data: CreateVenueModel){
        
        //Loader Start
        
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.UserId), forKey: "user_id" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.ArtistId), forKey: "artist_id" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.VenueName), forKey: "venue_name" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.VenueAddress), forKey: "address" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.State), forKey: "state" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.City), forKey: "city" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.Zipcode), forKey: "zipcode" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.Country), forKey: "country" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.Ambience), forKey: "ambience" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.AboutVenue), forKey: "about_venue" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.latitude), forKey: "lat" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.longitude), forKey: "lng" as NSCopying)

    
        let dataArr = NSMutableArray()
        if ImageArray != nil{
            for index in 0..<self.ImageArray.count {
                var image_final = UIImage()
                image_final = UIImage(data: ImageArray.object(at: index) as! Data)!
               // img_finalArray.add(image_final)
                let dataDict = NSMutableDictionary()
                dataDict.setObject("venue_image", forKey: "venue_image" as NSCopying)
                dataDict.setObject(resize(image_final).pngData()!, forKey: "imageData" as NSCopying)
                dataDict.setObject("png", forKey: "ext" as NSCopying)
                dataArr.add(dataDict)
                
            }
        }
        
        
//        let dataArr1 = NSMutableArray()
//        let dataDict1 = NSMutableDictionary()
//        dataDict1.setObject("id_proof", forKey: "id_proof" as NSCopying)
//        dataDict1.setObject(resize(self.chosenImage).pngData()!, forKey: "imageData" as NSCopying)
//        dataDict1.setObject("png", forKey: "ext" as NSCopying)
//        dataArr1.add(dataDict1)
//
//
//        let dataArr2 = NSMutableArray()
//        let dataDict2 = NSMutableDictionary()
//        dataDict2.setObject("owner_ship", forKey: "owner_ship" as NSCopying)
//        dataDict2.setObject(resize(self.chosenImage1).pngData()!, forKey: "imageData" as NSCopying)
//        dataDict2.setObject("png", forKey: "ext" as NSCopying)
//        dataArr2.add(dataDict2)
//
//
//        let dataArr3 = NSMutableArray()
//        let dataDict3 = NSMutableDictionary()
//        dataDict3.setObject("address_proof", forKey: "address_proof" as NSCopying)
//        dataDict3.setObject(resize(self.chosenImage2).pngData()!, forKey: "imageData" as NSCopying)
//        dataDict3.setObject("png", forKey: "ext" as NSCopying)
//        dataArr3.add(dataDict3)
//
        
        
        
        let MethodName = "create_venue"
        
        PostVenueRequetsViewController.getAPIResponseFile(parameterDictionary: parameterDictionary, methodName: MethodName as NSString ,dataArray: dataArr, imagedata1: imagedata! as NSData, imagedata2: imagedata1! as NSData, imagedata3: imagedata2! as NSData ){(responseData,error)-> Void in
            
            let status = PostVenueRequetsViewController.getVal(responseData?.object(forKey: "status")) as? String ?? "0"
            let message = PostVenueRequetsViewController.getVal(responseData?.object(forKey: "message")) as? String ?? "0"
            
            
            if status == "1" {
                var dict = NSDictionary()
                dict = responseData?.value(forKey: "data") as! NSDictionary
                var venid:Int!
                venid = dict.object(forKey: "id") as? Int
                var strsts:String!
                strsts = "showvenue"
                let defaults = UserDefaults.standard
                defaults.set(strsts, forKey: "SHOEVEN")
                defaults.set(venid, forKey: "ARVenID")
                defaults.synchronize()
                let nextview = CraeteVenueView.intitiateFromNib()
                let model = NewPopModel()
                nextview.buttonDoneHandler = {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                    self.navigationController?.pushViewController(vc!, animated: true)
                    model.closewithAnimation()
                }
                model.show(view: nextview)
                NotificationCenter.default.post(name: NSNotification.Name("CreateVenue"), object: nil)
                
            }else{
               print(message)
            }
            self.removeAllOverlays()
           
            
        }
        
    }
    
    
    
    func sendMedia2(data: UpdateVenueModel){
        
        //Loader Start
        
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.UserId), forKey: "user_id" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.ArtistId), forKey: "artist_id" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.VenueName), forKey: "venue_name" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.VenueAddress), forKey: "address" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.State), forKey: "state" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.City), forKey: "city" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.Zipcode), forKey: "zipcode" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.Country), forKey: "country" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.Ambience), forKey: "ambience" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.AboutVenue), forKey: "about_venue" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.latitude), forKey: "lat" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.longitude), forKey: "lng" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.deleteArray), forKey: "del_venue_image" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.Id), forKey: "id" as NSCopying)
        parameterDictionary.setObject(PostVenueRequetsViewController.getVal(data.UniqueStr), forKey: "upload_type" as NSCopying)
        let dataArr = NSMutableArray()
        if ImageArray != nil{
            for index in 0..<self.ImageArray.count {
                var image_final = UIImage()
                image_final = UIImage(data: ImageArray.object(at: index) as! Data)!
                // img_finalArray.add(image_final)
                let dataDict = NSMutableDictionary()
                dataDict.setObject("venue_image", forKey: "venue_image" as NSCopying)
                dataDict.setObject(resize(image_final).pngData()!, forKey: "imageData" as NSCopying)
                dataDict.setObject("png", forKey: "ext" as NSCopying)
                dataArr.add(dataDict)
                
            }
        }
        
        
        //        let dataArr1 = NSMutableArray()
        //        let dataDict1 = NSMutableDictionary()
        //        dataDict1.setObject("id_proof", forKey: "id_proof" as NSCopying)
        //        dataDict1.setObject(resize(self.chosenImage).pngData()!, forKey: "imageData" as NSCopying)
        //        dataDict1.setObject("png", forKey: "ext" as NSCopying)
        //        dataArr1.add(dataDict1)
        //
        //
        //        let dataArr2 = NSMutableArray()
        //        let dataDict2 = NSMutableDictionary()
        //        dataDict2.setObject("owner_ship", forKey: "owner_ship" as NSCopying)
        //        dataDict2.setObject(resize(self.chosenImage1).pngData()!, forKey: "imageData" as NSCopying)
        //        dataDict2.setObject("png", forKey: "ext" as NSCopying)
        //        dataArr2.add(dataDict2)
        //
        //
        //        let dataArr3 = NSMutableArray()
        //        let dataDict3 = NSMutableDictionary()
        //        dataDict3.setObject("address_proof", forKey: "address_proof" as NSCopying)
        //        dataDict3.setObject(resize(self.chosenImage2).pngData()!, forKey: "imageData" as NSCopying)
        //        dataDict3.setObject("png", forKey: "ext" as NSCopying)
        //        dataArr3.add(dataDict3)
        //
        
        
        
        let MethodName = "update_venue"
        
        PostVenueRequetsViewController.getAPIResponseFile(parameterDictionary: parameterDictionary, methodName: MethodName as NSString ,dataArray: dataArr, imagedata1: imagedata! as NSData, imagedata2: imagedata1! as NSData, imagedata3: imagedata2! as NSData ){(responseData,error)-> Void in
            
            let status = PostVenueRequetsViewController.getVal(responseData?.object(forKey: "status")) as? String ?? "0"
            let message = PostVenueRequetsViewController.getVal(responseData?.object(forKey: "message")) as? String ?? "0"
            
            
            if status == "1" {
                var dict = NSDictionary()
                dict = responseData?.value(forKey: "data") as! NSDictionary
                var venid:Int!
                venid = dict.object(forKey: "id") as? Int
                var strsts:String!
                strsts = "showvenue"
                let defaults = UserDefaults.standard
                defaults.set(strsts, forKey: "SHOEVEN")
                defaults.set(venid, forKey: "ARVenID")
                defaults.synchronize()
                let nextview = CraeteVenueView.intitiateFromNib()
                let model = NewPopModel()
                nextview.buttonDoneHandler = {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                    self.navigationController?.pushViewController(vc!, animated: true)
                    model.closewithAnimation()
                }
                model.show(view: nextview)
                NotificationCenter.default.post(name: NSNotification.Name("CreateVenue"), object: nil)
                
            }else{
                print(message)
            }
            self.removeAllOverlays()
            
            
        }
        
    }
    
    
    class func getAPIResponseFile( parameterDictionary :NSDictionary,methodName:NSString, dataArray:NSArray,imagedata1:NSData,imagedata2:NSData,imagedata3:NSData, success: @escaping ((  _ iTunesData: NSDictionary?, _ error:NSError?) -> Void)) {
        
        let apiPath = "\(Config().API_ArtistUrl)\(methodName)"
        
        let request = NSMutableURLRequest(url:NSURL(string: apiPath)! as URL);
        request.httpMethod = "POST"
        
        let boundary = self.generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var param : [String:String] = [:]
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 30.0
        
        for (key,val) in parameterDictionary {
            param[key as! String] = val as? String
        }
        
        request.httpBody = createBodyWithParameters(parameters: param, imageArray: dataArray, filePathKey: "id_proof", imageDataKey: imagedata1, filePathKey1: "owner_ship", imageDataKey1: imagedata2, filePathKey2: "address_proof", imageDataKey2: imagedata3, boundary: boundary) as Data
        
        loadDataFromURL(request: request, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                
                success(urlData,error)
            }
            else
            {
                // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:error?.domain ?? "Server not responding" , buttonTitle: "OK")
            }
        })
        
    }
    
    class func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    @IBAction func uploadIdBtnAction(_ sender: Any) {
        //strImg = "id"
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
    @IBAction func uploadownershipBtn(_ sender: Any) {
        tagvalueBtnSelected = 10
        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet,kUTTypePNG]
        let importMenu = UIDocumentMenuViewController(documentTypes: types as [String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)

    }
    
    @IBAction func uploadAddressProofBtnAction(_ sender: Any) {
        tagvalueBtnSelected = 11
        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet,kUTTypePNG]
        let importMenu = UIDocumentMenuViewController(documentTypes: types as [String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
//
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
    
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        print("import result : \(myURL)")
        path = myURL.absoluteString
        
       
        
        if tagvalueBtnSelected == 10 {
            do {
                
                imagedata1 = try Data(contentsOf: myURL as URL)
                
            } catch {
                print("Unable to load data: \(error)")
            }
            uploadOwnershipImage.text = "Upload Sucessfully."
        }else if tagvalueBtnSelected == 11 {
            do {
                imagedata2 = try Data(contentsOf: myURL as URL)
                
            } catch {
                print("Unable to load data: \(error)")
            }
            uploadaddressProofImage.text = "Upload Sucessfully."
        }else {
            
        }
        
        
    }
    
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       // if strImg == "id" {
            chosenImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
            uploadIdProofImage.image = chosenImage
            uploadIdProofImage.image = self.resizeImage(chosenImage)
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-YYYY hh:mm:ss"
            let dateExtension = formatter.string(from: date)
            let fileManager = FileManager.default
            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dateExtension).appending(".png")
            print(paths)
            
            imagedata = chosenImage.jpegData(compressionQuality: 0.5)
            // CameraBtn.isHidden = true
            fileManager.createFile(atPath: paths as String, contents: imagedata, attributes: nil)
            dismiss(animated: true, completion: nil)
        
//        }else if strImg == "owner" {
//            chosenImage1 = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
//            uploadOwnershipImage.text = "Upload Sucessfully."
//            uploadOwnershipImage.textColor = UIColor.white
//            let date = Date()
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd-MM-YYYY hh:mm:ss"
//            let dateExtension = formatter.string(from: date)
//            let fileManager = FileManager.default
//            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dateExtension).appending(".png")
//            print(paths)
//
//            imagedata1 = chosenImage1.jpegData(compressionQuality: 0.5)
//            // CameraBtn.isHidden = true
//            fileManager.createFile(atPath: paths as String, contents: imagedata1, attributes: nil)
//            dismiss(animated: true, completion: nil)
//        }else {
//            chosenImage2 = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
//            uploadaddressProofImage.text = "Upload Sucessfully."
//            uploadaddressProofImage.textColor = UIColor.white
//            let date = Date()
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd-MM-YYYY hh:mm:ss"
//            let dateExtension = formatter.string(from: date)
//            let fileManager = FileManager.default
//            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dateExtension).appending(".png")
//            print(paths)
//
//            imagedata2 = chosenImage2.jpegData(compressionQuality: 0.5)
//            // CameraBtn.isHidden = true
//            fileManager.createFile(atPath: paths as String, contents: imagedata2, attributes: nil)
//            dismiss(animated: true, completion: nil)
//        }
        
    }
    
    func resizeImage(_ image:UIImage) -> UIImage
    {
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = 100.0
        let maxWidth: Float = 100.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        // let compressionQuality: Float = 0.5
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img?.jpegData(compressionQuality: 0.5)
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!) ?? UIImage()
        
    }
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    class func getVal(_ param:Any!) -> AnyObject {
        
        
        
        
        if param == nil
        {
            return "" as AnyObject
        }
        else if param is NSNull
        {
            return "" as AnyObject
        }
        else if param is NSNumber
        {
            let aString:String = "\(param!)"
            return aString as AnyObject
        }
        else if param is Double
        {
            return "\(param)" as AnyObject
        }
        else
        {
            return param as AnyObject
        }
        
    }
    
    
     class func createBodyWithParameters(parameters: [String: String]?, imageArray: NSArray,filePathKey: String?, imageDataKey: NSData,filePathKey1: String?, imageDataKey1: NSData,filePathKey2: String?, imageDataKey2: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append(("--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
                body.append(("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
                body.append(("\(value)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            }
        }
        
        
        var imageData = Data()
        var imageName  = ""
        // print(imageArray)
        for index in 0..<imageArray.count {
            
            let dataDictionary = imageArray[index] as! NSDictionary
            
            imageName = dataDictionary.object(forKey: "venue_image") as! String
            imageData = dataDictionary.object(forKey: "imageData") as! Data
            
            let mimetype = "application/octet-stream"
            
            let imageName = dataDictionary.object(forKey: "venue_image") as! NSString
            let imageExt = dataDictionary.object(forKey: "ext") as! NSString
            let imageData = dataDictionary.object(forKey: "imageData") as! Data
            //  let imageType = dataDictionary.object(forKey: "imagetype") as! NSString
            
            let randmstr = self.randomStringWithLength(8)
            
            body.append(("--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(("Content-Disposition: form-data; name=\"\(imageName)[\(index)]\"; filename=\"\(randmstr).\(imageExt)\"\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(("Content-Type: \(mimetype)\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(imageData as Data)
            body.append(("\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(("--\(boundary)--\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            
        }
        
//
        
        let filename = "id_proof.jpg"
        let filename1 = "owner_ship"
        let filename2 = "address_proof"

        let mimetype = "image/jpg"

        body.append(("--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(("Content-Type: \(mimetype)\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(imageDataKey as Data)
        body.append(("\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)

        body.append(("--\(boundary)--\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)

        body.append(("--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(("Content-Disposition: form-data; name=\"\(filePathKey1!)\"; filename=\"\(filename1)\"\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(("Content-Type: \(mimetype)\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(imageDataKey1 as Data)
        body.append(("\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)

        body.append(("--\(boundary)--\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)


        body.append(("--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(("Content-Disposition: form-data; name=\"\(filePathKey2!)\"; filename=\"\(filename2)\"\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(("Content-Type: \(mimetype)\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(imageDataKey2 as Data)
        body.append(("\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)

        body.append(("--\(boundary)--\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        
        
        
        
        
        return body
    }


    
    class func randomStringWithLength (_ len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0..<len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        return randomString
    }
    
    class func loadDataFromURL( request: NSMutableURLRequest, completion:@escaping (  _ data: NSDictionary?,  _ error: NSError?) -> Void) {
        // Use NSURLSession to get data from an NSURL
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main)
        {(response, data, error) in
            print(error)
            if let responseError = error {

                Config().printData(responseError as NSObject)
                var jsonResult  = NSDictionary()
                jsonResult = ["status":"error","message":responseError.localizedDescription]
                jsonResult = ["status":"error","message":"Make sure your device is connected to the internet."]
                completion(jsonResult, responseError as NSError?)
            } else if let httpResponse = response as? HTTPURLResponse {
                Config().printData(httpResponse.statusCode as NSObject)
                if httpResponse.statusCode != 200 {
                    let base64String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                   // Config().printData(base64String!)
                    var jsonResult  = NSDictionary()
                    jsonResult = ["status":"error","message":base64String!]
                    jsonResult = ["status":"error","message":"There is a problem with server, kindly try again."]
                    completion(jsonResult, nil)
                } else {
                    let base64String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    Config().printData(base64String!)
                    
                    var jsonResult  = NSDictionary()
                    
                    let decodedString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    if((try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                        jsonResult  = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    } else {
                        Config().printData(decodedString!)
                        jsonResult = ["status":"error","message":decodedString!]
                        jsonResult = ["status":"error","message":"There is a problem with server, kindly try again."]
                    }
                    
                    
                  //  Config().printData(jsonResult)
                    completion(jsonResult, nil)
                }
            }
        }
        //loadDataTask.resume()
    }

}
