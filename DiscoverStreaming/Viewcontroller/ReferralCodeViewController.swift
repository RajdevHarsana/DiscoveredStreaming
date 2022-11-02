//
//  ReferralCodeViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 01/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ReferralCodeViewController: UIViewController {

    @IBOutlet weak var shareBtn: UIButton!
    var defaults:UserDefaults!
    var RefralScore:Int!
    var referalCode:String!
    
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var earnRefLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        RefralScore = defaults.integer(forKey: "REFPOINT")
        referalCode = defaults.value(forKey: "REFCODE") as? String
        var RefStr:String!
        RefStr = String(RefralScore)
        self.scoreLbl.text = "Score" + " " + RefStr + " " + "points for every referral!"
        self.earnRefLbl.text = "For every person who connect their utility after signing up with your unique referral code,you score" + " " + RefStr
        codeLbl.text = referalCode
        shareBtn.layer.cornerRadius = 25

        // Do any additional setup after loading the view.
    }
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareBtnAction(_ sender: Any) {
        //let text = "This is some text that I want to share."
        // set up activity view controller
        let textToShare = [ referalCode ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        activityViewController.popoverPresentationController?.sourceRect = self.navigationController?.navigationBar.frame ?? CGRect.zero
        activityViewController.popoverPresentationController?.sourceView = self.navigationController?.navigationBar
        self.present(activityViewController, animated: true)
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
