//
//  EventFilterViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 10/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class EventFilterViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var date1View: UIView!
    @IBOutlet weak var date2View: UIView!
    
    var datepicker:UIDatePicker! = UIDatePicker()
    var datepicker1:UIDatePicker! = UIDatePicker()
    
    @IBOutlet weak var distanceSliderview: UISlider!
    @IBOutlet weak var strDateTxt: UITextField!
    @IBOutlet weak var enddateTxt: UITextField!
    @IBOutlet weak var distanceLowLbl: UILabel!
    @IBOutlet weak var distanceHightLbl: UILabel!
    @IBOutlet weak var priceSliderview: UISlider!
    @IBOutlet weak var pricelowLbl: UILabel!
    @IBOutlet weak var priceHighLbl: UILabel!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var disnewLbl: UILabel!
    @IBOutlet weak var pricenewLbl: UILabel!
    
    
    var Disatnce = DataManager.getVal(Config().AppUserDefaults.object(forKey: "Distance1")) as? String ?? ""
    var Price = DataManager.getVal(Config().AppUserDefaults.object(forKey: "Price")) as? String ?? ""
    
    var defaults:UserDefaults!
    var saveVal:String!
    var sDate:String!
    var eDate:String!
    var views:String!
    var dis:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        saveVal = defaults.value(forKey: "FilterValue2") as? String
        sDate = defaults.value(forKey: "STRDATE") as? String
        eDate = defaults.value(forKey: "ENDDATE") as? String
        
        if saveVal == "savevalue" {
            disnewLbl.isHidden = false
            pricenewLbl.isHidden = false
            
            strDateTxt.text = sDate
            enddateTxt.text = eDate
            
            self.disnewLbl.text = self.Disatnce
            self.pricenewLbl.text = self.Price
            
            let myFloat = (self.Disatnce as NSString).floatValue
            let myFloat1 = (self.Price as NSString).floatValue

            self.distanceSliderview.minimumValue = 0
            self.distanceSliderview.maximumValue = 10000
            self.distanceSliderview.isContinuous = true

            self.priceSliderview.minimumValue = 0
            self.priceSliderview.maximumValue = 1000
            self.priceSliderview.isContinuous = true

            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: { self.distanceSliderview.value = myFloat }, completion: nil)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: { self.priceSliderview.value = myFloat1 }, completion: nil)
            
        }else {
            distanceSliderview.value = 0
            priceSliderview.value = 0
            
            disnewLbl.isHidden = true
            pricenewLbl.isHidden = true
            defaults.removeObject(forKey: "FilterValue2")
            Config().AppUserDefaults.removeObject(forKey: "Distance1")
            Config().AppUserDefaults.removeObject(forKey: "Price")
            defaults.removeObject(forKey: "APICALLEVENT")
            defaults.removeObject(forKey: "STRDATE")
            defaults.removeObject(forKey: "ENDDATE")
        }
        
        
        date1View.layer.cornerRadius = 5
        date2View.layer.cornerRadius = 5
        
        applyBtn.layer.cornerRadius = 5
        clearBtn.layer.cornerRadius = 5
        
        strDateTxt.delegate = self
        enddateTxt.delegate = self
        
        datepicker.datePickerMode = UIDatePicker.Mode.date
        strDateTxt.inputView = datepicker
    
        datepicker.addTarget(self, action: #selector(handleStartDatePicker(sender:)), for: UIControl.Event.valueChanged)
        
        datepicker1.datePickerMode = UIDatePicker.Mode.date
        enddateTxt.inputView = datepicker1
       // datepicker1.maximumDate = Date()
        datepicker1.addTarget(self, action: #selector(handleEndDatePicker(sender:)), for: UIControl.Event.valueChanged)
        
       

        // Do any additional setup after loading the view.
    }
    //MARK:- Date Button Action
    @objc func handleStartDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        strDateTxt.text = dateFormatter.string(from: sender.date)
        //startDateTxt = dateFormatter.string(from: sender.date) as NSString
    }
    
    //MARK:- Date Button Action
    @objc func handleEndDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        enddateTxt.text = dateFormatter.string(from: sender.date)
        // endDateTxt = dateFormatter.string(from: sender.date) as NSString
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == strDateTxt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: datepicker.date)
            strDateTxt.text = dateString
        }else if textField == enddateTxt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: datepicker1.date)
            enddateTxt.text = dateString
        }
    }
    
    @IBAction func distanceSliderBtnAction(_ sender: UISlider) {
         let currentValue = Int(sender.value)
         let str1 = String(currentValue)

         self.disnewLbl.isHidden = false
         self.disnewLbl.text = "0"
         self.disnewLbl.text = str1
    }
    @IBAction func priceSliderBtnAction(_ sender: UISlider) {
         let currentValue = Int(sender.value)
         let str1 = String(currentValue)

         self.pricenewLbl.isHidden = false
         self.pricenewLbl.text = "0"
         self.pricenewLbl.text = str1
    }
    @IBAction func applyBtnAction(_ sender: Any) {
        var str:String!
        str = "APICallevent"
        var newstr:String!
        newstr = "savevalue"
        let defaults = UserDefaults.standard
        defaults.set(strDateTxt.text, forKey: "STRDATE")
        defaults.set(enddateTxt.text, forKey: "ENDDATE")
        defaults.set(pricenewLbl.text, forKey: "Price")
        defaults.set(disnewLbl.text, forKey: "Distance1")
        defaults.set(str, forKey: "APICALLEVENT")
        defaults.set(newstr, forKey: "FilterValue2")
        defaults.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("EventFilter"), object: nil)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearBtnAction(_ sender: Any) {
        self.strDateTxt.text = ""
        self.enddateTxt.text = ""
        defaults.removeObject(forKey: "FilterValue2")
        Config().AppUserDefaults.removeObject(forKey: "Distance1")
        Config().AppUserDefaults.removeObject(forKey: "Price")
        defaults.removeObject(forKey: "APICALLEVENT")
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
    
    

}
