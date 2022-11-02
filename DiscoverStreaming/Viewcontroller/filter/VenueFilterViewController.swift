//
//  VenueFilterViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 10/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class VenueFilterViewController: UIViewController {

    @IBOutlet weak var distanceSliderView: UISlider!
    @IBOutlet weak var distanceLowLbl: UILabel!
    @IBOutlet weak var distanceHighLbl: UILabel!
    @IBOutlet weak var sizelowLbl: UILabel!
    @IBOutlet weak var sizeSliederView: UISlider!
    @IBOutlet weak var sizelowerLbl: UILabel!
    @IBOutlet weak var ratingsliderView: UISlider!
    @IBOutlet weak var ratingHighLbl: UILabel!
    @IBOutlet weak var ratingLowLbl: UILabel!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var disnewLbl: UILabel!
    @IBOutlet weak var ratenewLbl: UILabel!
    @IBOutlet weak var cpacitynewlbl: UILabel!

    var defaults: UserDefaults!
    var saveVal: String!
    var Disatnce = DataManager.getVal(Config().AppUserDefaults.object(forKey: "Disatnce")) as? String ?? ""
    var Rating = DataManager.getVal(Config().AppUserDefaults.object(forKey: "Rating")) as? String ?? ""
    var Capcity = DataManager.getVal(Config().AppUserDefaults.object(forKey: "Capcity")) as? String ?? ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.defaults = UserDefaults.standard
        self.saveVal = self.defaults.value(forKey: "FilterValue3") as? String
        
        self.disnewLbl.text = self.Disatnce
        self.ratenewLbl.text = self.Rating
        self.cpacitynewlbl.text = self.Capcity
        

       if self.saveVal == "savevalue" {
        self.disnewLbl.isHidden = false
        self.ratenewLbl.isHidden = false
        self.cpacitynewlbl.isHidden = false

        self.disnewLbl.text = self.Disatnce
        self.ratenewLbl.text = self.Rating
        self.cpacitynewlbl.text = self.Capcity
        
        let myFloat1 = (self.Disatnce as NSString).floatValue
        let myFloat2 = (self.Rating as NSString).floatValue
        let myFloat3 = (self.Capcity as NSString).floatValue

        self.distanceSliderView.minimumValue = 0
        self.distanceSliderView.maximumValue = 10000
        self.distanceSliderView.isContinuous = true

        self.ratingsliderView.minimumValue = 0
        self.ratingsliderView.maximumValue = 100
        self.ratingsliderView.isContinuous = true

        self.sizeSliederView.minimumValue = 0
        self.sizeSliederView.maximumValue = 1000
        self.sizeSliederView.isContinuous = true

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: { self.distanceSliderView.value = myFloat1 }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: { self.ratingsliderView.value = myFloat2 }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: { self.sizeSliederView.value = myFloat3 }, completion: nil)

        
        }else{
        
        self.disnewLbl.isHidden = true
        self.ratenewLbl.isHidden = true
        self.cpacitynewlbl.isHidden = true
        defaults.removeObject(forKey: "FilterValue3")
        Config().AppUserDefaults.removeObject(forKey: "Disatnce")
        Config().AppUserDefaults.removeObject(forKey: "Rating")
        Config().AppUserDefaults.removeObject(forKey: "Capcity")
        defaults.removeObject(forKey: "APICALLVENUE")
        
        }
        
        
        self.applyBtn.layer.cornerRadius = 5
        self.clearBtn.layer.cornerRadius = 5
        
    }
    @IBAction func applyBtnAction(_ sender: Any) {
        var str:String!
        str = "APICallVenue"
        var newstr:String!
        newstr = "savevalue"
        let defaults = UserDefaults.standard
        defaults.set(self.disnewLbl.text, forKey: "Disatnce")
        defaults.set(self.ratenewLbl.text, forKey: "Rating")
        defaults.set(self.cpacitynewlbl.text, forKey: "Capcity")
        defaults.set(str, forKey: "APICALLVENUE")
        defaults.set(newstr, forKey: "FilterValue3")
        defaults.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("VenueFilter"), object: nil)
        
        navigationController?.popViewController(animated: true)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearBtnAction(_ sender: Any) {
        defaults.removeObject(forKey: "FilterValue3")
        Config().AppUserDefaults.removeObject(forKey: "Disatnce")
        Config().AppUserDefaults.removeObject(forKey: "Rating")
        Config().AppUserDefaults.removeObject(forKey: "Capcity")
        defaults.removeObject(forKey: "APICALLVENUE")
        navigationController?.popViewController(animated: true)
    }
    @IBAction func distanceSliderAction(_ sender: UISlider) {
        
        let currentValue = Int(sender.value)
        let str1 = String(currentValue)

        self.disnewLbl.isHidden = false
        self.disnewLbl.text = "0"
        self.disnewLbl.text = str1
    }
    @IBAction func sizeSliderAction(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        let str1 = String(currentValue)

        self.cpacitynewlbl.isHidden = false
        self.cpacitynewlbl.text =  "0"
        self.cpacitynewlbl.text = str1
    }
    @IBAction func RatingSliderAction(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        let str1 = String(currentValue)

        self.ratenewLbl.isHidden = false
        self.ratenewLbl.text = "0"
        self.ratenewLbl.text = str1
    }


}
