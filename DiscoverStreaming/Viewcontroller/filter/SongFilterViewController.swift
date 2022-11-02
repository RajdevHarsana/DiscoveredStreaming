//
//  SongFilterViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 10/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast
import RangeSeekSlider

class SongFilterViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate {
   
    

    @IBOutlet weak var songGenreCollectionViuew: UICollectionView!
    
    @IBOutlet weak var AllBtn: UIButton!
    @IBOutlet weak var orginleBtn: UIButton!
    @IBOutlet weak var coverBtn: UIButton!
    
    @IBOutlet weak var date1View: UIView!
    @IBOutlet weak var date2View: UIView!
    @IBOutlet weak var startDateTxt: UITextField!
    @IBOutlet weak var endDateTxt: UITextField!
    @IBOutlet weak var viewsSlider: UISlider!
    @IBOutlet weak var anyNumberOfviews: UILabel!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var numberfview: UILabel!
    @IBOutlet weak var clearBtn: UIButton!
   
    @IBOutlet weak var distanceSliderview: UISlider!
    @IBOutlet weak var mindisLbl: UILabel!
    @IBOutlet weak var maxdisLbl: UILabel!
    @IBOutlet weak var ratingsliderview: UISlider!
    @IBOutlet weak var ratemaxlbl: UILabel!
    @IBOutlet weak var rateminLbl: UILabel!
    @IBOutlet weak var disnewLbl: UILabel!
    @IBOutlet weak var ratenewLbl: UILabel!
    @IBOutlet weak var viewnewLbl: UILabel!
    var datepicker:UIDatePicker! = UIDatePicker()
    var datepicker1:UIDatePicker! = UIDatePicker()
    var response = NSMutableArray()
    var genreArray = NSArray()
    var Genre_Id:Int!
    var selectedIndexes:NSMutableArray!
    var pricearray:NSMutableArray!
    var songType:String!
    var strdate:NSString!
    var enddate:NSString!
    var anyallSts:Int!
    var defaults:UserDefaults!
    var saveVal:String!
    var sDate:String!
    var eDate:String!
    var views:String!
    var dis:String!
    var rate:String!
    var songty:String!
    var anyAll:Int!
    var newarr:NSArray!
    var slidVal:Int!
    
    @IBOutlet weak var swtchBtn: UISwitch!
    
    var Disatnce = DataManager.getVal(Config().AppUserDefaults.object(forKey: "Distance3")) as? String ?? ""
    var Rating = DataManager.getVal(Config().AppUserDefaults.object(forKey: "Rating3")) as? String ?? ""
    var Views = DataManager.getVal(Config().AppUserDefaults.object(forKey: "Viws3")) as? String ?? ""
    
