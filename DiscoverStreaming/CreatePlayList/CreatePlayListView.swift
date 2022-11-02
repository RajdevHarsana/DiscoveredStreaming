//
//  CreatePlayListView.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 19/02/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import SwiftToast

class CreatePlayListView: UIView, UITextFieldDelegate {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var TitleTxt: UITextField!
    var buttonDonehandler : ((_ playlistname : String)-> Void)?
    var buttonCancleHandler : (() -> Void)?
    class func intitiateFromNib() -> CreatePlayListView {
        let View1 = UINib.init(nibName: "CreatePlayListView", bundle: nil).instantiate(withOwner: self, options: nil).first as! CreatePlayListView
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBtn.layer.cornerRadius = 20
        TitleTxt.delegate = self
    }
    @IBAction func cancleBtnAction(_ sender: Any) {
        buttonCancleHandler?()
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        if TitleTxt.text == "" {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Please enter playlist titel!" , buttonTitle: "OK")
        }else if TitleTxt.text!.count <= 30{
            
        }else {
            self.buttonDonehandler?(TitleTxt.text!)
        }
       
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 30
        let currentString: NSString = (TitleTxt.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
}
