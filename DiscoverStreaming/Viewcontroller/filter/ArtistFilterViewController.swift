//
//  ArtistFilterViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 10/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class ArtistFilterViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var artistgenreCollectionview: UICollectionView!
    var response = NSMutableArray()
    var genreArray = NSArray()
    var Genre_Id:Int!
    var selectedIndexes:NSMutableArray!
    var pricearray:NSMutableArray!
    
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var distancelowLbl: UILabel!
    @IBOutlet weak var distanceHighLbl: UILabel!
    @IBOutlet weak var ratingHightLbl: UILabel!
    @IBOutlet weak var ratingLowLbl: UILabel!
    @IBOutlet weak var numberOfviewHighLbl: UILabel!
    @IBOutlet weak var numberViewLowLbl: UILabel!
    @IBOutlet weak var distanceSliderView: UISlider!
    @IBOutlet weak var ratingSliderView: UISlider!
    @IBOutlet weak var numberOfviewSliderView: UISlider!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var disnewLbl: UILabel!
    @IBOutlet weak var ratenewLbl: UILabel!
    @IBOutlet weak var viewnewLbl: UILabel!
    var defaults:UserDefaults!
    
    fileprivate let prices: [Int] = [
        .min, 10, 100, 1000, 10000,.max,
    ]
    
    fileprivate let prices1: [Int] = [
        .min, 1000000, 100000, 10000, 1000,100,10,0,.max,
    ]
    
    fileprivate let prices2: [Int] = [
        .min, 99, 98, 97,96,95,94,93,92,91,90,89,88,87,86,85,84,83,82,81,80,79,78,77,76,75,74,73,72,71,70,69,68,67,66,65,64,63,62,61,60,59,58,57,56,55,54,53,52,51,50,49,48,47,46,45,44,43,42,41,40,39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,.max,
    ]
    
    var Disatnce = DataManager.getVal(Config().AppUserDefaults.object(forKey: "Disatnce2")) as? String ?? ""
    var Rating = DataManager.getVal(Config().AppUserDefaults.object(forKey: "Rating2")) as? String ?? ""
    var Views = DataManager.getVal(Config().AppUserDefaults.object(forKey: "Viws")) as? String ?? ""
    
    var saveVal:String!
    var views:String!
    var dis:String!
    var rate:String!
    var newarr:NSArray!
    var slidVal:Int!
    var anyallSts:Int!
    var anyAll:Int!
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
                self.artistgenreCollectionview.reloadData()
                self.removeAllOverlays()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        saveVal = defaults.value(forKey: "FilterValue1") as? String
        newarr = defaults.array(forKey: "GenAR") as NSArray?
        slidVal = defaults.integer(forKey: "SliderIndex")
        anyAll = defaults.integer(forKey: "ANYALLSTS")
        pricearray = NSMutableArray()
        selectedIndexes = NSMutableArray()
        
        self.disnewLbl.text = self.Disatnce
        self.ratenewLbl.text = self.Rating
        self.viewnewLbl.text = self.Views
        
        if saveVal == "savevalue" {
            disnewLbl.isHidden = false
            ratenewLbl.isHidden = false
            viewnewLbl.isHidden = false
            
            
            self.disnewLbl.text = self.Disatnce
            self.ratenewLbl.text = self.Rating
            self.viewnewLbl.text = self.Views
            
            let myFloat1 = (self.Disatnce as NSString).floatValue
            let myFloat2 = (self.Rating as NSString).floatValue
            let myFloat3 = (self.Views as NSString).floatValue

            self.distanceSliderView.minimumValue = 0
            self.distanceSliderView.maximumValue = 10000
            self.distanceSliderView.isContinuous = true

            self.ratingSliderView.minimumValue = 0
            self.ratingSliderView.maximumValue = 100
            self.ratingSliderView.isContinuous = true

            self.numberOfviewSliderView.minimumValue = 0
            self.numberOfviewSliderView.maximumValue = 1000
            self.numberOfviewSliderView.isContinuous = true

            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: { self.distanceSliderView.value = myFloat1 }, completion: nil)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: { self.ratingSliderView.value = myFloat2 }, completion: nil)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: { self.numberOfviewSliderView.value = myFloat3 }, completion: nil)
            
            pricearray = NSMutableArray(array: newarr)
            if anyAll == 1 {
                switchBtn.isOn = false
            }else if anyAll == 2 {
                switchBtn.isOn = true
            }
            else {
                switchBtn.isOn = false
            }
        }else {
            ratenewLbl.text = ""
            anyallSts = 1
            disnewLbl.text = ""
            viewnewLbl.text = ""
            disnewLbl.isHidden = true
            ratenewLbl.isHidden = true
            viewnewLbl.isHidden = true
            Config().AppUserDefaults.removeObject(forKey: "Disatnce2")
            Config().AppUserDefaults.removeObject(forKey: "Rating2")
            Config().AppUserDefaults.removeObject(forKey: "Viws")
            defaults.removeObject(forKey: "APICALLAR")
            defaults.removeObject(forKey: "FilterValue1")

            
        }
        
        
        