    //MARK:- Login WebService
    @objc func DiscoverGenresAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
       // let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                
                //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else{
                
                
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(self.response)")
                self.genreArray = (self.response.value(forKey: "id") as? NSArray)!
                self.songGenreCollectionViuew.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    @objc func DiscoverBasicDetailsAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                
                //SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.removeAllOverlays()
            }
            else{
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        saveVal = defaults.value(forKey: "FilterValue") as? String
        sDate = defaults.value(forKey: "STRDATE") as? String
        eDate = defaults.value(forKey: "ENDDATE") as? String
        songty = defaults.value(forKey: "SONGTY") as? String
        anyAll = defaults.integer(forKey: "ANYALLSTS")
        newarr = defaults.array(forKey: "GenAR") as NSArray?
        slidVal = defaults.integer(forKey: "SliderIndex")
        pricearray = NSMutableArray()
        
        self.disnewLbl.text = self.Disatnce
        self.ratenewLbl.text = self.Rating
        self.viewnewLbl.text = self.Views
        
        if saveVal == "savevalue" {
        disnewLbl.isHidden = false
        ratenewLbl.isHidden = false
        viewnewLbl.isHidden = false
        startDateTxt.text = sDate
        endDateTxt.text = eDate
            
        self.disnewLbl.text = self.Disatnce
        self.ratenewLbl.text = self.Rating
        self.viewnewLbl.text = self.Views
            
        let myFloat1 = (self.Disatnce as NSString).floatValue
        let myFloat2 = (self.Rating as NSString).floatValue
        let myFloat3 = (self.Views as NSString).floatValue

        self.distanceSliderview.minimumValue = 0
        self.distanceSliderview.maximumValue = 10000
        self.distanceSliderview.isContinuous = true

        self.ratingsliderview.minimumValue = 0
        self.ratingsliderview.maximumValue = 100
        self.ratingsliderview.isContinuous = true

        self.viewsSlider.minimumValue = 0
        self.viewsSlider.maximumValue = 1000
        self.viewsSlider.isContinuous = true

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: { self.distanceSliderview.value = myFloat1 }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: { self.ratingsliderview.value = myFloat2 }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: { self.viewsSlider.value = myFloat3 }, completion: nil)
            
        pricearray = NSMutableArray(array: newarr)
          
       
        
        if songty == "" {
        AllBtn.backgroundColor = UIColor(red: 255/255, green: 45/255, blue: 165/255, alpha: 1.0)
        orginleBtn.backgroundColor = UIColor.clear
        coverBtn.backgroundColor = UIColor.clear
            
        orginleBtn.layer.cornerRadius = 5
        orginleBtn.layer.borderColor = UIColor.lightGray.cgColor
        orginleBtn.layer.borderWidth = 1
            
        coverBtn.layer.cornerRadius = 5
        coverBtn.layer.borderColor = UIColor.lightGray.cgColor
        coverBtn.layer.borderWidth = 1
        }else if songty == "original" {
            orginleBtn.backgroundColor = UIColor(red: 255/255, green: 45/255, blue: 165/255, alpha: 1.0)
            AllBtn.backgroundColor = UIColor.clear
            coverBtn.backgroundColor = UIColor.clear
            
            AllBtn.layer.cornerRadius = 5
            AllBtn.layer.borderColor = UIColor.lightGray.cgColor
            AllBtn.layer.borderWidth = 1
            
            coverBtn.layer.cornerRadius = 5
            coverBtn.layer.borderColor = UIColor.lightGray.cgColor
            coverBtn.layer.borderWidth = 1
        }else if songty == "cover"  {
            coverBtn.backgroundColor = UIColor(red: 255/255, green: 45/255, blue: 165/255, alpha: 1.0)
            orginleBtn.backgroundColor = UIColor.clear
            AllBtn.backgroundColor = UIColor.clear
            
            AllBtn.layer.cornerRadius = 5
            AllBtn.layer.borderColor = UIColor.lightGray.cgColor
            AllBtn.layer.borderWidth = 1
            
            
            orginleBtn.layer.cornerRadius = 5
            orginleBtn.layer.borderColor = UIColor.lightGray.cgColor
            orginleBtn.layer.borderWidth = 1
        }else {
            coverBtn.backgroundColor = UIColor.clear
            orginleBtn.backgroundColor = UIColor.clear
            AllBtn.backgroundColor = UIColor.clear
        }
            
        if anyAll == 1 {
            swtchBtn.isOn = false
        }else if anyAll == 2 {
            swtchBtn.isOn = true
        }
        else {
            swtchBtn.isOn = false
        }
        
        }else {
            ratenewLbl.text = ""
            anyallSts = 1
            disnewLbl.text = ""
            distanceSliderview.value = 0
            ratingsliderview.value = 0
            viewsSlider.value = 0
            
            disnewLbl.isHidden = true
            ratenewLbl.isHidden = true
            viewnewLbl.isHidden = true
            
            Config().AppUserDefaults.removeObject(forKey: "Distance3")
            Config().AppUserDefaults.removeObject(forKey: "Rating3")
            Config().AppUserDefaults.removeObject(forKey: "Viws3")
            defaults.removeObject(forKey: "APICALL")
            defaults.removeObject(forKey: "FilterValue")

            
            AllBtn.layer.cornerRadius = 5
            AllBtn.layer.borderColor = UIColor.lightGray.cgColor
            AllBtn.layer.borderWidth = 1
            
            orginleBtn.layer.cornerRadius = 5
            orginleBtn.layer.borderColor = UIColor.lightGray.cgColor
            orginleBtn.layer.borderWidth = 1
            
            coverBtn.layer.cornerRadius = 5
            coverBtn.layer.borderColor = UIColor.lightGray.cgColor
            coverBtn.layer.borderWidth = 1
            
            coverBtn.backgroundColor = UIColor.clear
            orginleBtn.backgroundColor = UIColor.clear
            AllBtn.backgroundColor = UIColor.clear
            
           
        }
        
        date1View.layer.cornerRadius = 5
        date2View.layer.cornerRadius = 5
        
        startDateTxt.delegate = self
        endDateTxt.delegate = self
        selectedIndexes = NSMutableArray()
       
        applyBtn.layer.cornerRadius = 5
        clearBtn.layer.cornerRadius = 5
        
        datepicker.datePickerMode = UIDatePicker.Mode.date
        startDateTxt.inputView = datepicker
        datepicker.maximumDate = Date()
        datepicker.addTarget(self, action: #selector(handleStartDatePicker(sender:)), for: UIControl.Event.valueChanged)
        
        datepicker1.datePickerMode = UIDatePicker.Mode.date
        endDateTxt.inputView = datepicker1
        datepicker1.maximumDate = Date()
        datepicker1.addTarget(self, action: #selector(handleEndDatePicker(sender:)), for: UIControl.Event.valueChanged)
        
        
     
        
        if Reachability.isConnectedToNetwork() == true {
            showWaitOverlay()
            Parsing().GetGenresList()
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverGenresAction), name: NSNotification.Name(rawValue: "GetGenresListNotification"), object: nil)
            
            Parsing().GetBasicDetails()
            NotificationCenter.default.addObserver(self, selector: #selector(self.DiscoverBasicDetailsAction), name: NSNotification.Name(rawValue: "GetBasicDetailsNotification"), object: nil)
            
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

        // Do any additional setup after loading the view.
    }
    //MARK:- Date Button Action
    @objc func handleStartDatePicker(sender: UIDatePicker) {
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        startDateTxt.text = dateFormatter.string(from: sender.date)
        //startDateTxt = dateFormatter.string(from: sender.date) as NSString
    }
    
    //MARK:- Date Button Action
    @objc func handleEndDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        endDateTxt.text = dateFormatter.string(from: sender.date)
       // endDateTxt = dateFormatter.string(from: sender.date) as NSString
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == startDateTxt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: datepicker.date)
            startDateTxt.text = dateString
        }else if textField == endDateTxt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: datepicker1.date)
            endDateTxt.text = dateString
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SongGenresFilterCell
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
        songGenreCollectionViuew.reloadItems(at: [indexPath as IndexPath])
        songGenreCollectionViuew.reloadData()
    }

    @IBAction func viewsSliderAction(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        let str1 = String(currentValue)

        self.viewnewLbl.isHidden = false
        self.viewnewLbl.text = "0"
        self.viewnewLbl.text = str1
    }
    @IBAction func ratingsliderviewAction(_ sender: UISlider) {
        
        let currentValue = Int(sender.value)
        let str1 = String(currentValue)

        self.ratenewLbl.isHidden = false
        self.ratenewLbl.text = "0"
        self.ratenewLbl.text = str1
    }
    @IBAction func distancesliderView(_ sender: UISlider) {
        
        let currentValue = Int(sender.value)
        let str1 = String(currentValue)

        self.disnewLbl.isHidden = false
        self.disnewLbl.text = "0"
        self.disnewLbl.text = str1
    }
    
    @IBAction func allBtnAction(_ sender: Any) {
        songType = ""
        AllBtn.backgroundColor = UIColor(red: 255/255, green: 45/255, blue: 165/255, alpha: 1.0)
        orginleBtn.backgroundColor = UIColor.clear
        coverBtn.backgroundColor = UIColor.clear
    }
    
    @IBAction func originalBtnAction(_ sender: Any) {
         songType = "original"
        orginleBtn.backgroundColor = UIColor(red: 255/255, green: 45/255, blue: 165/255, alpha: 1.0)
        AllBtn.backgroundColor = UIColor.clear
        coverBtn.backgroundColor = UIColor.clear
    }
    @IBAction func CoverBtnAction(_ sender: Any) {
         songType = "cover"
        coverBtn.backgroundColor = UIColor(red: 255/255, green: 45/255, blue: 165/255, alpha: 1.0)
        orginleBtn.backgroundColor = UIColor.clear
        AllBtn.backgroundColor = UIColor.clear
    }
    
    @IBAction func ApplyFilterBtnAction(_ sender: Any) {
        
        strdate = startDateTxt.text as NSString?
       enddate = endDateTxt.text as NSString?

        let  typeIdArrayString = self.JSONStringify(value: pricearray as AnyObject)
        print(typeIdArrayString)
        var str:String!
        str = "APICall"
        let defaults = UserDefaults.standard
        var newstr:String!
        newstr = "savevalue"
        defaults.set(typeIdArrayString, forKey: "GENER")
        defaults.set(startDateTxt.text, forKey: "STRDATE")
        defaults.set(endDateTxt.text, forKey: "ENDDATE")
        defaults.set(songType, forKey: "SONGTY")
        defaults.set(viewnewLbl.text, forKey: "Viws3")
        defaults.set(disnewLbl.text, forKey: "Distance3")
        defaults.set(ratenewLbl.text, forKey: "Rating3")
        defaults.set(str, forKey: "APICALL")
        defaults.set(anyallSts, forKey: "ANYALLSTS")
        defaults.set(pricearray, forKey: "GenAR")
        defaults.set(newstr, forKey: "FilterValue")
        defaults.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("SongFilter"), object: nil)
        navigationController?.popViewController(animated: true)
      
    }
    @IBAction func ClearFilterBtnAction(_ sender: Any) {
        self.pricearray.removeAllObjects()
        self.songGenreCollectionViuew.reloadData()
        self.startDateTxt.text = ""
        self.endDateTxt.text = ""
        coverBtn.backgroundColor = UIColor.clear
        orginleBtn.backgroundColor = UIColor.clear
        AllBtn.backgroundColor = UIColor.clear
        Config().AppUserDefaults.removeObject(forKey: "Distance3")
        Config().AppUserDefaults.removeObject(forKey: "Rating3")
        Config().AppUserDefaults.removeObject(forKey: "Viws3")
        defaults.removeObject(forKey: "APICALL")
        defaults.removeObject(forKey: "FilterValue")
        navigationController?.popViewController(animated: true)
        
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
    @IBAction func backBtnAction(_ sender: Any) {
        let comingFrom = "back"
        let defaults = UserDefaults.standard
        defaults.set(comingFrom, forKey: "BACK")
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchBtnAction(_ sender: UISwitch) {
        if sender.isOn == true {
            anyallSts = 2
        }else {
             anyallSts = 1
        }
    }
    
}
