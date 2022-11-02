//
//  AddNewSongViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 02/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import MobileCoreServices

protocol MyDataSendingDelegate {
    func sendDataToFirstViewController(account_id: String,flag: Bool)
}

class AddNewSongViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate,MyDataSendingDelegate {

    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var genreCollectioView: UICollectionView!
    @IBOutlet weak var songImage: UIImageView!
    
    @IBOutlet weak var songNameTxt: FloatLabelTextField!
    @IBOutlet weak var songTypeTxt: FloatLabelTextField!
    @IBOutlet weak var uploadTxt: UITextField!
    @IBOutlet weak var bandBtn: UIButton!
    @IBOutlet weak var soloBtn: UIButton!
    @IBOutlet weak var bandTable: UITableView!
    @IBOutlet weak var bandTableHeigheCons: NSLayoutConstraint!
    @IBOutlet weak var aboutTxt: FloatLabelTextField!
    @IBOutlet weak var priceTxt: FloatLabelTextField!
    @IBOutlet weak var originalArtistTxt: FloatLabelTextField!
    @IBOutlet weak var originalArHeightCons: NSLayoutConstraint!
    @IBOutlet weak var orLblHeightCons: NSLayoutConstraint!
    @IBOutlet weak var aboutTextView: UITextView!
    