//        disnewLbl.isHidden = true
//        ratenewLbl.isHidden = true
//        viewnewLbl.isHidden = true
        
        applyBtn.layer.cornerRadius = 5
        clearBtn.layer.cornerRadius = 5
        
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
        }


        // Do any additional setup after loading the view.
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ArtistGenresFilterCell
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
        artistgenreCollectionview.reloadItems(at: [indexPath as IndexPath])
        artistgenreCollectionview.reloadData()
    }
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearBtnAcion(_ sender: Any) {
        self.pricearray.removeAllObjects()
        self.artistgenreCollectionview.reloadData()
        Config().AppUserDefaults.removeObject(forKey: "Disatnce2")
        Config().AppUserDefaults.removeObject(forKey: "Rating2")
        Config().AppUserDefaults.removeObject(forKey: "Viws")
        defaults.removeObject(forKey: "APICALLAR")
        defaults.removeObject(forKey: "FilterValue1")
        navigationController?.popViewController(animated: true)
    }
    @IBAction func applyBtnAction(_ sender: Any) {
        let  typeIdArrayString = self.JSONStringify(value: pricearray as AnyObject)
        print(typeIdArrayString)
        var str:String!
        str = "APICallArtist"
        var newstr:String!
        newstr = "savevalue"
        let defaults = UserDefaults.standard
        defaults.set(typeIdArrayString, forKey: "GENER")
        defaults.set(viewnewLbl.text, forKey: "Viws")
        defaults.set(disnewLbl.text, forKey: "Disatnce2")
        defaults.set(ratenewLbl.text, forKey: "Rating2")
        defaults.set(str, forKey: "APICALLAR")
        defaults.set(pricearray, forKey: "GenAR")
        defaults.set(anyallSts, forKey: "ANYALLSTS")
        defaults.set(newstr, forKey: "FilterValue1")
        defaults.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("ArtistFilter"), object: nil)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func numberOfviewSliderAction(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        let str1 = String(currentValue)

        self.viewnewLbl.isHidden = false
        self.viewnewLbl.text = "0"
        self.viewnewLbl.text = str1
    }
    
    @IBAction func ratingSliderAction(_ sender: UISlider) {
         let currentValue = Int(sender.value)
         let str1 = String(currentValue)

         self.ratenewLbl.isHidden = false
         self.ratenewLbl.text = "0"
         self.ratenewLbl.text = str1
    }
    @IBAction func distanceSliderAction(_ sender: UISlider) {
           let currentValue = Int(sender.value)
           let str1 = String(currentValue)

           self.disnewLbl.isHidden = false
           self.disnewLbl.text = "0"
           self.disnewLbl.text = str1
    }
    @IBAction func switchBtnAction(_ sender: UISwitch) {
        if sender.isOn == true {
            anyallSts = 2
        }else {
            anyallSts = 1
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
