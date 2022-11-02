//
//  BookTicketsViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class BookTicketsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var noofTicketsTxt: FloatLabelTextField!
    @IBOutlet weak var nameTxt: FloatLabelTextField!
    @IBOutlet weak var contactTxt: FloatLabelTextField!
    @IBOutlet weak var emailTxt: FloatLabelTextField!
    var eventname:String!
    var venuename:String!
    var venImage:String!
    var price:String!
    var addresven:String!
    var datetime:String!
    var defaults:UserDefaults!
    var str_ticket:NSString!
    var str_email:NSString!
    var str_contact:NSString!
    var str_name:NSString!
    var lefttic:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        eventname = defaults.value(forKey: "NEVE") as? String
        venuename = defaults.value(forKey: "NVEN") as? String
        price = defaults.value(forKey: "PriceEve") as? String
        datetime = defaults.value(forKey: "DTEVE") as? String
        addresven = defaults.value(forKey: "ADDEVE") as? String
        venImage = defaults.value(forKey: "ImageEVE") as? String
        lefttic = defaults.integer(forKey: "Tickleft")
        self.eventImage.sd_setImage(with: URL(string: (venImage)!), placeholderImage: UIImage(named: "Group 4-1"))
        self.eventNameLbl.text = eventname
        self.venueNameLbl.text = "Venue:" + " " + venuename
        self.dateTimeLbl.text = datetime
        self.addressLbl.text = addresven
        self.amountLbl.text = "$\(price ?? "")"
        submitBtn.layer.cornerRadius = 25
        noofTicketsTxt.delegate = self
        noofTicketsTxt.attributedPlaceholder = NSAttributedString(string:"No. of tickets", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        // Do any additional setup after loading the view.
    }
    @IBAction func submitBtnAction(_ sender: Any) {
        str_ticket = noofTicketsTxt.text as NSString?
       // str_name = nameTxt.text as NSString?
       // str_contact = contactTxt.text as NSString?
      //  str_email = emailTxt.text as NSString?
        var ticleft = String()
        ticleft = String(lefttic)
        var tick = String()
        tick = str_ticket as String
        var NewInt:Int!
        NewInt = Int(tick)
        if str_ticket .isEqual(to: "") {
            let test =  SwiftToast(
                text: "Please Enter ticket number",
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
            
        } else if NewInt > 10 {
               let test =  SwiftToast(
                   text: "Ticket number should not be more then 10.",
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
        else if NewInt > lefttic {
            let test =  SwiftToast(
                text: "No tickets available",
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
//        else  if str_name .isEqual(to: "") {
//            let test =  SwiftToast(
//                text: "Please Enter name",
//                textAlignment: .center,
//                image: UIImage(named: "Icon-App-29x29"),
//                backgroundColor: .purple,
//                textColor: .white,
//                font: .boldSystemFont(ofSize: 15.0),
//                duration: 2.0,
//                minimumHeight: CGFloat(80.0),
//                aboveStatusBar: false,
//                target: nil,
//                style: .navigationBar)
//            self.present(test, animated: true)
//        }else  if str_contact .isEqual(to: "") {
//            let test =  SwiftToast(
//                text: "Please Enter contact number",
//                textAlignment: .center,
//                image: UIImage(named: "Icon-App-29x29"),
//                backgroundColor: .purple,
//                textColor: .white,
//                font: .boldSystemFont(ofSize: 15.0),
//                duration: 2.0,
//                minimumHeight: CGFloat(80.0),
//                aboveStatusBar: false,
//                target: nil,
//                style: .navigationBar)
//            self.present(test, animated: true)
//        } else if str_contact.length < 6 || str_contact.length > 15 {
//            let test =  SwiftToast(
//                text: "Contact number should be in 7-15 digits",
//                textAlignment: .center,
//                image: UIImage(named: "Icon-App-29x29"),
//                backgroundColor: .purple,
//                textColor: .white,
//                font: .boldSystemFont(ofSize: 15.0),
//                duration: 2.0,
//                minimumHeight: CGFloat(80.0),
//                aboveStatusBar: false,
//                target: nil,
//                style: .navigationBar)
//            self.present(test, animated: true)
//        }
//        else  if str_email .isEqual(to: "") {
//            let test =  SwiftToast(
//                text: "Please Enter email",
//                textAlignment: .center,
//                image: UIImage(named: "Icon-App-29x29"),
//                backgroundColor: .purple,
//                textColor: .white,
//                font: .boldSystemFont(ofSize: 15.0),
//                duration: 2.0,
//                minimumHeight: CGFloat(80.0),
//                aboveStatusBar: false,
//                target: nil,
//                style: .navigationBar)
//            self.present(test, animated: true)
//        }
        else {
            //if isValidEmail(str_email as String){
                 let defaults = UserDefaults.standard
                 defaults.set(str_ticket, forKey: "TICNo")
                // defaults.set(str_name, forKey: "BookName")
                // defaults.set(str_contact, forKey: "BookCon")
               //  defaults.set(str_email, forKey: "BookEmail")
                 defaults.synchronize()
                let vc = storyboard?.instantiateViewController(withIdentifier: "OrderSummaryViewController") as! OrderSummaryViewController
                navigationController?.pushViewController(vc, animated: true)
          //  }
//            else {
//                let test =  SwiftToast(
//                    text: "Please Enter Correct Email Id",
//                    textAlignment: .center,
//                    image: UIImage(named: "Icon-App-29x29"),
//                    backgroundColor: .purple,
//                    textColor: .white,
//                    font: .boldSystemFont(ofSize: 15.0),
//                    duration: 2.0,
//                    minimumHeight: CGFloat(80.0),
//                    aboveStatusBar: false,
//                    target: nil,
//                    style: .navigationBar)
//                self.present(test, animated: true)
//            }
        }
        
        
       
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