    var str_songname:NSString!
    var str_songtype:NSString!
    var str_upload:NSString!
    var str_about:NSString!
    var str_price:NSString!
    var response:NSMutableArray!
    var genreArray:NSArray!
    var selectedIndexes:NSMutableArray!
    var pricearray:NSMutableArray!
    var picker = UIImagePickerController()
    var Genre_Id:Int!
    var chosenImage = UIImage()
    var imagedata: Data!
    var path = String()
    var str_extension = String()
    var songdata:Data!
    var userId:Int!
    var ArtistId:Int!
    var defaults:UserDefaults!
    var bandArray:NSMutableArray!
    var astype:String!
    var astypeid:Int!
    var bndid:Int!
    var pickerview  : UIPickerView = UIPickerView()
    var typeAr = ["Original","Cover"]
    var isclick: Bool = false
    var index = Int()
    var viewtype:String!
    var songId:Int!
    var songFile:String!
    var genAr = NSMutableArray()
    var songImg:String!
    var songDt = Data()
    var songfl = Data()
    var selgenArr:NSArray!
    var orginalAr:String!
    var str_lat:String!
    var str_long:String!
    var Alcreate:String!
    var accountID:String!
    var isComingFrom = Bool()
    var ARTaccID = String()
    


    
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
                print("response: \(String(describing: self.response))")
                self.genreArray = self.response.value(forKey: "id") as? NSArray
                // self.pricearray.add(self.genreArray!)
                self.genreCollectioView.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    //MARK:- Login WebService
    @objc func DiscoverBandListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                self.bandTable.reloadData()
            }
            else{
                self.bandArray = (notification.userInfo?["data"] as? NSMutableArray)!
                //self.bndid = self.bandArray.value(forKey: "id") as? Int
                print("response: \(String(describing: self.bandArray))")
                self.bandTable.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    //MARK:- Upload Song WebService
    @objc func UploadSong(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUploadSong"), object: nil)
                self.removeAllOverlays()
            }
            else{
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name("UploadSong"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("UploadSong1"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUploadSong"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    //MARK:- Upload Song WebService
    @objc func UpdateSong(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUpdateSong"), object: nil)
                self.removeAllOverlays()
            }
            else{
                let isComingFrom = "true"
                let defaults = UserDefaults.standard
                defaults.set(isComingFrom, forKey: "Bool")
                
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name("UpdateSong"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("UpdateSong1"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUpdateSong"), object: nil)
                self.removeAllOverlays()
            }
        }
    }
    
    
    
    @objc func DiscoverSongDetailAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                self.removeAllOverlays()
                
            }
            else{
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(String(describing: response))")
                self.songNameTxt.text = response.value(forKey: "song_name") as? String
                self.songTypeTxt.text = response.value(forKey: "song_type") as? String
                var str:String!
                str = response.value(forKey: "song_type") as? String
                if str == "Cover" {
                    self.originalArHeightCons.constant = 50
                    self.orLblHeightCons.constant = 1
                }else {
                    self.originalArHeightCons.constant = 0
                    self.orLblHeightCons.constant = 0
                }
                var price:NSNumber!
                price =  response.value(forKey: "price") as? NSNumber
               
                self.priceTxt.text = price.stringValue
                self.aboutTxt.text = response.value(forKey: "description") as? String
                
                self.songImage.sd_setImage(with: URL(string: (response.value(forKey: "song_image") as? String)!), placeholderImage: UIImage(named: "Group 4-1"))
                self.songFile = response.value(forKey: "song_file") as? String
                self.songImg = response.value(forKey: "song_image") as? String
               self.originalArtistTxt.text = response.value(forKey: "original_artist") as? String
                if self.songFile == "" {
                    self.uploadTxt.text = ""
                }else {
                    self.uploadTxt.text = "Upload Sucessfully"
                }
                self.aboutTextView.text = response.value(forKey: "description") as? String
                var genArr = NSMutableArray()
                genArr = response.value(forKey: "genres") as! NSMutableArray
                self.selgenArr = genArr.value(forKey: "id") as? NSArray
                self.pricearray = NSMutableArray(array: self.selgenArr)
                print(self.pricearray!)
               // self.genAr = (response.value(forKey: "genres") as? NSMutableArray)!
                //self.selgenArr = self.genAr.value(forKey: "id") as? NSArray
                self.genreCollectioView.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        ArtistId = defaults.integer(forKey: "ArtistID")
        viewtype = defaults.value(forKey: "ADD") as? String
        songId = defaults.integer(forKey: "Song_Id")
        str_lat = defaults.value(forKey: "LAT") as? String
        str_long = defaults.value(forKey: "LONG") as? String
        Alcreate = defaults.value(forKey: "ALCREATE") as? String
        accountID = defaults.string(forKey: "AccountID") ?? ""
        
        doneBtn.layer.cornerRadius = 25
        uploadTxt.delegate = self
        songNameTxt.delegate = self
        priceTxt.delegate = self
        songTypeTxt.delegate = self
        originalArtistTxt.delegate = self
        songNameTxt.attributedPlaceholder = NSAttributedString(string:"Song Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        priceTxt.attributedPlaceholder = NSAttributedString(string:"Price Per Download($)", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        songTypeTxt.attributedPlaceholder = NSAttributedString(string:"Song Type", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        uploadTxt.attributedPlaceholder = NSAttributedString(string:"Upload as", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        originalArtistTxt.attributedPlaceholder = NSAttributedString(string:"Original Artist", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
//        zipcodeTxt.attributedPlaceholder = NSAttributedString(string:"Zip Code", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        response = NSMutableArray()
        genreArray = NSArray()
        bandArray = NSMutableArray()
        selectedIndexes = NSMutableArray()
        pricearray = NSMutableArray()
        bandTableHeigheCons.constant = 0
        pickerview.delegate = self
        pickerview.dataSource = self
        songTypeTxt.inputView = pickerview
        index = -1
        aboutTextView.text = "Tell Us More About the Song"
        aboutTextView.delegate = self
        originalArHeightCons.constant = 0
        orLblHeightCons.constant = 0
        astype = "artist"
        astypeid = ArtistId
        if viewtype == "Add" {
            
        }else {
            if Reachability.isConnectedToNetwork() == true{
                showWaitOverlay()
                Parsing().DiscoverSongDetail(UserId: userId, SongId: songId)
                NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverSongDetailAction), name: NSNotification.Name(rawValue: "DiscoverSongDetail"), object: nil)
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
                
            }
        }
        
        
        if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
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
    
    override func viewWillAppear(_ animated: Bool) {
        if isComingFrom == true{
        if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            let data = AddSongModel()
            if imagedata == nil {
                
            }else {
                data.SongImage = imagedata! as NSData
            }
            if songdata == nil {
                
            }else {
                data.SongFile = songdata! as NSData
            }
            data.UserId = userId
            data.AccountID = accountID ?? ""
            data.SongName = str_songname as String
            data.SongType = str_songtype as String
            data.deescription = str_about as String
            data.AsType = astype
            data.AsId = astypeid
            data.Price = str_price as String
          
            data.OriginalArtist = orginalAr
            let  typeIdArrayString1 = self.JSONStringify(value: pricearray as AnyObject)
            print(typeIdArrayString1)
            data.Geners = typeIdArrayString1
            
            Parsing().DiscoverUploadSong(data: data)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUploadSong"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.UploadSong), name: NSNotification.Name(rawValue: "DiscoverUploadSong"), object: nil)
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
        }else{
            //Noting Happen
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == songNameTxt {
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
        }  else if textField == originalArtistTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 80
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
        }
        else {
            
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                return true
            case ".":
                let array = Array(textField.text!)
                var decimalCount = 0
                for character in array {
                    if character == "." {
                        decimalCount += 1
                    }
                }
                
                
                if decimalCount == 1 {
                    return false
                } else {
                    return true
                }
            default:
                let array = Array(string)
                if array.count == 0 {
                    return true
                }
                
                return false
            }
           
        }
//        else {
//            return true
//        }
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
    
    // MARK:- UITextViewDelegates
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Tell Us More About the Song" {
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
            let currentString: NSString = (textView.text ?? "Tell Us More About the Song") as NSString
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
            textView.text = "Tell Us More About the Song"
            textView.textColor = UIColor.white
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
      func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == songTypeTxt {
            if songTypeTxt.text == "" {
                self.pickerView(pickerview, didSelectRow: 0, inComponent: 0)
            }else if songTypeTxt.text == "Original" {
                self.pickerView(pickerview, didSelectRow: 0, inComponent: 0)
            }else {
                
            }
        }
    }
    
    // PickerView Delegate.....
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
       
            return typeAr.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
            return typeAr[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
            if row == 0 {
               songTypeTxt.text = typeAr[row]
                originalArHeightCons.constant = 0
                orLblHeightCons.constant = 0
                orginalAr = originalArtistTxt.text
            }else {
                songTypeTxt.text = typeAr[row]
                originalArHeightCons.constant = 50
                orLblHeightCons.constant = 1
                orginalAr = originalArtistTxt.text
            }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddSongGenresCell
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
            
            selectedIndexes = [AnyHashable]() as? NSMutableArray
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
        genreCollectioView.reloadItems(at: [indexPath as IndexPath])
        genreCollectioView.reloadData()
    }
    
    @IBAction func imageBtnAction(_ sender: Any) {
        var str:String!
        str = "Image"
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "ImageType")
        defaults.synchronize()
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
        songImage.image = chosenImage
        songImage.image = self.resizeImage(chosenImage)
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
    
    @IBAction func backBtnaction(_ sender: Any) {
        if Alcreate == "Alcreate" {
            defaults.removeObject(forKey: "ALCREATE")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
            navigationController?.pushViewController(vc!, animated: true)
        }else {
            navigationController?.popViewController(animated: true)
        }
        
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        print("import result : \(myURL)")
        path = myURL.absoluteString
        str_extension = myURL.pathExtension
        songdata = try! Data(contentsOf: myURL as URL)
        uploadTxt.text = "Upload Sucessfully."
        
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadSongBtnaction(_ sender: Any) {
        let types = [kUTTypeMP3,kUTTypeAudio]
        let importMenu = UIDocumentMenuViewController(documentTypes: types as [String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    // Delegate Method
    func sendDataToFirstViewController(account_id: String, flag: Bool) {
        print(account_id)
        print(flag)
        self.accountID = account_id
        self.isComingFrom = flag
    }
    @IBAction func doneBtnAction(_ sender: Any) {
        if viewtype == "Add" {
            str_songname = songNameTxt.text as NSString?
            str_songtype = songTypeTxt.text as NSString?
            str_upload = uploadTxt.text as NSString?
            str_about = aboutTextView.text as NSString?
            str_price = priceTxt.text as NSString?
            if str_songname .isEqual(to: ""){
                let test =  SwiftToast(
                    text: "Please enter a song name",
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
            } else if str_songtype .isEqual(to: ""){
                let test =  SwiftToast(
                    text: "Please enter a song type",
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
            } else if str_upload .isEqual(to: ""){
                let test =  SwiftToast(
                    text: "Please upload a song",
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
            } else if str_about .isEqual(to: "Tell Us More About the Song"){
                let test =  SwiftToast(
                    text: "Please enter about a song",
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
            } else if str_price .isEqual(to: ""){
                let test =  SwiftToast(
                    text: "Please enter a price",
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
            }else if str_price.length > 8{
                let test =  SwiftToast(
                    text: "Please enter a valid price",
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
                if str_price == "0"{
                if Reachability.isConnectedToNetwork() == true {
                    showWaitOverlay()
                    let data = AddSongModel()
                    if imagedata == nil {
                        
                    }else {
                        data.SongImage = imagedata! as NSData
                    }
                    if songdata == nil {
                        
                    }else {
                        data.SongFile = songdata! as NSData
                    }
                    data.UserId = userId
                    data.SongName = str_songname as String
                    data.SongType = str_songtype as String
                    data.deescription = str_about as String
                    data.AsType = astype
                    data.AsId = astypeid
                    data.Price = str_price as String
                  
                    data.OriginalArtist = orginalAr
                    let  typeIdArrayString1 = self.JSONStringify(value: pricearray as AnyObject)
                    print(typeIdArrayString1)
                    data.Geners = typeIdArrayString1
                    
                    Parsing().DiscoverUploadSong(data: data)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUploadSong"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.UploadSong), name: NSNotification.Name(rawValue: "DiscoverUploadSong"), object: nil)
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
                }else{
                    if accountID == ""{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddSongStripeViewController") as! AddSongStripeViewController
                        vc.delegate = self
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else{
                        if Reachability.isConnectedToNetwork() == true {
                            showWaitOverlay()
                            let data = AddSongModel()
                            if imagedata == nil {
                                
                            }else {
                                data.SongImage = imagedata! as NSData
                            }
                            if songdata == nil {
                                
                            }else {
                                data.SongFile = songdata! as NSData
                            }
                            data.UserId = userId
                            data.AccountID = ARTaccID 
                            data.SongName = str_songname as String
                            data.SongType = str_songtype as String
                            data.deescription = str_about as String
                            data.AsType = astype
                            data.AsId = astypeid
                            data.Price = str_price as String
                          
                            data.OriginalArtist = orginalAr
                            let  typeIdArrayString1 = self.JSONStringify(value: pricearray as AnyObject)
                            print(typeIdArrayString1)
                            data.Geners = typeIdArrayString1
                            
                            Parsing().DiscoverUploadSong(data: data)
                            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUploadSong"), object: nil)
                            NotificationCenter.default.addObserver(self, selector: #selector(self.UploadSong), name: NSNotification.Name(rawValue: "DiscoverUploadSong"), object: nil)
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
        }else {
            str_songname = songNameTxt.text as NSString?
            str_songtype = songTypeTxt.text as NSString?
            str_upload = uploadTxt.text as NSString?
            str_about = aboutTextView.text as NSString?
            str_price = priceTxt.text as NSString?
            if str_songname .isEqual(to: ""){
                let test =  SwiftToast(
                    text: "Please enter a song name",
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
            } else if str_songtype .isEqual(to: ""){
                let test =  SwiftToast(
                    text: "Please enter a song type",
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
            } else if str_upload .isEqual(to: ""){
                let test =  SwiftToast(
                    text: "Please upload a song",
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
            } else if str_about .isEqual(to: "Tell Us More About the Song"){
                let test =  SwiftToast(
                    text: "Please enter about a song",
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
            } else if str_price .isEqual(to: ""){
                let test =  SwiftToast(
                    text: "Please enter a price",
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
                    let data = UpdateSongModel()
                    if imagedata == nil {
                        let AddPicture_url: NSURL = NSURL(string: self.songImg)!
                        let testImage = NSData(contentsOf: AddPicture_url as URL)
                        data.SongImage = testImage!
                    }else {
                        data.SongImage = imagedata! as NSData
                    }
                    if songdata == nil {
                        let AddPicture_url: NSURL = NSURL(string: self.songFile)!
                        let testImage = NSData(contentsOf: AddPicture_url as URL)
                        data.SongFile = testImage!
                    }else {
                        data.SongFile = songdata! as NSData
                    }
                    data.Id = songId
                    data.UserId = userId
                    data.SongName = str_songname as String
                    data.SongType = str_songtype as String
                    data.deescription = str_about as String
                    data.AsType = astype
                    data.AsId = astypeid
                  
                    data.Price = str_price as String
                    data.OriginalArtist = originalArtistTxt.text!
                    let  typeIdArrayString1 = self.JSONStringify(value: pricearray as AnyObject)
                    print(typeIdArrayString1)
                    data.Geners = typeIdArrayString1
                    
                    Parsing().DiscoverUpdateSong(data: data)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DiscoverUpdateSong"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateSong), name: NSNotification.Name(rawValue: "DiscoverUpdateSong"), object: nil)
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
    @IBAction func soloBtnAction(_ sender: Any) {
        soloBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        bandBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
         bandTableHeigheCons.constant = 0
         astype = "artist"
         astypeid = ArtistId
    }
    @IBAction func bandBtnAction(_ sender: Any) {
        soloBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        bandBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
         bandTableHeigheCons.constant = 110
         astype = "band"
         astypeid = bndid
      
        if Reachability.isConnectedToNetwork() == true {
            Parsing().DiscoverBandListing(user_Id: userId, ArtistId: ArtistId)
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBandListAction), name: NSNotification.Name(rawValue: "DiscoverBandListing"), object: nil)
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
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if bandArray.count>0
        {
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Band Found"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bandArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SongBandCell
        var dict = NSDictionary()
        dict = bandArray.object(at: indexPath.row) as! NSDictionary
        cell.bandNameLbl.text = dict.value(forKey: "band_name") as? String
        cell.radioBtn.tag = indexPath.row

        if indexPath.row == index {
              cell.radioBtn.setImage(UIImage(named: "radio_icon_active"), for: .normal)
        }else {
             cell.radioBtn.setImage(UIImage(named: "radio_icon"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = bandArray.object(at: indexPath.row) as! NSDictionary
       // var id:Int!
        bndid = dict.value(forKey: "id") as? Int
        let defaults = UserDefaults.standard
        defaults.set(bndid, forKey: "SelBndId")
        defaults.synchronize()
        index = indexPath.row
        bandBtnAction(UIButton())
        bandTable.reloadData()
    }
    
 
    

}
