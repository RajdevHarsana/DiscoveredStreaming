//
//  ViewController.swift
//  DiscoverStreaming
//
//  Created by tarun-mac-6 on 26/06/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var SignupBtn: UIButton!
    
    var defaults:UserDefaults!
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginBtn.layer.cornerRadius = 25
        SignupBtn.layer.borderColor = UIColor.white.cgColor
        SignupBtn.layer.borderWidth = 1
        SignupBtn.layer.cornerRadius = 25
         //move()
       
        
       // self.navigationController?.navigationBar.isHidden = true
       
        // Do any additional setup after loading the view.
    }
    func move() {
        defaults = UserDefaults.standard
        let LoginLogOutStatus = defaults.string(forKey: "Logoutstatus") as NSString?
        if LoginLogOutStatus == "1" {
            let navigate = storyboard!.instantiateViewController(withIdentifier: "tabbar")
           navigationController?.pushViewController(navigate, animated: true)
           
        }
        else {
            let navigate = storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            navigationController?.pushViewController(navigate, animated: true)
            
        }
        
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func SignBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

