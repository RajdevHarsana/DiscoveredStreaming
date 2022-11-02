//
//  MyFollowingNewViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 16/01/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class MyFollowingNewViewController: UIViewController {

    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var artistBtn: UIButton!
    @IBOutlet weak var bandLbl: UILabel!
    @IBOutlet weak var bandBtn: UIButton!
    @IBOutlet weak var venueLbl: UILabel!
    @IBOutlet weak var venueBtn: UIButton!
    @IBOutlet weak var view_main: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistBtn.setTitleColor(UIColor.white, for: .normal)
        bandBtn.setTitleColor(UIColor.lightGray, for: .normal)
        venueBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        
        artistLbl.isHidden = false
        bandLbl.isHidden = true
        venueLbl.isHidden = true
        
        
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "ArtistFollowViewController") as! ArtistFollowViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)

        // Do any additional setup after loading the view.
    }
    func displayContentController(content: UIViewController) {
        addChild(content)
        self.view_main.addSubview(content.view)
        content.didMove(toParent: self)
    }
    
    
    @IBAction func artistBtnAction(_ sender: Any) {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        
        artistBtn.setTitleColor(UIColor.white, for: .normal)
        bandBtn.setTitleColor(UIColor.lightGray, for: .normal)
        venueBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        
        artistLbl.isHidden = false
        bandLbl.isHidden = true
        venueLbl.isHidden = true
        
        
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "ArtistFollowViewController") as! ArtistFollowViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    @IBAction func bandBtnAction(_ sender: Any) {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        
        artistBtn.setTitleColor(UIColor.lightGray, for: .normal)
        bandBtn.setTitleColor(UIColor.white, for: .normal)
        venueBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        artistLbl.isHidden = true
        bandLbl.isHidden = false
        venueLbl.isHidden = true
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "BandsFollowViewController") as! BandsFollowViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    @IBAction func venueBtnAction(_ sender: Any) {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        
        artistBtn.setTitleColor(UIColor.lightGray, for: .normal)
        bandBtn.setTitleColor(UIColor.lightGray, for: .normal)
        venueBtn.setTitleColor(UIColor.white, for: .normal)
        
        
        artistLbl.isHidden = true
        bandLbl.isHidden = true
        venueLbl.isHidden = false
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "VenuesFollowViewController") as! VenuesFollowViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
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
