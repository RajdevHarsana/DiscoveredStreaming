//
//  ReportView.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 03/03/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class ReportView: UIView,UITextViewDelegate {

    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    var buttonDoneHandler : ((_ Reason : String) -> Void)?
    var buttonCancleHandler : (() -> Void)?
    var str_report:NSString!
    class func intitiateFromNib() -> ReportView {
        let View1 = UINib.init(nibName: "ReportView", bundle: nil).instantiate(withOwner: self, options: nil).first as! ReportView
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelBtn.layer.cornerRadius = 20
        submitBtn.layer.cornerRadius = 20
        textview.layer.cornerRadius = 2
        textview.delegate = self
        textview.text = "Reason"
    }
    
    // textview delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Reason" {
            textView.text = ""
            textView.textColor = UIColor.black
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
            let currentString: NSString = (textView.text ?? "Reason") as NSString
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
            textView.text = "Reason"
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    
    func validate(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }
    
    func validate(whiteSpaceString: String) -> Bool {
        return whiteSpaceString.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        str_report = textview.text as NSString?
        if str_report .isEqual(to: "Reason") {
             SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Please enter reason" , buttonTitle: "OK")
        }else {
           self.buttonDoneHandler?(textview.text)
        }
       
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        buttonCancleHandler?()
    }
    
}
